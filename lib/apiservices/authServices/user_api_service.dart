import 'package:http/http.dart' as http;
import 'dart:convert';

class UserApiService {
  final String baseUrl = 'http://192.168.100.4:5000/api/user';

  Future<void> registerUser(Map<String, dynamic> userData) async {
    final url = Uri.parse(baseUrl);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Registered successfully');
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }
}
