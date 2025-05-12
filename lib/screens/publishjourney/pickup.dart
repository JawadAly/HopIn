import 'package:flutter/material.dart';
import 'package:hopin/screens/publishjourney/publishridemodel.dart';
import 'package:hopin/widgets/fab.dart';
import 'package:hopin/widgets/input.dart';
import 'package:hopin/widgets/locationprovider.dart';
import 'package:provider/provider.dart';

class Pickup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PickupState();
  }
}

class _PickupState extends State<Pickup> {
  String? pickupDest;
  final _pickUpDestControler = TextEditingController();
  final _pickUpGlobalKey = GlobalKey<FormState>();
  void updatepickUpDest(String field, dynamic incomingVal) {
    setState(() {
      pickupDest = incomingVal;
    });
  }

  void nextStepFunc() {
    if (_pickUpGlobalKey.currentState!.validate()) {
      Provider.of<Publishridemodel>(
        context,
        listen: false,
      ).updatePickupLoc(pickupDest!);
      Navigator.pushNamed(context, '/publishride/dropoff');
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
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.cancel),
            ),
            SizedBox(height: 20),
            Text(
              'Pick-up',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Form(
              key: _pickUpGlobalKey,
              child: Input(
                prefIcon: Icon(Icons.search),
                keyboardType: TextInputType.text,
                controler: _pickUpDestControler,
                hint: "Enter the full address",
                readType: true,
                tapFunc:
                    (incomingContext) => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => LocationProvider(
                                hintText: "Enter the full address",
                                dataModifier: updatepickUpDest,
                                controler: _pickUpDestControler,
                                submitionFunc: (_) => Navigator.pop(context),
                              ),
                        ),
                      ),
                    },
                textObscure: false,
                changeSenseFunc: updatepickUpDest,
                validatorFunc: (String incomingVal) {
                  return incomingVal.isEmpty
                      ? "Pick-up location is required"
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
