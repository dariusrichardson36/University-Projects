import 'package:flutter/material.dart';

class FitBuddyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double fontSize;

  const FitBuddyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}