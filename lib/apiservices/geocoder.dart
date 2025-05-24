import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
// import 'package:geocode/geocode.dart';

// Future<String> getAddressFromCoords(double lat, double lon) async {
//   GeoCode coder = GeoCode();
//   try {
//     final Address finalAddress = await coder.reverseGeocoding(
//       latitude: lat,
//       longitude: lon,
//     );
//     if ((finalAddress.streetAddress?.isEmpty ?? true) &&
//         (finalAddress.city?.isEmpty ?? true) &&
//         (finalAddress.region?.isEmpty ?? true) &&
//         (finalAddress.countryName?.isEmpty ?? true)) {
//       return "Address not found for given coordinates.";
//     }
//     return [
//       finalAddress.streetAddress,
//       finalAddress.city,
//       finalAddress.region,
//       finalAddress.countryName,
//     ].where((e) => e != null && e.isNotEmpty).join(', ');
//   } on ArgumentError catch (e) {
//     return "Invalid coordinates: $e";
//   } catch (e) {
//     throw Exception(e);
//   }
// }

final baseURL = 'https://maps.googleapis.com/maps/api/geocode/json';
final String? apiKey = dotenv.env['GOOGLE_API_KEY'];

Future<LatLng?> getLocLatLngs(String incommingAddress) async {
  final encodedAddress = Uri.encodeComponent(incommingAddress);
  final requestUrl = '$baseURL?address=$encodedAddress&key=$apiKey';

  final response = await http.get(Uri.parse(requestUrl));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['results'] != null && data['results'].isNotEmpty) {
      final location = data['results'][0]['geometry']['location'];
      final double lat = location['lat'];
      final double lng = location['lng'];

      return LatLng(lat, lng);
    } else {
      print("No location results found.");
      return null;
    }
  } else {
    throw Exception(
      'Failed to load location data! Status: ${response.statusCode}',
    );
  }
}

Future<String?> getLocAddress(LatLng coords) async {
  final requestUrl =
      '$baseURL?latlng=${coords.latitude},${coords.longitude}&key=$apiKey';

  final response = await http.get(Uri.parse(requestUrl));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['results'] != null && data['results'].isNotEmpty) {
      final formattedAddress = data['results'][0]['formatted_address'];
      return formattedAddress;
    } else {
      print("No location address results found!");
      return null;
    }
  } else {
    throw Exception(
      'Failed to load location data! Status: ${response.statusCode}',
    );
  }
}
