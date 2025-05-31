import 'package:flutter/material.dart';
import 'package:hopin/models/ride.dart';
import 'package:intl/intl.dart'; // For formatting DateTime

class RideDetailsPage extends StatelessWidget {
  final Ride ride;
  final bool fromSearchResults;
  final bool fromMyRides;

  const RideDetailsPage({
    super.key,
    required this.ride,
    this.fromSearchResults = false,
    this.fromMyRides = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ride Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From: ${ride.startLocation}'),
            Text('To: ${ride.endLocation}'),
            Text('Status: ${ride.status.name}'),
            const SizedBox(height: 20),
            if (fromSearchResults)
              ElevatedButton(
                onPressed: () {
                  // Request ride logic
                },
                child: const Text('Request Ride'),
              ),
            if (fromMyRides)
              ElevatedButton(
                onPressed: () {
                  // Cancel ride logic
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Cancel Ride'),
              ),
          ],
        ),
      ),
    );
  }
}
