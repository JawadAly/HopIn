import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Publishridemodel extends ChangeNotifier {
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

  void updatePickupLocCoord(LatLng newVal) {
    _pickupLocationCoordinates = newVal;
    notifyListeners();
  }

  LatLng getPickupLocCoords() {
    return _pickupLocationCoordinates!;
  }

  void updateDropoffLoc(String newVal) {
    _dropOffLocation = newVal;
    notifyListeners();
  }

  void updateDropoffLocCoord(LatLng newVal) {
    _dropOffLocationCoordinates = newVal;
    notifyListeners();
  }

  LatLng getDropoffLocCoords() {
    return _dropOffLocationCoordinates!;
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
  }

  void updateTravelTime(String? incomingVal) {
    travelTime = incomingVal;
  }

  void updatePassengerCount(int incomingVal) {
    passengerCount = incomingVal;
  }
}
