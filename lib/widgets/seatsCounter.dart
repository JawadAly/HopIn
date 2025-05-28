import 'package:flutter/material.dart';
import 'package:hopin/models/searchridesmodel.dart';
import 'package:hopin/widgets/fab.dart';
import 'package:hopin/widgets/toastprovider.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class Seatscounter extends StatefulWidget {
  // final int? initialPCount;
  final Function? countModifierFunc;
  final String? hintVal;
  final dynamic controler;
  const Seatscounter({
    super.key,
    // this.initialPCount,
    this.countModifierFunc,
    this.hintVal,
    this.controler,
  });
  @override
  State<Seatscounter> createState() => _SeatscounterState();
}

class _SeatscounterState extends State<Seatscounter> {
  int? countVal;
  @override
  void initState() {
    super.initState();
    countVal = int.parse(widget.controler.text);
    // countVal = widget.initialPCount ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            IconButton(
              onPressed: () {
                Provider.of<Searchridesmodel>(
                  context,
                  listen: false,
                ).updatePassengerCount(countVal!);
                widget.countModifierFunc!(widget.hintVal, countVal);
                Navigator.pop(context);
              },
              icon: Icon(Icons.cancel_outlined),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Number of Seats to Book',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            TextFormField(
              readOnly: true,
              textAlign: TextAlign.center,
              controller: widget.controler,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                // hintText: widget.controler.text,
                // hintStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      countVal = countVal! + 1;
                    });
                    widget.controler.text = countVal.toString();
                  },
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.purple.shade100,
                  ),
                  iconSize: 35,
                ),
                prefixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      if (countVal! > 1) {
                        countVal = countVal! - 1;
                      } else {
                        showCustomToast(
                          "Error",
                          "Passengers cannot be less then zero!",
                          ToastificationType.error,
                        );
                      }
                    });
                    widget.controler.text = countVal.toString();
                  },
                  icon: Icon(
                    Icons.remove_circle_outline_outlined,
                    color: Colors.purple.shade100,
                  ),
                  iconSize: 35,
                ),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Fab(
                onPressed:
                    () => {
                      Provider.of<Searchridesmodel>(
                        context,
                        listen: false,
                      ).updatePassengerCount(countVal!),
                      Navigator.pop(context),
                    },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
