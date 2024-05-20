import 'package:flutter/material.dart';
import 'package:note_ai/screens/main_screen.dart';
import 'package:note_ai/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş')),
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
              // Login button
              ElevatedButton(
                onPressed: () {
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
                  if (_formKey.currentState!.validate()) {
                    // Placeholder: Implement login functionality here
                    // ...
                  }
                },
                child: const Text('Giriş Yap'),
              ),
              SizedBox(height: 20),
              // Forgot password link
              TextButton(
                onPressed: () {
                  // Placeholder: Implement forgot password functionality
                  // ...
                },
                child: const Text('Şifreyi Unuttun mu?'),
              ),
              SizedBox(height: 20),
              // Register link
              TextButton(
                onPressed: () {
                  // Navigate to register screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: const Text('Kayıt Ol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
