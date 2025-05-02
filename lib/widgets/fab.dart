import 'package:flutter/material.dart';

class Fab extends StatelessWidget {
  final VoidCallback onPressed;

  const Fab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Color.fromARGB(255, 110, 78, 163),
      foregroundColor: Colors.white,
      child: const Icon(Icons.arrow_forward_outlined),
    );
  }
}
