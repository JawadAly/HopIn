import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hopin/apiservices/rideService/generalRideService/grides.dart';
import 'package:hopin/models/ride.dart';
import 'package:hopin/models/searchridesmodel.dart';
import 'package:hopin/widgets/anotherInput.dart';
import 'package:hopin/widgets/searchlocationprovider.dart';
import 'package:hopin/widgets/seatsCounter.dart';
import 'package:hopin/widgets/toastprovider.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class Searchrides extends StatefulWidget {
  const Searchrides({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SearchridesState();
  }
}

class _SearchridesState extends State<Searchrides> {
  Map<String, dynamic> userRideSearchData = {
    "Leaving from": "",
    "leavingFromCoords": "",
    "Going to": "",
    "goingToCoords": "",
    "travelDate": "",
    "No. of Passengers": "",
  };
  final _pickUpControler = TextEditingController();
  final _dropOffControler = TextEditingController();
  final _passengersControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passengersControler.text = "1";
  }

  void modifyUserRideData(String field, dynamic incomingVal) {
    setState(() {
      userRideSearchData[field] = incomingVal;
    });
  }

  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final searchRideProvider = Provider.of<Searchridesmodel>(
      context,
      listen: false,
    );
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        searchRideProvider.updateTravelDate(picked);
        userRideSearchData["travelDate"] = picked;
      });
    }
  }

  void getSearchedRides(BuildContext context) async {
    final searchRideModel = context.read<Searchridesmodel>();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      showCustomToast(
        "Unauthorized Access!",
        "Unable to identify user.Please Login!",
        ToastificationType.error,
      );
      return;
    }
    Grides gRideService = Grides();
    var searchDataJson = searchRideModel.toJson();
    print(searchDataJson);
    try {
      var result = await gRideService.getMatchedRides(searchDataJson);
      print(result);
    } catch (ex) {
      showCustomToast("Error!", ex.toString(), ToastificationType.error);
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
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  children: [
                    AnotherInput(
                      keyboardType: TextInputType.text,
                      hint: 'Leaving from',
                      textObscure: false,
                      controler: _pickUpControler,
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
                                    (context) => Searchlocationprovider(
                                      hintText: "Leaving from",
                                      dataModifier: modifyUserRideData,
                                      controler: _pickUpControler,
                                      submitionFunc:
                                          (_) => Navigator.pop(context),
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
                      controler: _dropOffControler,
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
                                    (context) => Searchlocationprovider(
                                      hintText: "Going to",
                                      dataModifier: modifyUserRideData,
                                      controler: _dropOffControler,
                                      submitionFunc:
                                          (_) => Navigator.pop(context),
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
                      controler: _passengersControler,
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
                                    hintVal: _passengersControler.text,
                                    controler: _passengersControler,
                                    // initialPCount:
                                    //     userRideSearchData["No. of Passengers"],
                                  ),
                            ),
                          ),
                      readType: true,
                    ),
                    SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => getSearchedRides(context),
                        child: Text('Search'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
