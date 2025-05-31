import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Chatservice {
  final String baseUrl = '${dotenv.env['SERVER_BASE_URL']}/Inbox/chats/';
  Future<Map<String, dynamic>> getInboxChats(String incomingUserId) async {
    final url = Uri.parse('$baseUrl$incomingUserId');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      // print('Parsed Data: $responseData');
      return responseData;
    } else {
      throw Exception('Failed to get chats: ${response.body}');
    }
  }
}
