import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:survey_kit/survey_kit.dart' as survey_kit;

class SurveyPage extends StatefulWidget {
  const SurveyPage({Key? key}) : super(key: key);

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  late Future<survey_kit.NavigableTask> _taskFuture;

  @override
  void initState() {
    super.initState();
    _taskFuture = _buildTask();
  }

  Future<survey_kit.NavigableTask> _buildTask() async {
    final String jsonContent =
        await rootBundle.loadString('assets/example_json.json');
    final Map<String, dynamic> json = jsonDecode(jsonContent);

    final List<survey_kit.Step> steps = _buildSteps(json['steps']);
    final task = survey_kit.NavigableTask(
      id: survey_kit.TaskIdentifier(id: json['id']),
      steps: steps,
    );

    if (json['rules'] != null) {
      for (final rule in json['rules']) {
        final String triggerId = rule['triggerStepIdentifier']['id'];
        switch (rule['type']) {
          case 'direct':
            task.addNavigationRule(
              forTriggerStepIdentifier:
                  survey_kit.StepIdentifier(id: triggerId),
              navigationRule: survey_kit.DirectNavigationRule(
                survey_kit.StepIdentifier(
                    id: rule['destinationStepIdentifier']['id']),
              ),
            );
            break;
          case 'conditional':
            task.addNavigationRule(
              forTriggerStepIdentifier:
                  survey_kit.StepIdentifier(id: triggerId),
              navigationRule: survey_kit.ConditionalNavigationRule(
                resultToStepIdentifierMapper: (input) {
                  final values = rule['values'];
                  return survey_kit.StepIdentifier(
                    id: values[input] ?? 'completion',
                  );
                },
              ),
            );
            break;
        }
      }
    }
    return task;
  }

  List<survey_kit.Step> _buildSteps(List<dynamic> stepsJson) {
    return stepsJson.map<survey_kit.Step>((dynamic step) {
      final String id = step['stepIdentifier']['id'];
      switch (step['type']) {
        case 'intro':
          return survey_kit.InstructionStep(
            stepIdentifier: survey_kit.StepIdentifier(id: id),
            title: step['title'],
            text: step['text'],
            buttonText: step['buttonText'] ?? 'Next',
          );
        case 'question':
          final answerFormatType = step['answerFormat']['type'];
          if (answerFormatType == 'bool') {
            return survey_kit.QuestionStep(
              stepIdentifier: survey_kit.StepIdentifier(id: id),
              title: step['title'],
              answerFormat: survey_kit.BooleanAnswerFormat(
                positiveAnswer: step['answerFormat']['positiveAnswer'],
                negativeAnswer: step['answerFormat']['negativeAnswer'],
              ),
            );
          } else if (answerFormatType == 'scale') {
            return survey_kit.QuestionStep(
              stepIdentifier: survey_kit.StepIdentifier(id: id),
              title: step['title'],
              answerFormat: survey_kit.ScaleAnswerFormat(
                minimumValue: step['answerFormat']['minimumValue'].toDouble(),
                maximumValue: step['answerFormat']['maximumValue'].toDouble(),
                step: step['answerFormat']['step'].toDouble(),
                defaultValue: step['answerFormat']['defaultValue'].toDouble(),
              ),
            );
          } else if (answerFormatType == 'multiple') {
            return survey_kit.QuestionStep(
              stepIdentifier: survey_kit.StepIdentifier(id: id),
              title: step['title'],
              answerFormat: survey_kit.MultipleChoiceAnswerFormat(
                textChoices: (step['answerFormat']['textChoices'] as List)
                    .map((choice) => survey_kit.TextChoice(
                          text: choice['text'],
                          value: choice['value'],
                        ))
                    .toList(),
              ),
            );
          }
          break;
        case 'completion':
          return survey_kit.CompletionStep(
            stepIdentifier: survey_kit.StepIdentifier(id: id),
            title: step['title'],
            text: step['text'],
            buttonText: step['buttonText'] ?? 'Finish',
          );
      }
      throw Exception('Unknown step type: ${step['type']}');
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 206, 223), // Couleur de fond pastel
            
      body: FutureBuilder<survey_kit.NavigableTask>(
        future: _taskFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return survey_kit.SurveyKit(
            task: snapshot.data!,
            onResult: (result) {
              final answers = _extractSurveyResults(result);
              Navigator.pushReplacementNamed(
                context,
                '/results',
                arguments: answers,
              );
            },
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _extractSurveyResults(
      survey_kit.SurveyResult result) {
    return result.results.map<Map<String, dynamic>>((step) {
      final stepResult = step.results.isNotEmpty ? step.results.first : null;
      final answer =
          stepResult != null ? _extractAnswer(stepResult) : 'No answer';
      return {'stepId': step.id?.id, 'answer': answer};
    }).toList();
  }

  String _extractAnswer(survey_kit.QuestionResult result) {
    if (result is survey_kit.BooleanQuestionResult) {
      return result.result?.toString() ?? 'No answer';
    } else if (result is survey_kit.ScaleQuestionResult) {
      return result.result?.toString() ?? 'No answer';
    } else if (result is survey_kit.TextQuestionResult) {
      return result.result ?? 'No answer';
    } else if (result is survey_kit.MultipleChoiceQuestionResult) {
      return result.result?.map((choice) => choice.value).join(', ') ??
          'No answer';
    } else {
      return 'Unsupported format';
    }
  }
}
