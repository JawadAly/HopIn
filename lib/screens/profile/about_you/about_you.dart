import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hopin/screens/profile/about_you/about_you_setting.dart';
import 'package:hopin/screens/profile/about_you/image_picker_service.dart';

class AboutYou extends StatefulWidget {
  const AboutYou({super.key});

  @override
  State<AboutYou> createState() => _AboutYouState();
}

class _AboutYouState extends State<AboutYou> {
  String image = '';
  String name = 'Ahmad Mustabassir Javed';

  void onImageSelected(File newImage) {
    setState(() {
      image = newImage.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            image.isNotEmpty
                                ? Image.file(File(image)).image
                                : null,
                        backgroundColor: Colors.grey.shade200,
                        child:
                            image.isEmpty
                                ? const Icon(
                                  Icons.person,
                                  size: 100,
                                  color: Colors.grey,
                                )
                                : null,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            name
                                .split(' ')
                                .map(
                                  (word) => Text(
                                    word,
                                    style: TextStyle(
                                      color: Colors.blueGrey.shade700,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_outlined,
                      color: Colors.blueGrey,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Setting(text: "Profile Picture", onTap: profilePictureOnTap),
                Setting(text: "Personal Details", onTap: personalDetailsOnTap),

                const Divider(color: Colors.grey),
                const SizedBox(height: 10),

                label('Verify your profile'),
                const SizedBox(height: 10),
                Setting(text: 'Verify email address', onTap: () {}),

                const Divider(color: Colors.grey),
                const SizedBox(height: 10),

                label('About you'),
                const SizedBox(height: 10),
                Setting(text: 'Add a mini bio', onTap: miniBioOnTap),
                Setting(
                  text: 'Edit travel preferences',
                  onTap: travelPreferencesOntap,
                ),

                const Divider(color: Colors.grey),
                const SizedBox(height: 10),

                label('Vehicle'),
                const SizedBox(height: 10),
                Setting(text: 'Add vehicle', onTap: addvehicleOnTap),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // on taps methods
  profilePictureOnTap() {
    ImagePickerService().showPickOptionsDialog(
      context: context,
      onImageSelected: onImageSelected,
    );
  }

  personalDetailsOnTap() {
    Navigator.pushNamed(context, '/about_you/personal_details');
  }

  miniBioOnTap() {
    Navigator.pushNamed(context, '/about_you/mini_bio');
  }

  travelPreferencesOntap() {
    Navigator.pushNamed(context, '/about_you/travel_preferences');
  }

  addvehicleOnTap() {
    Navigator.pushNamed(context, '/about_you/add_vehicle');
  }

  label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blueGrey.shade700,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
