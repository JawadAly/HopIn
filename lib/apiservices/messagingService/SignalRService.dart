import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hopin/models/message.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/itransport.dart';

typedef MessageCallback = void Function(Message message);

class SignalRService {
  final String chatId;
  final MessageCallback onMessageReceived;

  late HubConnection _connection;

  SignalRService({required this.chatId, required this.onMessageReceived});

  Future<void> connect() async {
    final serverUrl =
        '${dotenv.env['SIGNALR_URL']}'; // Removed chatId from base URL

    final httpOptions = HttpConnectionOptions(
      transport: HttpTransportType.WebSockets,
    );

    _connection =
        HubConnectionBuilder().withUrl(serverUrl, options: httpOptions).build();

    _connection.on("ReceiveMessage", (args) {
      if (args != null && args.isNotEmpty && args[0] is Map<String, dynamic>) {
        final msgJson = args[0] as Map<String, dynamic>;
        final message = Message.fromJson(msgJson);
        onMessageReceived(message);
      }
    });

    try {
      await _connection.start();
      print('Connected to SignalR hub.');
      // The chatId is now passed during the initial connection URL,
      // so the backend's OnConnectedAsync should handle joining the group.
    } catch (e) {
      print('Error connecting to SignalR hub: $e');
    }
  }

  Future<void> disconnect() async {
    await _connection.stop();
    print('Disconnected from SignalR hub.');
  }

  Future<void> sendMessage(Message message) async {
    if (_connection.state == HubConnectionState.Connected) {
      try {
        // Call the SendMessage hub method, ensuring chatId is the first argument
        await _connection.invoke(
          "SendMessage",
          args: [chatId, message.toJson()],
        );
      } catch (e) {
        print('Error sending message via SignalR: $e');
      }
    } else {
      print('SignalR connection is not active. Cannot send message.');
    }
  }
}
