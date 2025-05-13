import 'package:flutter/material.dart';

class Backiconbtn extends StatelessWidget {
  final dynamic incomingContext;
  final Color? btnColor;
  const Backiconbtn({super.key, required this.incomingContext, this.btnColor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(incomingContext),
      icon: Icon(
        Icons.arrow_back_ios_rounded,
        color: btnColor ?? Colors.purple.shade400,
      ),
    );
  }
}
