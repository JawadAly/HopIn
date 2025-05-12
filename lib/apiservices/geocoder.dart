import 'package:geocode/geocode.dart';

Future<String> getAddressFromCoords(double lat, double lon) async {
  GeoCode coder = GeoCode();
  try {
    final Address finalAddress = await coder.reverseGeocoding(
      latitude: lat,
      longitude: lon,
    );
    if ((finalAddress.streetAddress?.isEmpty ?? true) &&
        (finalAddress.city?.isEmpty ?? true) &&
        (finalAddress.region?.isEmpty ?? true) &&
        (finalAddress.countryName?.isEmpty ?? true)) {
      return "Address not found for given coordinates.";
    }
    return [
      finalAddress.streetAddress,
      finalAddress.city,
      finalAddress.region,
      finalAddress.countryName,
    ].where((e) => e != null && e.isNotEmpty).join(', ');
  } on ArgumentError catch (e) {
    return "Invalid coordinates: $e";
  } catch (e) {
    throw Exception(e);
  }
}
