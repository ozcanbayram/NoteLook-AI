import 'package:flutter/material.dart';

// CUSTOM SIZEDBOX
class CustomSizedBox extends StatelessWidget {
  const CustomSizedBox({
    super.key,
    this.boxSize = 20.0, // Varsayılan değeri burada belirtiyoruz
  });
  final double boxSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: boxSize,
    );
  }
}

// CUSTOM TEXT WIDGET FOR FIRST SCREENS TEXT
class FirstScreenTexts extends StatelessWidget {
  const FirstScreenTexts({
    super.key,
    required this.title,
    required this.textColor,
  });
  final String title;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        color: textColor,
      ),
    );
  }
}

//CUSTOM NAVIGATOR BUTTON
class NavigatorButton extends StatelessWidget {
  final Widget targetScreen; //For target a new page - widget
  final String buttonText;
  const NavigatorButton({
    super.key,
    required this.targetScreen,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the specified screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Text(buttonText),
    );
  }
}

// CUSTOM TEXT FORM FIELD
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.labeltext,
    required this.errorMessage,
    required this.fieldType, required this.lineLimit,
  });

  final TextEditingController controller;
  final String labeltext;
  final String errorMessage;
  final bool fieldType;
  final int? lineLimit;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: lineLimit,
      controller: controller,
      obscureText: fieldType,
      decoration: InputDecoration(
        labelText: labeltext,
        labelStyle: const TextStyle(color: Colors.white),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
    );
  }
}

// CUSTOM TEXT BUTTON
class CustomTextButton extends StatelessWidget {
  final Widget targetText;
  final String title;
  const CustomTextButton({
    super.key,
    required this.targetText,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Kayıt ekranına yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => targetText),
        );
      },
      child: Text(title),
    );
  }
}
