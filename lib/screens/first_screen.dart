import 'package:flutter/material.dart';
import 'package:note_ai/product/project_texts.dart';
import 'package:note_ai/screens/login_screen.dart';
import 'package:note_ai/screens/register_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ProjectTexts().projectName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Yapay zeka ile notlarınızı geliştirin.',
              style: TextStyle(fontSize: 18, color: Colors.lightBlueAccent),
            ),
            SizedBox(height: 10,),
             Text('NoteLook & AI',style: TextStyle(fontSize: 18, color: Colors.lightGreen),),
            SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                // Navigate to login screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Text('Giriş Yap'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to register screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: const Text('Kayıt Ol'),
            ),
            SizedBox(height: 20),
            
           
          ],
        ),
      ),
    );
  }
}
