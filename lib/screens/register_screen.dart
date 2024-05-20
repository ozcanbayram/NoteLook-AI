import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email input field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen geçerli bir e-posta girin.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Password input field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir şifre girin.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              // Register button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Placeholder: Implement registration functionality here
                    // ...
                  }
                },
                child: const Text('Kayıt Ol'),
              ),
              SizedBox(height: 20),
              // Already have an account link
              TextButton(
                onPressed: () {
                  // Navigate to login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: const Text('Zaten hesabınız var mı?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
