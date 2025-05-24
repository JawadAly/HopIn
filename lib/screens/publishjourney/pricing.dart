import 'package:flutter/material.dart';
import 'package:hopin/screens/publishjourney/publishridemodel.dart';
import 'package:hopin/widgets/backiconbtn.dart';
import 'package:hopin/widgets/fab.dart';
import 'package:hopin/widgets/toastprovider.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class Pricing extends StatefulWidget {
  const Pricing({super.key});

  @override
  State<Pricing> createState() => _PricingState();
}

class _PricingState extends State<Pricing> {
  int price = 150;
  // bool areFixedPassenger = false;
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
              "Set your price per Seat",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            TextFormField(
              readOnly: true,
              textAlign: TextAlign.center,
              controller: TextEditingController(text: price.toString()),
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: price.toString(),
                // hintStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                prefixIcon: IconButton(
                  onPressed: () {
                    if (price > 100) {
                      setState(() {
                        price = price - 10;
                      });
                    } else {
                      showCustomToast(
                        'Pricing Error!',
                        'Price cant be less then 100',
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
                    setState(() {
                      price = price + 10;
                    });
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
              "Select a perfect price for this ride! You'll get passengers in no time.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            OutlinedButton(
              onPressed:
                  () => setState(() {
                    price = price + 50;
                  }),
              child: Text('Increment 50'),
            ),
            OutlinedButton(
              onPressed:
                  () => setState(() {
                    price = price + 50;
                  }),
              child: Text('Increment 100'),
            ),
            OutlinedButton(
              onPressed:
                  () => setState(() {
                    price = price + 200;
                  }),
              child: Text('Increment 200'),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Fab(
                onPressed: () {
                  Provider.of<Publishridemodel>(
                    context,
                    listen: false,
                  ).updateSeatPrice(price);
                  Navigator.pushNamed(context, '/publishride/finalize');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
