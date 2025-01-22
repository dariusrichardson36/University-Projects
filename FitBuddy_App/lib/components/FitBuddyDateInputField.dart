import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../theme/theme_constants.dart';

class FitBuddyDateInputField extends StatefulWidget {
  const FitBuddyDateInputField({super.key, required this.onDateSelected});

  final ValueChanged<DateTime?> onDateSelected;

  @override
  FitBuddyDateInputFieldState createState() => FitBuddyDateInputFieldState();
}

class FitBuddyDateInputFieldState extends State<FitBuddyDateInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      _controller.text = selectedDate.toLocal().toString().split(' ')[0];
      widget.onDateSelected(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
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
          "Date of Birth",
          style: TextStyle(color: FitBuddyColorConstants.lOnSecondary),
        ),
        helperText: "",
        helperStyle: const TextStyle(height: 0.5),
        // make the error text closer to the field
        errorStyle: const TextStyle(height: 0.5),
        ),
      readOnly: true, // makes this field read-only
      onTap: _selectDate,
    );
  }
}