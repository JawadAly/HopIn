import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hopin/widgets/fab.dart';
import 'package:hopin/widgets/toastprovider.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hopin/screens/publishjourney/publishridemodel.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:hopin/widgets/backiconbtn.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../apiservices/apiconstants.dart';

class Routedecider extends StatefulWidget {
  const Routedecider({super.key});

  @override
  State<Routedecider> createState() => _RoutedeciderState();
}

class _RoutedeciderState extends State<Routedecider> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng _sourceCoords = LatLng(24.899994, 67.168259);
  static const LatLng _destCoords = LatLng(24.8934, 67.0281);
  final Set<Marker> _mark = {
    Marker(
      markerId: MarkerId('_source'),
      position: _sourceCoords,
      icon: BitmapDescriptor.defaultMarker,
    ),
    Marker(
      markerId: MarkerId('_destination'),
      position: _destCoords,
      icon: BitmapDescriptor.defaultMarker,
    ),
  };
  Set<Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};
  LatLng? _sourceCrds;
  LatLng? _destCrds;

  String? source;
  String? destination;

  @override
  void initState() {
    super.initState();
    // Wait for a short time to ensure the map has initialized
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initializeMarkersAndRoute().then((_) async {
        await getPolylinePoints().then((incomingCoordinates) {
          generatePolylineOnMap(incomingCoordinates);
        });
      });

      await Future.delayed(Duration(seconds: 1));
      _fitMapToMarkers(); // fit map after markers are loaded
    });
  }

  Future<void> initializeMarkersAndRoute() async {
    // setState(() {
    //   _markers = _mark;
    // });
    final publishRidesModel = Provider.of<Publishridemodel>(
      context,
      listen: false,
    );
    final incomingMarkers = publishRidesModel.getMarkerSet();
    final incomingSourceCoords = publishRidesModel.getPickupLocCoords();
    final incomingDestCoords = publishRidesModel.getDropoffLocCoords();
    final incomingSrc = publishRidesModel.getPickUpLoc();
    final incomingDest = publishRidesModel.getDropOffLoc();
    setState(() {
      _markers = incomingMarkers;
      _sourceCrds = incomingSourceCoords;
      _destCrds = incomingDestCoords;
      source = incomingSrc;
      destination = incomingDest;
    });
    return;
  }

  void _fitMapToMarkers() async {
    final GoogleMapController controller = await _controller.future;

    final latLngs = _markers.map((m) => m.position).toList();

    double minLat = latLngs
        .map((m) => m.latitude)
        .reduce((a, b) => a < b ? a : b);
    double maxLat = latLngs
        .map((m) => m.latitude)
        .reduce((a, b) => a > b ? a : b);
    double minLng = latLngs
        .map((m) => m.longitude)
        .reduce((a, b) => a < b ? a : b);
    double maxLng = latLngs
        .map((m) => m.longitude)
        .reduce((a, b) => a > b ? a : b);

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoords = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(_sourceCrds!.latitude, _sourceCrds!.longitude),
        destination: PointLatLng(_destCrds!.latitude, _destCrds!.longitude),
        // origin: PointLatLng(_sourceCoords.latitude, _sourceCoords.longitude),
        // destination: PointLatLng(_destCoords.latitude, _destCoords.longitude),
        mode: TravelMode.driving,
      ),
      googleApiKey: googleApiKey,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoords.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      showCustomToast(
        "Error",
        "${result.errorMessage}",
        ToastificationType.error,
      );
    }
    print(polylineCoords);
    return polylineCoords;
  }

  void generatePolylineOnMap(List<LatLng> polylineCoords) {
    PolylineId polyId = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: polyId,
      color: Colors.blue,
      width: 10,
      points: polylineCoords,
    );
    setState(() {
      polylines[polyId] = polyline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map as background
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(24.899994, 67.168259),
              zoom: 15,
            ),
            markers: _markers,
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Positioned(
            top: 35,
            left: 8,
            child: Backiconbtn(
              incomingContext: context,
              btnColor: Colors.purple.shade400,
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3, // Initial size (30% of screen)
            minChildSize: 0.1, // Minimum size
            maxChildSize: 0.9, // Maximum size
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text("Pickup From"),
                      subtitle: Text(source ?? 'Loading...'),
                    ),
                    ListTile(
                      title: Text("Drop Off to"),
                      subtitle: Text(
                        destination ?? 'Loading...',
                        maxLines: null, // allow unlimited lines
                        overflow: TextOverflow.visible, // show full text
                        softWrap: true,
                      ),
                    ),
                    // Spacer(),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Fab(
                          onPressed:
                              () => Navigator.pushNamed(
                                context,
                                "/publishride/traveldate",
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
