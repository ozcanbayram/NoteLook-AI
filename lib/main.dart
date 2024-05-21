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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: Colors.white,  // Birincil renk
          secondary: Colors.amber,     // İkincil renk
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black, // AppBar arka plan rengi
          foregroundColor: Colors.lightGreenAccent, // AppBar üzerindeki öğelerin rengi
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.lightGreenAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackgroundColor: Colors.black, // Arka plan rengi
        cardColor: Colors.grey[900], // Kart arka plan rengi
        cardTheme: CardTheme(
          shadowColor: Colors.transparent, // Kart gölgesini kaldır
          elevation: 0, // Kart yüksekliğini sıfıra ayarla
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white), // Kart içerisindeki yazılar
          bodyText2: TextStyle(color: Colors.white), // Kart içerisindeki yazılar
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color.fromARGB(255, 18, 18, 18), // Buton arka plan rengi
          foregroundColor: Colors.lightGreen, // Buton üzerindeki ikon rengi
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey;
              }
              return const Color.fromARGB(255, 18, 18, 18);
            }), // Buton arka plan rengi
            foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.white;
              }
              return Colors.lightGreen;
            }), // Buton üzerindeki yazı rengi
            textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Buton yazı stili
            minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)), // Buton boyutu
            shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))), // Buton kenar yuvarlatması
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: const Color.fromARGB(255, 18, 18, 18), // Menü arka plan rengi
        ),
        iconTheme: IconThemeData(color: Colors.white), // Menü simgesi rengi
        dialogTheme: DialogTheme( // Alert dialog teması
          backgroundColor: Colors.black, // Arka plan rengi
          titleTextStyle: TextStyle(color: Colors.lightGreenAccent, fontSize: 20, fontWeight: FontWeight.bold), // Başlık yazı stili
          contentTextStyle: TextStyle(color: Colors.lightGreenAccent), // İçerik yazı stili
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, // Buton yazı rengi
            backgroundColor: Colors.transparent, // Buton arka plan rengi
            textStyle: TextStyle(fontWeight: FontWeight.bold), // Yazı stili
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true, // Alanı doldur
          fillColor: Colors.grey[800], // Alan arka plan rengi
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Kenar yuvarlatması
            borderSide: BorderSide.none, // Kenar çizgisi olmayacak
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // İçerik dolgusu
          hintStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold), // İpucu yazısı rengi ve fontu
        ),
      ),
      home: initialRoute,
    );
  }
}
