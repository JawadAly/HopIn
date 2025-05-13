import 'package:flutter/material.dart';

class Bottomnavigation extends StatefulWidget {
  final int navigationIndex;
  final Function navigationIndexModifier;
  const Bottomnavigation({
    super.key,
    required this.navigationIndex,
    required this.navigationIndexModifier,
  });
  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: Colors.purple.shade100,
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(color: Colors.grey.shade600),
        ),
      ),
      child: NavigationBar(
        selectedIndex: widget.navigationIndex,
        onDestinationSelected: (value) => widget.navigationIndexModifier(value),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            label: 'Publish',
          ),
          NavigationDestination(
            icon: Icon(Icons.format_quote_outlined),
            label: 'Your rides',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.person, size: 25),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
