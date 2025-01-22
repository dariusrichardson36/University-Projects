import 'package:flutter/material.dart';
import 'package:fit_buddy/constants/color_constants.dart';
import '../theme/theme_constants.dart';

class FitBuddyTextFormField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool isPassword;

  final String? Function(dynamic value) validator;
  final Icon? icon;

  const FitBuddyTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isPassword,
    required this.validator,
    this.icon,
  });

  @override
  State<FitBuddyTextFormField> createState() => _FitBuddyTextFormFieldState();
}

class _FitBuddyTextFormFieldState extends State<FitBuddyTextFormField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        validator: widget.validator,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: FitBuddyColorConstants.lOnSecondary),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: FitBuddyColorConstants.lError),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: FitBuddyColorConstants.lError),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: FitBuddyColorConstants.lOnSecondary),
          ),
          fillColor: fitBuddyLightTheme.colorScheme.secondary,
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          label: Text(
            widget.hintText,
            style: TextStyle(color: FitBuddyColorConstants.lOnSecondary),
          ),
          helperText: "",
          helperStyle: const TextStyle(height: 0.5),
          // make the error text closer to the field
          errorStyle: const TextStyle(height: 0.5),
          suffixIcon: widget.isPassword ? IconButton(
            icon: _obscureText ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ) : null,
        ),
      ),
    );
  }
}