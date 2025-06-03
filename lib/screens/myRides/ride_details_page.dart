import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hopin/apiservices/rideService/generalRideService/grides.dart';
import 'package:hopin/models/ride.dart';
import 'package:hopin/models/searchridesmodel.dart';
import 'package:hopin/widgets/toastprovider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

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

  // Method to handle request ride action
  Future<void> _requestRide(BuildContext context) async {
    final grides = Grides();
    final searchRideModel = Provider.of<Searchridesmodel>(
      context,
      listen: false,
    );
    final int requestedSeats = searchRideModel.passengerCount ?? 1;
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      showCustomToast(
        'Unauthorized',
        'Please log in to request a ride.',
        ToastificationType.error,
      );
      return;
    }

    bool success = await grides.requestRide(
      rideId: ride.id,
      passengerId: currentUserId,
      seats: requestedSeats,
    );

    if (success) {
      showCustomToast(
        'Success',
        'Request sent successfully!',
        ToastificationType.success,
      );
    } else {
      showCustomToast(
        'Error',
        'Failed to send request. Please try again.',
        ToastificationType.error,
      );
    }
  }

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
            Text(
              'Date & Time: ${DateFormat('dd/MM/yyyy hh:mm a').format(ride.rideDateTime.toLocal())}',
            ),
            Text('Available Seats: ${ride.availableSeats}'),
            Text('Status: ${ride.status.name}'),
            const SizedBox(height: 20),
            if (fromSearchResults && ride.availableSeats > 0)
              ElevatedButton(
                onPressed: () => _requestRide(context),
                child: const Text('Request Ride'),
              ),
            if (fromSearchResults && ride.availableSeats <= 0)
              const Text(
                'No seats available',
                style: TextStyle(color: Colors.red),
              ),
            if (fromMyRides)
              ElevatedButton(
                onPressed: () {
                  // Cancel ride logic here
                  print('Cancel ride functionality needs to be implemented');
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
