import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_ai/firebase_options.dart';
import 'package:note_ai/product/project_texts.dart';
import 'package:note_ai/screens/first_screen.dart';
import 'package:note_ai/screens/main_screen.dart';
import 'package:note_ai/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase başlatma işlemi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Kullanıcının oturum durumunu kontrol et
  final currentUser = FirebaseAuth.instance.currentUser;
  Widget initialRoute =
      (currentUser != null) ? MainScreen() : const FirstScreen();

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final Widget initialRoute;

  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ProjectTexts().projectName,
      theme: appTheme, // Tema burada kullanılıyor
      home: initialRoute,
    );
  }
}
