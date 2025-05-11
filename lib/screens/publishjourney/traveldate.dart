import 'package:flutter/material.dart';
import 'package:hopin/screens/publishjourney/publishridemodel.dart';
import 'package:hopin/widgets/backiconbtn.dart';
import 'package:hopin/widgets/fab.dart';
import 'package:hopin/widgets/input.dart';
import 'package:provider/provider.dart';

class Traveldate extends StatefulWidget {
  const Traveldate({super.key});

  @override
  State<Traveldate> createState() => _TraveldateState();
}

class _TraveldateState extends State<Traveldate> {
  DateTime? travelDate;
  late TextEditingController _dateController;
  final _userTravelDateGKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: travelDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        travelDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
        // Provider.of<Publishridemodel>(
        //   context,
        //   listen: false,
        // ).updateTravelDate(picked);
      });
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
            SizedBox(height: 20),
            Backiconbtn(incomingContext: context),
            SizedBox(height: 20),
            Text(
              "When are you going?",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Form(
              key: _userTravelDateGKey,
              child: Input(
                keyboardType: TextInputType.datetime,
                hint: "When are you going?",
                textObscure: false,
                prefIcon: Icon(Icons.calendar_month_outlined),
                changeSenseFunc: () {},
                validatorFunc: (val) {
                  return val == null || val.trim().isEmpty
                      ? "Date is required*"
                      : null;
                },
                tapFunc: _selectDate,
                controler: _dateController,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Fab(
                onPressed: () {
                  if (_userTravelDateGKey.currentState!.validate()) {
                    Provider.of<Publishridemodel>(
                      context,
                      listen: false,
                    ).updateTravelDate(travelDate!);
                    Navigator.pushNamed(context, '/publishride/traveltime');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
