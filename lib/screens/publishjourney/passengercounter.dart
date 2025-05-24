import 'package:flutter/material.dart';
import 'package:hopin/screens/publishjourney/publishridemodel.dart';
import 'package:hopin/widgets/backiconbtn.dart';
import 'package:hopin/widgets/fab.dart';
import 'package:hopin/widgets/toastprovider.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class Passengercounter extends StatefulWidget {
  const Passengercounter({super.key});

  @override
  State<Passengercounter> createState() => _PassengercounterState();
}

class _PassengercounterState extends State<Passengercounter> {
  int passengerCount = 1;
  bool areFixedPassenger = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Backiconbtn(incomingContext: context),
            SizedBox(height: 20),
            Text(
              "So how many HopInCar passengers can you take?",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            TextFormField(
              readOnly: true,
              textAlign: TextAlign.center,
              controller: TextEditingController(
                text: passengerCount.toString(),
              ),
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: passengerCount.toString(),
                // hintStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                prefixIcon: IconButton(
                  onPressed: () {
                    if (passengerCount > 1) {
                      setState(() {
                        passengerCount = passengerCount - 1;
                      });
                    } else {
                      showCustomToast(
                        'Restriction!',
                        'Minimum passengers can be 1',
                        ToastificationType.error,
                      );
                    }
                  },
                  icon: Icon(
                    Icons.remove_circle_outline_outlined,
                    color: Colors.purple.shade100,
                  ),
                  iconSize: 35,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    if (passengerCount == 4) {
                      showCustomToast(
                        'Restriction!',
                        'Maximum passengers can be 4 (seating capacity!)',
                        ToastificationType.error,
                      );
                    } else {
                      setState(() {
                        passengerCount = passengerCount + 1;
                      });
                    }
                  },
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.purple.shade100,
                  ),
                  iconSize: 35,
                ),
              ),
            ),
            Divider(height: 8, thickness: 10),
            SizedBox(height: 20),
            Text(
              "Passenger options",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              value: areFixedPassenger,
              onChanged: (value) {
                setState(() {
                  areFixedPassenger = value!;
                });
              },
              title: Text(
                'Max. 2 in the back',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Think comfort ,keep the middle seat empty',
                style: TextStyle(color: Colors.grey),
              ),
              controlAffinity:
                  ListTileControlAffinity.leading, // Checkbox on the left
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
            ),

            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              // child: Fab(onPressed: () => Navigator.pushNamed(context, '')),
              child: Fab(
                onPressed: () {
                  if (areFixedPassenger) {
                    int finalPassengerCount = passengerCount + 2;
                    if (finalPassengerCount > 4) {
                      finalPassengerCount = 4;
                    }
                    setState(() {
                      passengerCount = finalPassengerCount;
                    });
                  }
                  // print(passengerCount);
                  Provider.of<Publishridemodel>(
                    context,
                    listen: false,
                  ).updatePassengerCount(passengerCount);
                  Navigator.pushNamed(context, '/publishride/pricing');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
