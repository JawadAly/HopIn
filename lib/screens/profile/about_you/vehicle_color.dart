import 'package:flutter/material.dart';
import 'package:hopin/data/vehicle_list.dart';
import 'package:hopin/widgets/button.dart';

class VehicleColor extends StatefulWidget {
  const VehicleColor({super.key});

  @override
  State<VehicleColor> createState() => _VehicleColorState();
}

class _VehicleColorState extends State<VehicleColor> {
  String? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select your vehicle's color",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: colorRadio()),
            CustomButton(text: 'save', onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget colorRadio() {
    return ListView(
      children:
          VehicleList.solidCarColors.entries.map((entry) {
            final name = entry.key;
            final color = entry.value;

            return RadioListTile<String>(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black12),
                    ),
                  ),
                ],
              ),
              value: name,
              groupValue: selectedColor,
              onChanged: (value) {
                setState(() {
                  selectedColor = value;
                });
              },
            );
          }).toList(),
    );
  }
}
