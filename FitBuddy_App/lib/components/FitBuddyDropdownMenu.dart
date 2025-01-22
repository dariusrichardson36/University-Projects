
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class FitBuddyDropdownMenu extends StatelessWidget {
  final List<String> items;
  final String value;
  final onChange;
  final labelText;

  const FitBuddyDropdownMenu({
    super.key,
    required this.items,
    required this.value,
    required this.onChange,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField (
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(color: FitBuddyColorConstants.lOnSecondary),
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
        //fillColor: FitBuddyColorConstants.lSecondary,
        filled: true, // Todo decide if should be filled or not
      ),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      value: value.isEmpty ? null : value,
      onChanged: onChange,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      iconSize: 50,
    );
  }
}
