import 'package:flutter/material.dart';
import 'package:hopin/screens/publishjourney/publishridemodel.dart';
import 'package:hopin/widgets/backiconbtn.dart';
import 'package:hopin/widgets/fab.dart';
import 'package:provider/provider.dart';

class Traveltime extends StatefulWidget {
  const Traveltime({super.key});

  @override
  State<Traveltime> createState() => _TraveltimeState();
}

class _TraveltimeState extends State<Traveltime> {
  String? selectedTime;
  final _selectedTimeGKey = GlobalKey<FormState>();
  void _showTimePickerDialog(BuildContext context) async {
    final TimeOfDay? timeVal = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (timeVal != null) {
      setState(() {
        selectedTime = timeVal.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Backiconbtn(incomingContext: context),
            SizedBox(height: 20),
            Text(
              "At what time will you pick passengers up?",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Form(
                  key: _selectedTimeGKey,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: TextEditingController(text: selectedTime ?? ''),
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    readOnly: true,
                    onTap: () => _showTimePickerDialog(context),
                    decoration: InputDecoration(
                      hintText: selectedTime ?? "8:00",
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.purple.shade400,
                        size: 40,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    validator: (incomingVal) {
                      return incomingVal == null || incomingVal.isEmpty
                          ? "Time is requied field*"
                          : null;
                    },
                  ),
                ),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Fab(
                onPressed:
                    () => {
                      if (_selectedTimeGKey.currentState!.validate())
                        {
                          Provider.of<Publishridemodel>(
                            context,
                            listen: false,
                          ).updateTravelTime(selectedTime!),
                          Navigator.pushNamed(
                            context,
                            '/publishride/passengercounter',
                          ),
                        },
                    },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
