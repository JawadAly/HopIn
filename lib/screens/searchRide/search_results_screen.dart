import 'package:flutter/material.dart';
import 'package:hopin/models/ride.dart';
import 'package:hopin/models/ride_with_username.dart';
import 'package:intl/intl.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<RideWithUsername> ridesWithUsernames;

  const SearchResultsScreen({super.key, required this.ridesWithUsernames});

  String formatDate(DateTime date) {
    final localDate = date.toLocal(); // convert to local timezone
    return DateFormat('dd/MM/yyyy hh:mm a').format(localDate);
  }

  Widget buildRideCard(
    BuildContext context,
    RideWithUsername rideWithUsername,
  ) {
    final Ride ride = rideWithUsername.ride;
    final String username = rideWithUsername.username;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                ride.startLocation,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.arrow_forward, size: 16),
            ),
            Expanded(
              child: Text(
                ride.endLocation,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date & Time: ${formatDate(ride.rideDateTime)}'),
            Text('Posted by: $username'),
          ],
        ),
        trailing: Text(
          ride.status.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:
                ride.status == RideStatus.completed
                    ? Colors.green
                    : ride.status == RideStatus.active
                    ? Colors.blue
                    : Colors.grey,
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/ride/details',
            arguments: {'ride': ride, 'fromSearchResults': true},
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Results")),
      body:
          ridesWithUsernames.isEmpty
              ? const Center(child: Text("No rides found."))
              : ListView.builder(
                itemCount: ridesWithUsernames.length,
                itemBuilder:
                    (context, index) =>
                        buildRideCard(context, ridesWithUsernames[index]),
              ),
    );
  }
}
