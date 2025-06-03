import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Grides {
  final String baseUrl = '${dotenv.env['SERVER_BASE_URL']}';

  Future<http.Response> getMatchedRides(
    Map<String, dynamic> searchParams,
  ) async {
    final url = Uri.parse('$baseUrl/Rides/search');

    print('Sending API request to: $url');
    print('Request body: ${jsonEncode(searchParams)}');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(searchParams),
    );

    print('API response status code: ${response.statusCode}');
    print('API response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Successful API response: ${response.body}');
      return response;
    } else {
      print('Failed to get rides: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to get rides!: ${response.body}');
    }
  }

  // New method to request ride (add passenger)
  Future<bool> requestRide({
    required String rideId,
    required String passengerId,
    required int seats,
  }) async {
    final url = Uri.parse('$baseUrl/Rides/$rideId/passenger');

    final requestBody = {'PassengerId': passengerId, 'Seats': seats};

    print('Sending AddPassenger request to: $url');
    print('Request body: ${jsonEncode(requestBody)}');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    print('AddPassenger response status code: ${response.statusCode}');
    print('AddPassenger response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      // You can parse response body if needed here
      // final result = jsonDecode(response.body);
      return true;
    } else {
      print('Failed to request ride: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }
}
