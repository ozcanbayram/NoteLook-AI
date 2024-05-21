import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_ai/firebase_options.dart';
import 'package:note_ai/screens/first_screen.dart';
import 'package:note_ai/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase başlatma işlemi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Kullanıcının oturum durumunu kontrol et
  final currentUser = FirebaseAuth.instance.currentUser;
  Widget initialRoute = (currentUser != null) ? MainScreen() : FirstScreen();

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final Widget initialRoute;

  const MyApp({required this.initialRoute, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoteAI',
      theme: ThemeData.dark().copyWith( // Dark tema oluşturuldu
        scaffoldBackgroundColor: Colors.black, // Arka plan rengi
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: Colors.white,
          secondary: Colors.amber,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.lightGreenAccent,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.lightGreenAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardColor: Colors.grey[900],
        cardTheme: CardTheme(
          shadowColor: Colors.transparent,
          elevation: 0,
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color.fromARGB(255, 18, 18, 18),
          foregroundColor: Colors.lightGreen,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey;
              }
              return const Color.fromARGB(255, 18, 18, 18);
            }),
            foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.white;
              }
              return Colors.lightGreen;
            }),
            textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
            shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: const Color.fromARGB(255, 18, 18, 18),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.lightGreenAccent, fontSize: 20, fontWeight: FontWeight.bold),
          contentTextStyle: TextStyle(color: Colors.lightGreenAccent),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          hintStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold),
        ),
      ),
      home: initialRoute,
    );
  }
}
