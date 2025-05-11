import 'package:flutter/material.dart';
import 'package:hopin/widgets/input.dart';
import 'package:hopin/data/vehicle_list.dart';
import 'package:hopin/screens/profile/about_you/vehicle_model.dart';
import 'package:hopin/widgets/search_item.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  List<String> filteredBrands = [];

  @override
  void initState() {
    super.initState();
    filteredBrands = VehicleList.carModelsByBrand.keys.toList();
  }

  void filterBrands(String query) {
    final results =
        VehicleList.carModelsByBrand.keys
            .where((brand) => brand.toLowerCase().contains(query.toLowerCase()))
            .toList();

    setState(() {
      filteredBrands = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  "Whats your vehicle Brand?",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Input(
                  keyboardType: TextInputType.name,
                  hint: "Example: Honda",
                  textObscure: false,
                  changeSenseFunc: (field, value) {
                    filterBrands(value);
                  },
                  validatorFunc: (value) {},
                  prefIcon: Icon(Icons.search_outlined),
                ),

                const SizedBox(height: 20),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      for (String brand in filteredBrands)
                        SearchItem(
                          title: brand,
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => VehicleModel(title: brand),
                                ),
                              ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
