import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Searchridesmodel extends ChangeNotifier {
  String? _pickupLocation;
  LatLng? _pickupLocationCoordinates;
  String? _dropOffLocation;
  LatLng? _dropOffLocationCoordinates;
  DateTime? travelDate;
  String? travelTime;
  int? passengerCount;
  void updatePickupLoc(String newVal) {
    _pickupLocation = newVal;
    notifyListeners();
  }

  String? getPickUpLoc() {
    return _pickupLocation;
  }

  void updatePickupLocCoord(LatLng newVal) {
    _pickupLocationCoordinates = newVal;
    notifyListeners();
  }

  LatLng? getPickupLocCoords() {
    return _pickupLocationCoordinates;
  }

  void updateDropoffLoc(String newVal) {
    _dropOffLocation = newVal;
    notifyListeners();
  }

  String? getDropOffLoc() {
    return _dropOffLocation;
  }

  void updateDropoffLocCoord(LatLng newVal) {
    _dropOffLocationCoordinates = newVal;
    notifyListeners();
  }

  LatLng? getDropoffLocCoords() {
    return _dropOffLocationCoordinates;
  }

  void updateTravelDate(DateTime incomingDataTime) {
    travelDate = incomingDataTime;
    notifyListeners();
  }

  void updateTravelTime(String incomingVal) {
    travelTime = incomingVal;
    notifyListeners();
  }

  void updatePassengerCount(int incomingVal) {
    passengerCount = incomingVal;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    final isoString = travelDate!.toUtc().toIso8601String();
    return {
      "startLocation": _pickupLocation ?? "",
      "startCoordinates": {
        "latitude": _pickupLocationCoordinates?.latitude ?? 0.0,
        "longitude": _pickupLocationCoordinates?.longitude ?? 0.0,
      },
      "endLocation": _dropOffLocation ?? "",
      "endCoordinates": {
        "latitude": _dropOffLocationCoordinates?.latitude ?? 0.0,
        "longitude": _dropOffLocationCoordinates?.longitude ?? 0.0,
      },
      "rideDate": isoString ?? "",
      "reqSeats": passengerCount ?? 1,
    };
  }

  void printData() {
    print("Pickup Location: $_pickupLocation");
    print("Pickup Coordinates: $_pickupLocationCoordinates");
    print("Dropoff Location: $_dropOffLocation");
    print("Dropoff Coordinates: $_dropOffLocationCoordinates");
    print("Travel Date: $travelDate");
    print("Travel Time: $travelTime");
    print("Passenger Count: $passengerCount");
  }
}
