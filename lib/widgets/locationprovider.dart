import 'dart:convert';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hopin/screens/publishjourney/publishridemodel.dart';
import 'package:hopin/widgets/toastprovider.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as otherPermissions;
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../apiservices/geocoder.dart';
import 'package:flutter/material.dart';
import 'package:hopin/widgets/input.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../models/citiesList.dart' as incomingCities;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationProvider extends StatefulWidget {
  final Function? dataModifier;
  final String hintText;
  final dynamic controler;
  final dynamic submitionFunc;
  const LocationProvider({
    super.key,
    this.dataModifier,
    required this.hintText,
    this.controler,
    this.submitionFunc,
  });
  @override
  State<LocationProvider> createState() => _LocationProviderState();
}

class _LocationProviderState extends State<LocationProvider> {
  final String? placesApiKey = dotenv.env['GOOGLE_API_KEY'];
  var uuid = Uuid();
  String? _sessionToken;
  List<dynamic> placesList = [];

  @override
  void initState() {
    super.initState();
    widget.controler.addListener(() {
      onChange();
    });
  }

  void onChange() {
    _sessionToken = _sessionToken ?? uuid.v4();
    getSuggestions(widget.controler.text);
  }

  // void getSuggestions(String userInput) {
  //   setState(() {
  //     placesList =
  //         incomingCities.placesList.where((place) {
  //           return place.toLowerCase().contains(userInput.toLowerCase());
  //         }).toList();
  //   });
  //   print(placesList);
  // }

  void getSuggestions(String input) async {
    const String countryComponent = 'country:pk';
    const String karachiLocation = '24.8607,67.0011';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$placesApiKey&sessiontoken=$_sessionToken&components=$countryComponent&location=$karachiLocation';
    var response = await http.get(Uri.parse(request));
    // print(response.body.toString());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List predictions = data["predictions"];
      setState(() {
        placesList =
            predictions.map((item) {
              // return item["structured_formatting"]["main_text"];
              return item["description"];
            }).toList();
      });
    } else {
      throw Exception('Failed to Load Places from Google Places API!');
    }
  }

  fetchCurrentLocation() async {
    Location currentLoc = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    final publishRidesProvider = Provider.of<Publishridemodel>(
      context,
      listen: false,
    );

    //checking wether these services are enabled\
    serviceEnabled = await currentLoc.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await currentLoc.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await currentLoc.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await currentLoc.requestPermission();
      if (permissionGranted == PermissionStatus.denied) {
        return;
      }
    }

    if (permissionGranted == PermissionStatus.deniedForever) {
      // Show a dialog or redirect to settings
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Permission Required"),
              content: Text(
                "Location permission is permanently denied. Please enable it in the app settings.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    otherPermissions.openAppSettings();
                  },
                  child: Text("Open Settings"),
                ),
              ],
            ),
      );
      return;
    }

    locationData = await currentLoc.getLocation();
    // print(_locationData);
    // generateAddressFromCoords(_locationData);

    //setting current locationData
    if (widget.hintText == "Enter drop off location") {
      publishRidesProvider.updateDropoffLocCoord(
        LatLng(locationData.latitude!, locationData.longitude!),
      );
      await executeReverseGeoCoding(
        true,
        LatLng(locationData.latitude!, locationData.longitude!),
      );
      Navigator.pushNamed(context, '/publishride/routedecider');
    } else {
      publishRidesProvider.updatePickupLocCoord(
        LatLng(locationData.latitude!, locationData.longitude!),
      );
      await executeReverseGeoCoding(
        false,
        LatLng(locationData.latitude!, locationData.longitude!),
      );
      Navigator.pushNamed(context, '/publishride/dropoff');
    }
  }

  void getAndUpdateLatLngs(String incomingAddress) async {
    final publishRidesProvider = Provider.of<Publishridemodel>(
      context,
      listen: false,
    );
    LatLng? incomingLoc = await getLocLatLngs(incomingAddress);
    if (incomingLoc == null) {
      return;
    }
    // print(incomingLoc);
    // print(widget.hintText);
    if (widget.hintText == "Enter drop off location") {
      publishRidesProvider.updateDropoffLocCoord(incomingLoc);
      publishRidesProvider.updateDropoffLoc(incomingAddress);
    } else {
      publishRidesProvider.updatePickupLocCoord(incomingLoc);
      publishRidesProvider.updatePickupLoc(incomingAddress);
    }
  }

  Future<void> executeReverseGeoCoding(bool isDropOff, LatLng coords) async {
    final publishRidesProvider = Provider.of<Publishridemodel>(
      context,
      listen: false,
    );
    try {
      var result = await getLocAddress(coords);
      if (result == null) {
        showCustomToast(
          "Error!",
          "Locations Serivces down try again later",
          ToastificationType.error,
        );
        return;
      }
      print(result);
      if (isDropOff) {
        publishRidesProvider.updateDropoffLoc(result);
      } else {
        publishRidesProvider.updatePickupLoc(result);
      }
    } catch (e) {
      showCustomToast("Error!", e.toString(), ToastificationType.error);
    }
  }

  // void generateAddressFromCoords(LocationData incomingLocData) async {
  //   try {
  //     final String incomingAddress = await getAddressFromCoords(
  //       incomingLocData.latitude!,
  //       incomingLocData.longitude!,
  //     );
  //     if (incomingAddress == "Address not found for given coordinates.") {
  //       showCustomToast(
  //         "Inaccurate Location",
  //         "Error fetching location please move to a different location and then try again!",
  //         ToastificationType.error,
  //       );
  //       return;
  //     } else if (incomingAddress ==
  //         "Throttled! See geocode.xyz/pricing, Throttled! See geocode.xyz/pricing, Throttled! See geocode.xyz/pricing") {
  //       showCustomToast(
  //         "Please Wait!",
  //         "Location services exhausted! Please wait a bit then try again or else search location manually.",
  //         ToastificationType.error,
  //       );
  //     } else {
  //       //setting current locationData
  //       print(incomingAddress);
  //       widget.controler.text = incomingAddress;
  //     }
  //   } catch (e) {
  //     showCustomToast(
  //       "Error getting current location",
  //       "Error: $e",
  //       ToastificationType.error,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Input(
              keyboardType: TextInputType.text,
              submitionFunc: widget.submitionFunc,
              hint: widget.hintText,
              textObscure: false,
              changeSenseFunc: widget.dataModifier ?? () {},
              controler: widget.controler,
              validatorFunc: () {},
              prefIcon: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              readOnly: true,
              onTap: () => fetchCurrentLocation(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Use current location',
                hintStyle: TextStyle(fontWeight: FontWeight.bold),
                suffixIcon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade500,
                ),
                prefixIcon: Icon(
                  Icons.location_searching,
                  color: Colors.grey.shade500,
                ),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: placesList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        onTap:
                            () => {
                              widget.controler.text =
                                  placesList[index].toString(),
                              getAndUpdateLatLngs(placesList[index].toString()),
                            },

                        // title: Text(placesList[index]['description']),
                        title: Text(placesList[index].toString()),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                        leading: Icon(
                          Icons.location_on_outlined,
                          color: Colors.purple.shade200,
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                        height: 0, // To keep it snug
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
