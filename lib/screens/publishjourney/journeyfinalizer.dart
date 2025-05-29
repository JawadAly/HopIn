import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hopin/screens/publishjourney/publishridemodel.dart';
import 'package:hopin/widgets/backiconbtn.dart';
import 'package:provider/provider.dart';
import 'package:hopin/apiservices/rideService/publishRideServices/publish_ride_service.dart';

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
              onPressed: () => {onClickPublish(context)},
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

  void onClickPublish(BuildContext context) async {
    final publishRideModel = context.read<Publishridemodel>();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print("User is not authenticated.");
      return;
    }

    final jsonData = publishRideModel.toJson(uid);
    print('Publishing ride with data: $jsonData');

    publishRideModel.printData(); // Reset the model after publishing

    final publishRideService = PublishRideService();

    try {
      final response = await publishRideService.publishRide(jsonData);
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!context.mounted) return;
        Navigator.pushNamed(context, '/home');
      }
    } catch (e) {
      print('Error publishing ride: $e');
    }
  }
}
