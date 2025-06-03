import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hopin/apiservices/convos/chatservice.dart';
import 'package:hopin/screens/inbox/chat.dart';
import 'package:hopin/widgets/input.dart';
import 'package:hopin/widgets/toastprovider.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class Inbox extends StatefulWidget {
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  late Future<List<dynamic>> _inboxChatsFuture;
  List<Map<String, dynamic>> allConversations = [];
  List<Map<String, dynamic>> filteredConversations = [];

  @override
  void initState() {
    super.initState();
    _inboxChatsFuture = getInbxChats();
    loadFilteredConversations();
  }

  void filterConversations(String query) {
    final results =
        allConversations.where((convo) {
          return convo['name']!.toLowerCase().contains(query.toLowerCase());
        }).toList();

    setState(() {
      filteredConversations = results;
    });
  }

  Future<List<dynamic>> getInbxChats() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      showCustomToast(
        "Unauthorized Access!",
        "Please login to continue",
        ToastificationType.error,
      );
      return [];
    }

    var chatsrvc = Chatservice();
    try {
      var result = await chatsrvc.getInboxChats(uid);
      print('Inbox - getInbxChats - Result: $result'); // Log the raw result
      if (result['success'] == true && result['data'] != null) {
        return result['data'];
      } else {
        throw Exception(result['errorMsg'] ?? 'Failed to fetch chats.');
      }
    } catch (ex) {
      showCustomToast("Error!", ex.toString(), ToastificationType.error);
      return [];
    }
  }

  Future<void> loadFilteredConversations() async {
    final chats =
        await _inboxChatsFuture; // Use the future to get the latest data
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    print('Inbox - loadFilteredConversations - Raw Chats: $chats');

    final List<Map<String, dynamic>> mappedChats =
        chats.map<Map<String, dynamic>>((chat) {
          final person1 = chat['person1'];
          final person2 = chat['person2'];

          final otherUser =
              person1['userId'] == currentUserId ? person2 : person1;
          final fullName =
              "${otherUser['userFirstName']} ${otherUser['userLastName']}";
          final chatMessages = chat['chatMessages'] as List<dynamic>? ?? [];

          // Filter out system messages to get the latest user message
          String latestUserMessage = '';
          if (chatMessages.isNotEmpty) {
            final latestMsg =
                chatMessages.lastWhere(
                      (msg) =>
                          !(msg['content'] as String).startsWith(
                            '[REQUEST_ACTION]|',
                          ) &&
                          msg['senderId'] != 'system',
                      orElse: () => {'content': ''},
                    )['content']
                    as String? ??
                '';
            latestUserMessage = latestMsg;
          }

          final lastUpdated = chat['chatLastUpdated']?.toString() ?? '';

          return {
            'chatId': chat['chatId']?.toString() ?? '',
            'name': fullName,
            'lastMessage': latestUserMessage,
            'timestamp': lastUpdated,
            'fullChat': chat,
          };
        }).toList();

    setState(() {
      allConversations = mappedChats;
      filteredConversations = mappedChats;
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _inboxChatsFuture =
          getInbxChats(); // Re-trigger the future to fetch latest data
    });
    await _inboxChatsFuture; // Wait for the new data to load
    await loadFilteredConversations(); // Re-process the fetched data
  }

  String formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(timestamp);
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return DateFormat('EEE').format(timestamp);
    } else {
      return DateFormat('d MMM').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Inbox",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Input(
                keyboardType: TextInputType.name,
                hint: "Search by name",
                textObscure: false,
                changeSenseFunc: (field, value) {
                  filterConversations(value);
                },
                validatorFunc: (value) {},
                prefIcon: Icon(Icons.search_outlined),
              ),
              SizedBox(height: 10),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: FutureBuilder<List<dynamic>>(
                    future: _inboxChatsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error loading chats: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No chats available.'));
                      } else {
                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: filteredConversations.length,
                          itemBuilder: (context, index) {
                            final convo = filteredConversations[index];
                            final timestamp = DateTime.tryParse(
                              convo['timestamp'],
                            );

                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  convo['name']!.isNotEmpty
                                      ? convo['name']![0]
                                      : '?',
                                ),
                              ),
                              title: Text(
                                convo['name']!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                convo['lastMessage']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                formatTimestamp(timestamp),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => Chat(
                                          chat: convo['fullChat'],
                                          currentUserId:
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid,
                                        ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
