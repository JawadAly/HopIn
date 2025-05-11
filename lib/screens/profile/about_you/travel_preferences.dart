import 'package:flutter/material.dart';
import 'package:hopin/widgets/button.dart';

class TravelPreferences extends StatefulWidget {
  const TravelPreferences({super.key});

  @override
  State<TravelPreferences> createState() => _TravelPreferencesState();
}

class _TravelPreferencesState extends State<TravelPreferences> {
  String selectedValueChat = 'Im Chatty when i feel confortable';
  String selectedValueMusic = 'Its all about the playlist';
  String selectedValueSmoke = 'Cigarettes break outside the car is ok';
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
              child: const Text(
                "What are your travel preferences?",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),
            label('Chattiness'),
            const SizedBox(height: 10),
            customDropdown(
              value: selectedValueChat,
              items: [
                'Im Chatty when i feel confortable',
                'I love to chat',
                'Im the quiet type',
              ],
              onChanged: (value) {
                setState(() {
                  selectedValueChat = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            label('Music'),
            const SizedBox(height: 10),
            customDropdown(
              value: selectedValueMusic,
              items: [
                'Its all about the playlist',
                'Ill jam depending on the mood',
                'Silence is golden',
              ],
              onChanged: (value) {
                setState(() {
                  selectedValueMusic = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            label('Smoking'),
            const SizedBox(height: 10),
            customDropdown(
              value: selectedValueSmoke,
              items: [
                'Cigarettes break outside the car is ok',
                'Im fine with smoking',
                'No Smoking, please',
              ],
              onChanged: (value) {
                setState(() {
                  selectedValueSmoke = value!;
                });
              },
            ),
            Spacer(),
            CustomButton(text: 'Save', onPressed: () {}),
            Spacer(),
          ],
        ),
      ),
    );
  }

  label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget customDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hint,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),

      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: SizedBox(), // Removes the default underline
        dropdownColor: Colors.grey.shade200, // Dropdown popup color
        hint: hint != null ? Text(hint) : null,
        items:
            items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 110, 78, 163),
                  ),
                ),
              );
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
