import 'package:http/http.dart' as http;
import 'dart:convert';

class PublishRideService {
  final String baseUrl = 'http://192.168.100.4:5000/api/rides';

  Future<http.Response> publishRide(Map<String, dynamic> rideData) async {
    final url = Uri.parse(baseUrl);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(rideData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Ride published successfully');
      return response;
    } else {
      throw Exception('Failed to publish ride: ${response.body}');
    }
  }
}
