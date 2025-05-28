class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates({required this.latitude, required this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }
}

enum RideStatus { active, full, inProgress, completed, cancelled }

RideStatus rideStatusFromString(String status) {
  switch (status.toLowerCase()) {
    case 'full':
      return RideStatus.full;
    case 'inprogress':
      return RideStatus.inProgress;
    case 'completed':
      return RideStatus.completed;
    case 'cancelled':
      return RideStatus.cancelled;
    default:
      return RideStatus.active;
  }
}

class Ride {
  final String id;
  final String riderId;
  final String startLocation;
  final Coordinates startCoordinates;
  final String endLocation;
  final Coordinates endCoordinates;
  final DateTime rideDateTime;
  final int availableSeats;
  final int bookedSeats;
  final double pricePerSeat;
  final RideStatus status;

  Ride({
    required this.id,
    required this.riderId,
    required this.startLocation,
    required this.startCoordinates,
    required this.endLocation,
    required this.endCoordinates,
    required this.rideDateTime,
    required this.availableSeats,
    required this.bookedSeats,
    required this.pricePerSeat,
    required this.status,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    int statusInt = json['status'];
    RideStatus status;
    switch (statusInt) {
      case 0:
        status = RideStatus.active;
        break;
      case 1:
        status = RideStatus.full;
        break;
      case 2:
        status = RideStatus.inProgress;
        break;
      case 3:
        status = RideStatus.completed;
        break;
      case 4:
        status = RideStatus.cancelled;
        break;
      default:
        status =
            RideStatus
                .active; // Provide a default value in case of unexpected input
        print('Warning: Unknown ride status code: $statusInt');
    }
    return Ride(
      id: json['rideId'] ?? '',
      riderId: json['riderId'],
      startLocation: json['startLocation'],
      startCoordinates: Coordinates.fromJson(json['startCoordinates']),
      endLocation: json['endLocation'],
      endCoordinates: Coordinates.fromJson(json['endCoordinates']),
      rideDateTime: DateTime.parse(json['rideDateTime']),
      availableSeats: json['availableSeats'],
      bookedSeats: json['bookedSeats'],
      pricePerSeat: json['pricePerSeat'].toDouble(),
      status: status,
    );
  }
}
