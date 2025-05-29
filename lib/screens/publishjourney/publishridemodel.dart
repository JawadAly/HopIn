import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class Publishridemodel extends ChangeNotifier {
  String? _pickupLocation;
  LatLng? _pickupLocationCoordinates;
  String? _dropOffLocation;
  LatLng? _dropOffLocationCoordinates;
  DateTime? travelDate;
  String? travelTime;
  int? passengerCount;
  int? seatPrice;
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

  Set<Marker> getMarkerSet() {
    return {
      Marker(
        markerId: MarkerId('_source'),
        position: _pickupLocationCoordinates!,
        icon: BitmapDescriptor.defaultMarker,
      ),
      Marker(
        markerId: MarkerId('_destination'),
        position: _dropOffLocationCoordinates!,
        icon: BitmapDescriptor.defaultMarker,
      ),
    };
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

  void updateSeatPrice(int newVal) {
    seatPrice = newVal;
    notifyListeners();
  }

  int? getSeatPrice() {
    return seatPrice;
  }

  Map<String, dynamic> toJson(String riderId) {
    debugUnicodeChars(travelTime!);

    final combinedDateTime = combineDateAndTime(travelDate!, travelTime!);

    print('Combined DateTime: $combinedDateTime');
    // Output: 2025-05-24 14:42:00.000

    // Then convert to ISO string if needed
    final isoString = combinedDateTime.toUtc().toIso8601String();
    print('ISO String: $isoString');
    // Output: 2025-05-24T14:42:00.000Z

    try {
      // Clean invisible Unicode spaces (normal space, non-breaking space, narrow no-break space)

      return {
        "riderId": riderId,
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
        "rideDateTime": isoString ?? "",
        "availableSeats": passengerCount ?? 1,
        "pricePerSeat": seatPrice ?? 0,
        "bookedSeats": 0,
      };
    } catch (e) {
      print("❌ Exception while parsing date/time: $e");
      return {
        "request": {"request": {}},
      };
    }
  }

  void debugUnicodeChars(String s) {
    for (int i = 0; i < s.length; i++) {
      print(
        "'${s[i]}' = U+${s.codeUnitAt(i).toRadixString(16).padLeft(4, '0')}",
      );
    }
  }

  String cleanTimeString(String input) {
    // Replace all known Unicode spaces with a normal space
    return input
        .replaceAll(
          RegExp(r'[\u00A0\u202F\u2007\u200B\u2060\u2000-\u200A\u205F\u3000]'),
          ' ',
        )
        .replaceAll(RegExp(r'\s+'), ' ') // Normalize multiple spaces
        .trim();
  }

  DateTime combineDateAndTime(DateTime date, String timeString) {
    final cleanedTime = cleanTimeString(timeString);

    // Regex to match "hh:mm AM/PM" (with optional spaces)
    final regex = RegExp(r'(\d{1,2}):(\d{2})\s*([APap][Mm])');
    final match = regex.firstMatch(cleanedTime);

    if (match != null) {
      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      String period = match.group(3)!.toUpperCase();

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return DateTime(date.year, date.month, date.day, hour, minute);
    } else {
      print("❌ Could not parse time: '$timeString'");
      print("💡 Cleaned time string: '$cleanedTime'");
      throw FormatException("Invalid time format: $cleanedTime");
    }
  }

  void printData() {
    print("Pickup Location: $_pickupLocation");
    print("Pickup Coordinates: $_pickupLocationCoordinates");
    print("Dropoff Location: $_dropOffLocation");
    print("Dropoff Coordinates: $_dropOffLocationCoordinates");
    print("Travel Date: $travelDate");
    print("Travel Time: $travelTime");
    print("Passenger Count: $passengerCount");
    print("Seat Price: $seatPrice");
  }
}
