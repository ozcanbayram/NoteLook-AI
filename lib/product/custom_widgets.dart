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

