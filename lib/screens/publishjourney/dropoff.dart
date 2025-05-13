import 'package:flutter/material.dart';
import 'package:hopin/screens/publishjourney/publishridemodel.dart';
import 'package:hopin/widgets/backiconbtn.dart';
import 'package:hopin/widgets/fab.dart';
import 'package:hopin/widgets/input.dart';
import 'package:hopin/widgets/locationprovider.dart';
import 'package:provider/provider.dart';

class Dropoff extends StatefulWidget {
  const Dropoff({super.key});

  @override
  State<Dropoff> createState() => _DropoffState();
}

class _DropoffState extends State<Dropoff> {
  String? dropOffLoc;
  final _dropOffGlobalKey = GlobalKey<FormState>();
  final dropOffController = TextEditingController();

  void nextStepFunc() {
    if (_dropOffGlobalKey.currentState!.validate()) {
      Provider.of<Publishridemodel>(
        context,
        listen: false,
      ).updateDropoffLoc(dropOffLoc!);
      Navigator.pushNamed(context, '/publishride/routedecider');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Backiconbtn(incomingContext: context),
            SizedBox(height: 20),
            Text(
              'Drop-off',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Form(
              key: _dropOffGlobalKey,
              child: Input(
                prefIcon: Icon(Icons.search),
                keyboardType: TextInputType.text,
                hint: "Enter the full address",
                textObscure: false,
                readType: true,
                controler: dropOffController,
                tapFunc: (incomingContext) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => LocationProvider(
                            dataModifier: (String field, dynamic incomingVal) {
                              setState(() {
                                dropOffLoc = incomingVal;
                              });
                            },
                            hintText: "Drop-ff Location",
                            controler: dropOffController,
                            submitionFunc: (_) => Navigator.pop(context),
                          ),
                    ),
                  );
                },
                changeSenseFunc: () {},
                validatorFunc: (String incomingVal) {
                  return incomingVal.isEmpty
                      ? "Drop-off location is required"
                      : null;
                },
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Fab(onPressed: () => nextStepFunc()),
            ),
          ],
        ),
      ),
    );
  }
}
