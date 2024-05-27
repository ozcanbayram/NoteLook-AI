import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_ai/product/custom_widgets.dart';
import 'package:note_ai/product/project_texts.dart';
import 'package:note_ai/screens/main_screen.dart';
import 'package:note_ai/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //FIREBASE
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Firebase giriş işlemi
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Başarılı girişin ardından ana sayfaya yönlendir
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ProjectTexts().successLogin)),
        );
      } on FirebaseAuthException catch (e) {
        // ignore: avoid_print
        print('${ProjectTexts().failLogin}: ${e.message}'); // for any error

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${ProjectTexts().failLogin}: ${e.message}',
            ),
          ), // for any error
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ProjectTexts().loginButton)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // E-posta ve şifre giriş alanları
              CustomTextField(lineLimit: 1,
                fieldType: false,
                controller: _emailController,
                labeltext: ProjectTexts().emailLabelText,
                errorMessage: ProjectTexts().emailErrorMessage,
              ),
              const CustomSizedBox(),
              CustomTextField(lineLimit: 1,
                fieldType: true,
                controller: _passwordController,
                labeltext: ProjectTexts().passwordLabelText,
                errorMessage: ProjectTexts().passwordErrorMessage,
              ),
              const CustomSizedBox(),
              ElevatedButton(
                onPressed: (_login),
                child: Text(ProjectTexts().loginButton),
              ),
              const CustomSizedBox(),
              // Diger seçenekler
              CustomTextButton(
                  targetText: const RegisterScreen(),
                  title: ProjectTexts().loginTextButton)
            ],
          ),
        ),
      ),
    );
  }
}
