import 'package:flutter/material.dart';
// import 'package:hopin/screens/publishjourney/pickup.dart';
import 'package:hopin/screens/publishjourney/publishridemodel.dart';
import 'package:hopin/screens/publishjourney/traveldate.dart';
import 'package:provider/provider.dart';

class PublishridesWrapper extends StatelessWidget {
  const PublishridesWrapper({super.key});

  // List<Widget> publishJournyWidgets = [
  //   Pickup(),
  //   Dropoff(),
  // ];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Publishridemodel(),
      // child: Pickup(),
      child: Traveldate(),
    );
  }
}
