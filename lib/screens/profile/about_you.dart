import 'package:flutter/material.dart';
import 'package:hopin/screens/profile/about_you_setting.dart';

class AboutYou extends StatelessWidget {
  const AboutYou({super.key});
  static String image = 'assets/images/profile_picture.jpg';
  static String name = 'John Doe';

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      image != null && image.isNotEmpty
                          ? Image.asset(image).image
                          : null,

                  backgroundColor: Colors.grey.shade200,
                  child:
                      (image == null || image.isEmpty)
                          ? const Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.grey,
                          )
                          : null,
                ),
              ),
              SizedBox(width: 20),
              Text(
                name,
                style: TextStyle(
                  color: Colors.blueGrey.shade700,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_outlined, color: Colors.blueGrey),
            ],
          ),
          const SizedBox(height: 20),
          Setting(text: "Profile Picture", onTap: () {}),
          Setting(text: "Personal Details", onTap: () {}),

          const Divider(color: Colors.grey),
          const SizedBox(height: 10),

          label('Verify your profile'),
          const SizedBox(height: 10),
          Setting(text: 'Verify email address', onTap: () {}),

          const Divider(color: Colors.grey),
          const SizedBox(height: 10),

          label('About you'),
          const SizedBox(height: 10),
          Setting(text: 'Add a mini bio', onTap: () {}),
          Setting(text: 'Edit travel prefences', onTap: () {}),

          const Divider(color: Colors.grey),
          const SizedBox(height: 10),

          label('Vehicle'),
          const SizedBox(height: 10),
          Setting(text: 'Add vehicle', onTap: () {}),
        ],
      ),
    );
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
