import 'package:flutter/material.dart';
import 'package:note_ai/product/project_colors.dart';
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
            //TEXTS
            FirstScreenTexts(
                title: ProjectTexts().welcomeText,
                textColor: ProjectColors.secondColor),
            const CustomSizedBox(boxSize: 8),
            FirstScreenTexts(
                title: ProjectTexts().welcomeProjectName,
                textColor: ProjectColors.firstColor),
            const CustomSizedBox(boxSize: 100),
            //BUTTONS
            NavigatorButton(
                targetScreen: const LoginScreen(),
                buttonText: ProjectTexts().loginButton),
            const CustomSizedBox(),
            NavigatorButton(
                targetScreen: const RegisterScreen(),
                buttonText: ProjectTexts().registerButton),
            const CustomSizedBox(),
          ],
        ),
      ),
    );
  }
}
