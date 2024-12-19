import 'dart:math';
import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> answers;

  const ResultsPage({Key? key, required this.answers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Récupération des réponses avec logique
    final genreEntry =
        answers.firstWhere((e) => e['stepId'] == '2', orElse: () => {});
    final genre =
        genreEntry['answer'] == 'BooleanResult.POSITIVE' ? 'Homme' : 'Femme';

    final ageEntry =
        answers.firstWhere((e) => e['stepId'] == '31', orElse: () => {});
    final age = ageEntry['answer'] ?? 'Non spécifié';

    final regionEntry =
        answers.firstWhere((e) => e['stepId'] == '41', orElse: () => {});
    final region = regionEntry['answer'] ?? 'Aucune région';

    final tailleEntry =
        answers.firstWhere((e) => e['stepId'] == '51', orElse: () => {});
    final taille = tailleEntry['answer'] ?? 'Non spécifiée';

    final revenuEntry =
        answers.firstWhere((e) => e['stepId'] == '61', orElse: () => {});
    final revenu = revenuEntry['answer'] ?? '...';

    final taillePourcentage = ((double.tryParse(taille) ?? 0) / 200) ;
    final revenuPourcentage = (1 - (double.tryParse(revenu) ?? 0) / 100000) ;
    print("Taille : $taillePourcentage, Revenu : $revenuPourcentage");
    final probabilite = revenuPourcentage*taillePourcentage*100; // Probabilité entre 0 et 100
    double delusion = 1 - (probabilite / 100);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                "Votre probabilité de trouver le partenaire de vos rêve :",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color.fromARGB(255, 145, 136, 161).withOpacity(0.2),
                child: Icon(
                  genre == 'Homme' ? Icons.male : Icons.female,
                  size: 60,
                  color:
                      genre == 'Homme' ? Colors.blueAccent : Colors.pinkAccent,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Probabilité : ${probabilite.toStringAsFixed(2)}%",
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 65, 86, 202)),
              ),
              const SizedBox(height: 20),
              _buildDelusionSlider(delusion),
              const SizedBox(height: 20),
              _buildCriteriaCard(genre, age, region, taille, revenu),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check),
                label: const Text("Terminer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDelusionSlider(double delusion) {
    return Column(
      children: [
        const Text(
          "Degré d'illusion",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Slider(
          value: delusion,
          onChanged: (_) {},
          min: 0,
          max: 1,
          activeColor: const Color.fromARGB(255, 101, 100, 112),
        ),
      ],
    );
  }

  Widget _buildCriteriaCard(
      String genre, String age, String region, String taille, String revenu) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultRow(Icons.person, "Genre", genre),
            _buildResultRow(Icons.cake, "Âge minimal", age),
            _buildResultRow(Icons.location_on, "Région", region),
            _buildResultRow(Icons.height, "Taille idéale", "$taille cm"),
            _buildResultRow(
                Icons.attach_money, "Revenu minimal", "$revenu euros/an"),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF6C63FF)),
          const SizedBox(width: 10),
          Text(
            "$label : ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
