import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hopin/models/message.dart';
import 'package:http/http.dart' as http;

class MessageService {
  final String baseUrl =
      '${dotenv.env['SERVER_BASE_URL']}/messaging'; // Adjusted base URL

  Future<bool> sendMessage(Message message, String chatId) async {
    final uri = Uri.parse(
      '$baseUrl?chatId=$chatId',
    ); // chatId as query parameter
    print('MessageService - Sending message to URI: $uri');
    print(
      'MessageService - Request Headers: {"Content-Type": "application/json"}',
    );
    print('MessageService - Request Body: ${jsonEncode(message.toJson())}');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(message.toJson()),
      );

      print('MessageService - Response Status Code: ${response.statusCode}');
      print('MessageService - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('MessageService - Message sent successfully via API.');
        return true;
      } else {
        print(
          'MessageService - Failed to send message via API. Status Code: ${response.statusCode}, Body: ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('MessageService - Error during API call: $e');
      return false;
    }
  }
}
