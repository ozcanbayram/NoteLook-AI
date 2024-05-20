import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_ai/screens/main_screen.dart';
import 'package:note_ai/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
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

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Firebase giriş işlemi
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        print('Giriş başarılı');

        // Başarılı girişin ardından ana sayfaya yönlendir
        Navigator.pushReplacement(
          
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
          
        );
        const SnackBar(
            content: Text('Giriş başarılı'),
          );
        
      } on FirebaseAuthException catch (e) {
        print('Giriş başarısız: ${e.code}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Giriş başarısız: ${e.message}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Yap')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // E-posta ve şifre giriş alanları
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Giriş Yap'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Kayıt ekranına yönlendir
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: const Text('Hesabınız yok mu? Kaydolun'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
