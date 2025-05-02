import 'package:flutter/material.dart';
import 'package:hopin/widgets/anotherInput.dart';
import 'package:hopin/widgets/locationprovider.dart';
import 'package:hopin/widgets/seatsCounter.dart';

class Searchrides extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchridesState();
  }
}

class _SearchridesState extends State<Searchrides> {
  Map<String, dynamic> userRideSearchData = {
    "Leaving from": "",
    "Going to": "",
    "travelDate": "",
    "No. of Passengers": 1,
  };

  void modifyUserRideData(String field, dynamic incomingVal) {
    setState(() {
      userRideSearchData[field] = incomingVal;
    });
  }

  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        userRideSearchData["travelDate"] = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/anotherSearchBg.jpg"),
              fit: BoxFit.cover,
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              Text(
                "Your Pickup of rides at fair prices!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top:
              MediaQuery.of(context).size.height *
              0.25, // adjust to sit below image
          left: 16,
          right: 16,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.42,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white.withOpacity(0.9),
              // color: Colors.white,
            ), // semi-transparent background
            child: Form(
              child: Column(
                children: [
                  AnotherInput(
                    keyboardType: TextInputType.text,
                    hint: 'Leaving from',
                    textObscure: false,
                    controler: TextEditingController(
                      text: userRideSearchData["Leaving from"],
                    ),
                    changeSenseFunc: () {},
                    validatorFunc: () {},
                    prefIcon: Icon(Icons.circle_outlined),
                    readType: true,
                    tapFunc:
                        (incomingContext) => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => LocationProvider(
                                    dataModifier: modifyUserRideData,
                                    hintText: 'Leaving from',
                                  ),
                            ),
                          ),
                        },
                  ),
                  SizedBox(height: 25),
                  AnotherInput(
                    keyboardType: TextInputType.text,
                    hint: 'Going to',
                    textObscure: false,
                    controler: TextEditingController(
                      text: userRideSearchData["Going to"],
                    ),
                    changeSenseFunc: () {},
                    validatorFunc: () {},
                    prefIcon: Icon(Icons.circle_outlined),
                    readType: true,
                    tapFunc:
                        (incomingContext) => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => LocationProvider(
                                    dataModifier: modifyUserRideData,
                                    hintText: 'Going to',
                                  ),
                            ),
                          ),
                        },
                  ),
                  SizedBox(height: 25),
                  AnotherInput(
                    keyboardType: TextInputType.text,
                    hint: 'Going to',
                    textObscure: false,
                    changeSenseFunc: modifyUserRideData,
                    validatorFunc: () {},
                    prefIcon: Icon(Icons.calendar_month_outlined),
                    tapFunc: _selectDate,
                    readType: true,
                    controler: TextEditingController(
                      text:
                          selectedDate == null
                              ? ''
                              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    ),
                  ),
                  SizedBox(height: 25),
                  AnotherInput(
                    keyboardType: TextInputType.text,
                    hint: 'No. of Passengers',
                    textObscure: false,
                    changeSenseFunc: () {},
                    validatorFunc: () {},
                    prefIcon: Icon(Icons.person_outline),
                    tapFunc:
                        (incomingContext) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => Seatscounter(
                                  countModifierFunc: modifyUserRideData,
                                  hintVal: "No. of Passengers",
                                  initialPCount:
                                      userRideSearchData["No. of Passengers"],
                                ),
                          ),
                        ),
                    readType: true,
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => print(userRideSearchData),
                      child: Text('Search'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
