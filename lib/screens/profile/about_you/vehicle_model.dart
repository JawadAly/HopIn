import 'package:flutter/material.dart';
import 'package:hopin/data/vehicle_list.dart';
import 'package:hopin/widgets/search_item.dart';
import 'vehicle_color.dart';

class VehicleModel extends StatelessWidget {
  const VehicleModel({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              for (String model in VehicleList.carModelsByBrand[title]!)
                SearchItem(
                  title: model,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VehicleColor(),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
