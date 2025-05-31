import 'package:hopin/models/ride.dart';

class RideWithUsername {
  final Ride ride;
  final String username;

  RideWithUsername({required this.ride, required this.username});

  factory RideWithUsername.fromJson(Map<String, dynamic> json) {
    return RideWithUsername(
      ride: Ride.fromJson(json['ride']),
      username: json['username'] ?? '',
    );
  }
}
