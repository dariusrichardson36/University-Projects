import 'package:fit_buddy/constants/color_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FitBuddySelectableButton extends StatefulWidget {
  final String text;
  final Function()? onTap;
  final bool isSelected;
  const FitBuddySelectableButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSelected,
  });

  @override
  State<FitBuddySelectableButton> createState() => _FitBuddySelectableButtonState();
}

class _FitBuddySelectableButtonState extends State<FitBuddySelectableButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: widget.isSelected ? FitBuddyColorConstants.lAccent : FitBuddyColorConstants.lOnPrimary,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.isSelected ? FitBuddyColorConstants.lAccent : FitBuddyColorConstants.lOnPrimary,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}