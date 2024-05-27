import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_ai/product/custom_widgets.dart';
import 'package:note_ai/product/project_texts.dart';
import 'package:note_ai/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Firebase kaydı
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Başarılı kaydın ardından giriş ekranına yönlendir
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ProjectTexts().successRegister),
          ),
        );
      } on FirebaseAuthException catch (e) {
        // ignore: avoid_print
        print('${ProjectTexts().failRegister}: ${e.code}');

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${ProjectTexts().failRegister}: ${e.message}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ProjectTexts().registerButton)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _emailController,
                labeltext: ProjectTexts().emailLabelText,
                errorMessage: ProjectTexts().emailErrorMessage,
                fieldType: false,
              ),
              const CustomSizedBox(),
              CustomTextField(
                controller: _passwordController,
                labeltext: ProjectTexts().passwordLabelText,
                errorMessage: ProjectTexts().passwordErrorMessage,
                fieldType: true,
              ),
              const CustomSizedBox(),
              ElevatedButton(
                onPressed: _register,
                child: Text(ProjectTexts().registerButton),
              ),
              const CustomSizedBox(),
              CustomTextButton(
                targetText: const LoginScreen(),
                title: ProjectTexts().registerTextButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
