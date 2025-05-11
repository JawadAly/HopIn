import 'package:flutter/material.dart';
import 'package:hopin/screens/profile/about_you/about_you.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            unselectedLabelColor: Colors.blueGrey,
            indicatorWeight: 3.0,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            splashFactory: NoSplash.splashFactory,
            tabs: const [Tab(text: 'About you'), Tab(text: 'Account')],
          ),
        ),
        body: const TabBarView(
          children: [AboutYou(), Center(child: Text("Sign Up Screen"))],
        ),
      ),
    );
  }
}
