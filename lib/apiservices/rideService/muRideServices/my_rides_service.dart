import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class MyRidesService {
  final String baseUrl = '${dotenv.env['SERVER_BASE_URL']}/rides';

  Future<List<dynamic>> getMyPublishedRides(String userId) async {
    final url = Uri.parse('$baseUrl/getpublishedRides/$userId');
    try {
      final response = await http.get(url);
      print(response);

      if (response.statusCode == 200) {
        try {
          final body = jsonDecode(response.body);
          if (body['success'] == true && body['data'] != null) {
            print('API Response: ${response.body}');
            return body['data']; // This is the actual ride list
          } else {
            throw Exception('API did not return valid data: ${response.body}');
          }
        } catch (e) {
          print('Error decoding JSON: $e');
          throw Exception('Failed to decode JSON: $e');
        }
      } else {
        print('API Response Status Code: ${response.statusCode}');
        print('API Response Body: ${response.body}');
        print(FirebaseAuth.instance.currentUser?.uid);
        throw Exception(
          'Failed to load rides: HTTP status ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      print(FirebaseAuth.instance.currentUser?.uid);
      throw Exception('Failed to make HTTP request: $e');
    }
  }

  Future<void> getMySceduledRides(String userId) async {
    final url = Uri.parse('$baseUrl/scheduled/user/$userId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('Scheduled rides fetched successfully');
      } else {
        print(
          'Failed to load scheduled rides - Status Code: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception('Failed to load scheduled rides: ${response.body}');
      }
    } catch (e) {
      print('Error fetching scheduled rides: $e');
      throw Exception('Failed to load scheduled rides: $e');
    }
  }
}
