import 'package:fit_buddy/constants/color_constants.dart';
import 'package:flutter/material.dart';

class FitBuddyThirdPartyBox extends StatelessWidget {
  final String imagePath;
  final String text;
  final Function()? onTap;
  final Icon? icon;
  const FitBuddyThirdPartyBox({
    super.key,
    required this.imagePath,
    required this.text,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: FitBuddyColorConstants.lOnSecondary),
            borderRadius: BorderRadius.circular(50),

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                alignment: Alignment.centerLeft,
                imagePath,
                height: 20,
                width: 30,
              ),
              Text(
                text,
              ),
              const SizedBox(
                width: 50,
              )
            ],
          )
      ),
    );
  }
}