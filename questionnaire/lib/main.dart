import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/features/app/splash_screen/splash_screen.dart';
import 'package:questionnaire/features/user_auth/presentation/pages/home_page.dart';
import 'package:questionnaire/features/user_auth/presentation/pages/login_page.dart';
import 'package:questionnaire/features/user_auth/presentation/pages/sign_up_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCs0gfoWDtPBQpuEM2GsfxyY_9L9L6N1Y8",
        appId: "1:486227126589:web:cf8e836fae54cd1c217d54",
        messagingSenderId: "486227126589",
        projectId: "questionnaire-7b577",
        // web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => SplashScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          child: LoginPage(),
        ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}