import 'package:flutter/material.dart';
//screens
import './searchrides.dart';
import 'publishrideswrapper.dart';
import 'profile/profile.dart';
import './myrides.dart';
import 'inbox/inbox.dart';

//widgets
import '../widgets/bottomnavigation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _pageIndex = 0;
  void _updatePageState(incomingPageIndexVal) {
    setState(() {
      _pageIndex = incomingPageIndexVal;
    });
  }

  final List<Widget> _pages = [
    Searchrides(),
    PublishridesWrapper(),
    Myrides(),
    Inbox(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _pageIndex, children: _pages),
      bottomNavigationBar: Bottomnavigation(
        navigationIndex: _pageIndex,
        navigationIndexModifier: _updatePageState,
      ),
    );
  }
}
