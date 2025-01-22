import 'package:flutter/cupertino.dart';

import '../../components/FitBuddySelectableButton.dart';

class GenderSelection extends StatefulWidget {
  const GenderSelection({super.key});

  @override
  GenderSelectionState createState() => GenderSelectionState();
}

class GenderSelectionState extends State<GenderSelection> {
  bool isManSelected = false;
  bool isWomanSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("I am a", style: TextStyle(fontSize: 20),),
        const SizedBox(height: 20),
        FitBuddySelectableButton(
          text: "MAN",
          onTap: () {
            setState(() {
              isManSelected = true;
              isWomanSelected = false;
            });
          },
          isSelected: isManSelected,
        ),
        const SizedBox(height: 20),
        FitBuddySelectableButton(
          text: "WOMAN",
          onTap: () {
            setState(() {
              isManSelected = false;
              isWomanSelected = true;
            });
          },
          isSelected: isWomanSelected,
        ),
      ],
    );
  }
}