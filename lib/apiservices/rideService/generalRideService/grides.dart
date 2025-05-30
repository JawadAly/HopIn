import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Grides {
  final String baseUrl = '${dotenv.env['SERVER_BASE_URL']}/Rides/search';
  Future<http.Response> getMatchedRides(
    Map<String, dynamic> searchParams,
  ) async {
    final url = Uri.parse(baseUrl);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(searchParams),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      return response;
    } else {
      throw Exception('Failed to get rides!: ${response.body}');
    }
  }
}
