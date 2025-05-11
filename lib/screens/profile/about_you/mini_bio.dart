import 'package:flutter/material.dart';
import 'package:hopin/widgets/button.dart';

class MiniBio extends StatefulWidget {
  const MiniBio({super.key});

  @override
  State<MiniBio> createState() => _MiniBioState();
}

class _MiniBioState extends State<MiniBio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "What would you like other members to know about you?",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              maxLines: 5,
              maxLength: 150,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                hintText:
                    "Example: I am a software developer, and I like to code. I love music and watching movies",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Spacer(),
            CustomButton(text: "Save", onPressed: () {}),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
