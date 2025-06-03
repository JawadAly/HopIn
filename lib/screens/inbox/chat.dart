import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hopin/apiservices/messagingService/SignalRService.dart';
import 'package:hopin/apiservices/messagingService/message_api_service.dart';
import 'package:hopin/models/message.dart';

class Chat extends StatefulWidget {
  final Map<String, dynamic> chat;
  final String currentUserId;

  const Chat({Key? key, required this.chat, required this.currentUserId})
    : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late String otherUserName;
  List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late SignalRService _signalRService;
  final MessageService _messageService = MessageService();
  String? _chatId;

  @override
  void initState() {
    super.initState();
    _chatId = widget.chat['chatId']?.toString();
    print('Chat ID in initState: $_chatId');

    final person1 = widget.chat['person1'];
    final person2 = widget.chat['person2'];

    final otherUser =
        person1['userId'] == widget.currentUserId ? person2 : person1;

    otherUserName =
        "${otherUser['userFirstName']} ${otherUser['userLastName']}";
    print('Other User Name in initState: $otherUserName');

    final chatMessages = widget.chat['chatMessages'] as List<dynamic>? ?? [];
    _messages = chatMessages.map((msg) => Message.fromJson(msg)).toList();
    print('Initial messages in initState: ${_messages.length}');

    if (_chatId != null) {
      _signalRService = SignalRService(
        chatId: _chatId!,
        onMessageReceived: _handleRealtimeMessage,
      );
      _signalRService.connect();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _signalRService.disconnect();
    _controller.dispose();
    _scrollController.dispose();
    print('Chat widget disposed');
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleRealtimeMessage(Message message) {
    print('Received realtime message: ${message.toJson()}');
    if (message.senderId != widget.currentUserId) {
      setState(() {
        _messages.add(message);
        print(
          'Message added to _messages (realtime), count: ${_messages.length}',
        );
      });
      _scrollToBottom();
    }
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty && _chatId != null) {
      final newMessage = Message(
        senderId: widget.currentUserId,
        content: text,
        msgCreatedAt: DateTime.now(),
      );

      print('Attempting to send message: ${newMessage.toJson()}');

      setState(() {
        _messages.add(newMessage);
        print('Message added to _messages (local), count: ${_messages.length}');
      });
      _controller.clear();
      _scrollToBottom();

      // Send message via your API
      final sent = await _messageService.sendMessage(newMessage, _chatId!);
      print('API send result: $sent');
      if (!sent) {
        // Handle error if message fails to send via API
        print('Failed to send message via API.');
        // Optionally, revert the local message display if the API fails
        setState(() {
          _messages.removeWhere(
            (m) =>
                m.content == newMessage.content &&
                m.senderId == newMessage.senderId &&
                m.msgCreatedAt == newMessage.msgCreatedAt,
          );
          print(
            'Message removed from _messages (API failed), count: ${_messages.length}',
          );
        });
      }
    }
  }

  void _handleRequestAction(
    String senderId,
    String rideId,
    bool accepted,
  ) async {
    final action = accepted ? 'accepted' : 'rejected';
    print(
      'Handling request action: senderId=$senderId, rideId=$rideId, accepted=$accepted',
    );
    setState(() {
      _messages.add(
        Message(
          senderId: widget.currentUserId,
          content: "You have $action the request.",
          msgCreatedAt: DateTime.now(),
        ),
      );
    });
    _scrollToBottom();
    // In a real app, you would make an API call here to inform the backend
  }

  Widget _buildMessage(Message msg) {
    final isSystem = msg.senderId == 'system';
    final content = msg.content;
    final timeFormatted = TimeOfDay.fromDateTime(
      msg.msgCreatedAt,
    ).format(context);
    final isUser = msg.senderId == widget.currentUserId;

    print('Building message: ${msg.toJson()}');

    if (isSystem && content.startsWith('[REQUEST_ACTION]|')) {
      final parts = content.split('|');
      if (parts.length >= 3) {
        final senderId = parts[1];
        final rideId = parts[2];

        if (senderId != widget.currentUserId) {
          return Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'A passenger has requested a ride.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed:
                            () => _handleRequestAction(senderId, rideId, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text('Accept'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed:
                            () => _handleRequestAction(senderId, rideId, false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Reject'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'You have requested a ride.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
      }
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.content,
              style: TextStyle(color: isUser ? Colors.white : Colors.black87),
            ),
            SizedBox(height: 4),
            Text(
              timeFormatted,
              style: TextStyle(
                fontSize: 10,
                color: isUser ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building Chat widget, message count: ${_messages.length}');
    return Scaffold(
      appBar: AppBar(title: Text(otherUserName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
