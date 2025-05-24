import 'package:flutter/material.dart';
import 'package:hopin/widgets/backiconbtn.dart';

class Journeyfinalizer extends StatelessWidget {
  const Journeyfinalizer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Backiconbtn(incomingContext: context),
            SizedBox(height: 20),
            Image(
              image: AssetImage('assets/images/journeyCompletionImage.png'),
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'Finally! Publish Your Ride',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () => {},
              child: Text(
                'Yes, sure!',
                style: TextStyle(fontSize: 18, color: Colors.blueGrey),
              ),
            ),
            TextButton(
              onPressed: () => {},
              child: Text(
                'No, save as a draft!',
                style: TextStyle(fontSize: 18, color: Colors.blueGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
