import 'package:fit_buddy/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class FitBuddyVisibilitySelector extends StatelessWidget {
  final onChanged;
  final String value;

  const FitBuddyVisibilitySelector({
    super.key,
    required this.onChanged,
    required this.value,
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox (
      width: 60,
      height: 40,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white,),
            openMenuIcon: Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white,),
            iconSize: 24,
          ),
          buttonStyleData: ButtonStyleData(
            height: 40,
            width: 50,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: FitBuddyColorConstants.lAccent,
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(20.0)),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownStyleData: DropdownStyleData(
            offset: const Offset(-60, -2),
            isOverButton: false,
            width: 120,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: FitBuddyColorConstants.lAccent,
              borderRadius: BorderRadius.circular(10)
            )
          ),
          onChanged: onChanged,
          value: value,
          items: <String>['Private', 'Public'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(
                    value == 'Private' ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white, // Set your desired icon color here
                  ),
                  const SizedBox(width: 10),
                  Text(value, style: TextStyle(color: FitBuddyColorConstants.lPrimary),)
                ],
              ),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return <String>['Private', 'Public'].map<Widget>((String value) {
              return Icon(
                value == 'Private' ? Icons.visibility_off : Icons.visibility,
                color: Colors.white, // Set your desired icon color here
              );
            }).toList();
          }
        ),
      ),
    );
  }
}