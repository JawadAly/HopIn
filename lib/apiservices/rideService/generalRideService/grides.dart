import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Grides {
  final String baseUrl = '${dotenv.env['SERVER_BASE_URL']}/Rides/search';
  Future<http.Response> getMatchedRides(
    Map<String, dynamic> searchParams,
  ) async {
    final url = Uri.parse(baseUrl);

    print('Sending API request to: $url');
    print('Request body: ${jsonEncode(searchParams)}');

    //searchParams['rideDate'] = searchParams['rideDate'].toIso8601String();

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
}
