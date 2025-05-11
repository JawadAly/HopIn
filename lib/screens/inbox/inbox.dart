import 'package:flutter/material.dart';
import 'package:hopin/widgets/input.dart';

class Inbox extends StatefulWidget {
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
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
    filteredConversations = conversations;
  }

  filterConversations(String query) {
    final results =
        conversations
            .where(
              (convo) =>
                  convo['name']!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    setState(() {
      filteredConversations = results;
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
                        convo['time']!,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/inbox/chat',
                          arguments: convo['name'],
                        );
                      },
                      splashColor: Color.fromARGB(
                        255,
                        110,
                        78,
                        163,
                      ).withOpacity(0.2),
                      contentPadding: EdgeInsets.all(8),
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
