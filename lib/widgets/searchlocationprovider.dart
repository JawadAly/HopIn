import 'dart:convert';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hopin/models/searchridesmodel.dart';
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

class Searchlocationprovider extends StatefulWidget {
  final Function dataModifier;
  final String hintText;
  final dynamic controler;
  final dynamic submitionFunc;

  const Searchlocationprovider({
    super.key,
    required this.dataModifier,
    required this.hintText,
    this.controler,
    this.submitionFunc,
  });

  @override
  State<Searchlocationprovider> createState() => _SearchlocationproviderState();
}

class _SearchlocationproviderState extends State<Searchlocationprovider> {
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

  void getSuggestions(String input) async {
    const String countryComponent = 'country:pk';
    const String karachiLocation = '24.8607,67.0011';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$placesApiKey&sessiontoken=$_sessionToken&components=$countryComponent&location=$karachiLocation';

    var response = await http.get(Uri.parse(request));
    if (!mounted) return;

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List predictions = data["predictions"];
      if (!mounted) return;

      setState(() {
        placesList = predictions.map((item) => item["description"]).toList();
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

    final searchRidesProvider = Provider.of<Searchridesmodel>(
      context,
      listen: false,
    );

    serviceEnabled = await currentLoc.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await currentLoc.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await currentLoc.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await currentLoc.requestPermission();
      if (permissionGranted == PermissionStatus.denied) return;
    }

    if (permissionGranted == PermissionStatus.deniedForever) {
      if (!mounted) return;
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
    if (!mounted) return;

    if (widget.hintText == "Going to") {
      searchRidesProvider.updateDropoffLocCoord(
        LatLng(locationData.latitude!, locationData.longitude!),
      );
      await executeReverseGeoCoding(
        true,
        LatLng(locationData.latitude!, locationData.longitude!),
      );
      if (mounted) Navigator.pop(context);
    } else {
      searchRidesProvider.updatePickupLocCoord(
        LatLng(locationData.latitude!, locationData.longitude!),
      );
      await executeReverseGeoCoding(
        false,
        LatLng(locationData.latitude!, locationData.longitude!),
      );
      if (mounted) Navigator.pop(context);
    }
  }

  void getAndUpdateLatLngs(String incomingAddress) async {
    final searchRidesProvider = Provider.of<Searchridesmodel>(
      context,
      listen: false,
    );
    LatLng? incomingLoc = await getLocLatLngs(incomingAddress);
    if (!mounted) return;
    if (incomingLoc == null) return;

    if (widget.hintText == "Going to") {
      searchRidesProvider.updateDropoffLocCoord(incomingLoc);
      searchRidesProvider.updateDropoffLoc(incomingAddress);
    } else {
      searchRidesProvider.updatePickupLocCoord(incomingLoc);
      searchRidesProvider.updatePickupLoc(incomingAddress);
    }
  }

  Future<void> executeReverseGeoCoding(bool isDropOff, LatLng coords) async {
    final searchRidesProvider = Provider.of<Searchridesmodel>(
      context,
      listen: false,
    );
    try {
      var result = await getLocAddress(coords);
      if (!mounted) return;

      if (result == null) {
        showCustomToast(
          "Error!",
          "Locations Services down. Try again later",
          ToastificationType.error,
        );
        return;
      }
      if (isDropOff) {
        searchRidesProvider.updateDropoffLoc(result);
      } else {
        searchRidesProvider.updatePickupLoc(result);
      }

      widget.controler.text = result;
    } catch (e) {
      if (!mounted) return;
      showCustomToast("Error!", e.toString(), ToastificationType.error);
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
                        onTap: () {
                          widget.controler.text = placesList[index].toString();
                          getAndUpdateLatLngs(placesList[index].toString());
                        },
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
                        height: 0,
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
