import 'package:flutter/material.dart';
import 'package:note_ai/product/custom_widgets.dart';
import 'package:note_ai/product/project_texts.dart';
import 'package:note_ai/screens/login_screen.dart';
import 'package:note_ai/screens/register_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

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
            //WELCOME TEXT & SPECIAL STYLES
            Text(
              ProjectTexts().welcomeText,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.lightBlueAccent,
              ),
            ),
            const CustomSizedBox(boxSize: 8),
            Text(
              ProjectTexts().welcomeProjectName,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.lightGreen,
              ),
            ),
            const CustomSizedBox(boxSize: 100),
            ElevatedButton(
              onPressed: () {
                // Navigate to login screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Text(ProjectTexts().loginButton),
            ),
            const CustomSizedBox(),
            ElevatedButton(
              onPressed: () {
                // Navigate to register screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              child: Text(ProjectTexts().registerButton),
            ),
            const CustomSizedBox(),
          ],
        ),
      ),
    );
  }
}
