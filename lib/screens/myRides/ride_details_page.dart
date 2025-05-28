import 'package:flutter/material.dart';
import 'package:hopin/models/ride.dart';
import 'package:intl/intl.dart'; // For formatting DateTime

class RideDetailsPage extends StatelessWidget {
  final Ride ride;

  const RideDetailsPage({super.key, required this.ride});

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Cancel Ride'),
            content: const Text('Are you sure you want to cancel this ride?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ride cancelled successfully'),
                    ),
                  );
                  Navigator.of(context).pop();
                  // TODO: Backend/API call to cancel the ride
                },
                child: const Text('Yes, Cancel'),
              ),
            ],
          ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
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
            Text(
              'From: ${ride.startLocation}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'To: ${ride.endLocation}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Date: ${formatDateTime(ride.rideDateTime)}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Status: ${ride.status.name}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Available Seats: ${ride.availableSeats}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Price per Seat: Rs. ${ride.pricePerSeat.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showCancelConfirmation(context),
              icon: const Icon(Icons.cancel),
              label: const Text('Cancel Ride'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
