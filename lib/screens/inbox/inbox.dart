import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hopin/apiservices/convos/chatservice.dart';
import 'package:hopin/widgets/input.dart';
import 'package:hopin/widgets/toastprovider.dart';
import 'package:toastification/toastification.dart';

class Inbox extends StatefulWidget {
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  late Future<List<dynamic>> _inboxChatsFuture;
  final List<Map<String, String>> conversations = [
    {
      "name": "Alice",
      "lastMessage": "Hey, are you coming today?",
      "time": "09:24 AM",
    },
    {
      "name": "Bob",
      "lastMessage": "Got the location. See you soon!",
      "time": "08:15 AM",
    },
    {
      "name": "Charlie",
      "lastMessage": "Thanks for the ride!",
      "time": "Yesterday",
    },
    {
      "name": "Diana",
      "lastMessage": "Sure, I can pick you up.",
      "time": "2 days ago",
    },
  ];

  List<Map<String, String>> filteredConversations = [];

  @override
  void initState() {
    super.initState();
    // filteredConversations = conversations;
    _inboxChatsFuture = getInbxChats();
    loadFilteredConversations();
  }

  filterConversations(String query) {
    final results =
        filteredConversations
            .where(
              (convo) =>
                  convo['name']!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

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
      if (result['success'] == true && result['data'] != null) {
        final List<dynamic> chats = result['data'];
        print("Fetched Chats: $chats");
        return chats;
      } else {
        throw Exception(result['errorMsg'] ?? 'Failed to fetch chats.');
      }
    } catch (ex) {
      showCustomToast("Error!", ex.toString(), ToastificationType.error);
      return [];
    }
  }

  // Future<void> loadFilteredConversations() async {
  //   final chats = await getInbxChats();

  //   final List<Map<String, String>> mappedChats =
  //       chats.map<Map<String, String>>((chat) {
  //         return {
  //           'chatId': chat['chatId']?.toString() ?? '',
  //           'p1': chat['person1Id']?.toString() ?? '',
  //           'p2': chat['person2Id']?.toString() ?? '',
  //           'lastMessage': chat['chatMessages'][0]?.toString() ?? '',
  //           'timestamp': chat['chatLastUpdated']?.toString() ?? '',
  //         };
  //       }).toList();

  //   setState(() {
  //     filteredConversations = mappedChats;
  //   });
  // }
  Future<void> loadFilteredConversations() async {
    final chats = await getInbxChats();
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final List<Map<String, String>> mappedChats =
        chats.map<Map<String, String>>((chat) {
          final person1 = chat['person1'];
          final person2 = chat['person2'];

          // Determine who the "other" person is
          final otherUser =
              person1['userId'] == currentUserId ? person2 : person1;

          // Get name
          final fullName =
              "${otherUser['userFirstName']} ${otherUser['userLastName']}";

          // Get latest message
          final chatMessages = chat['chatMessages'] as List<dynamic>;
          final latestMessage =
              chatMessages.isNotEmpty ? chatMessages.last['content'] ?? '' : '';

          return {
            'chatId': chat['chatId']?.toString() ?? '',
            'name': fullName,
            'lastMessage': latestMessage,
            'timestamp': chat['chatLastUpdated']?.toString() ?? '',
          };
        }).toList();

    setState(() {
      filteredConversations = mappedChats;
    });
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
                hint: "Example: Misbah",
                textObscure: false,
                changeSenseFunc: (field, value) {
                  filterConversations(value);
                },
                validatorFunc: (value) {},
                prefIcon: Icon(Icons.search_outlined),
              ),
              Expanded(
                // child: ListView.builder(
                //   itemCount: filteredConversations.length,
                //   itemBuilder: (context, index) {
                //     final convo = filteredConversations[index];
                //     return ListTile(
                //       leading: CircleAvatar(child: Text(convo['p1']![0])),
                //       title: Text(
                //         convo['p2']!,
                //         style: TextStyle(fontWeight: FontWeight.bold),
                //       ),
                //       subtitle: Text(
                //         convo['lastMessage']!,
                //         maxLines: 1,
                //         overflow: TextOverflow.ellipsis,
                //       ),
                //       trailing: Text(
                //         convo['timestamp']!,
                //         style: TextStyle(fontSize: 14, color: Colors.grey),
                //       ),
                //       onTap: () {
                //         Navigator.pushNamed(
                //           context,
                //           '/inbox/chat',
                //           arguments: convo['name'],
                //         );
                //       },
                //       splashColor: Color.fromARGB(
                //         255,
                //         110,
                //         78,
                //         163,
                //       ).withOpacity(0.2),
                //       contentPadding: EdgeInsets.all(8),
                //     );
                //   },
                // ),
                child: ListView.builder(
                  itemCount: filteredConversations.length,
                  itemBuilder: (context, index) {
                    final convo = filteredConversations[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(convo['name']![0])),
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
                        convo['timestamp']!,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/inbox/chat',
                          arguments:
                              convo['chatId'], // or pass whole convo if needed
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
