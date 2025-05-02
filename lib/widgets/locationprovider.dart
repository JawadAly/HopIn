import 'package:flutter/material.dart';
import 'package:hopin/widgets/input.dart';

class LocationProvider extends StatefulWidget {
  final Function dataModifier;
  final String hintText;
  LocationProvider({required this.dataModifier, required this.hintText});
  @override
  State<LocationProvider> createState() => _LocationProviderState();
}

class _LocationProviderState extends State<LocationProvider> {
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
              hint: widget.hintText,
              textObscure: false,
              changeSenseFunc: widget.dataModifier,
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
          ],
        ),
      ),
    );
  }
}
