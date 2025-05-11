import 'package:flutter/material.dart';
import 'package:hopin/widgets/fab.dart';

class SignUpDob extends StatefulWidget {
  const SignUpDob({super.key});

  @override
  State<SignUpDob> createState() => _SignUpDobState();
}

class _SignUpDobState extends State<SignUpDob> {
  DateTime? selectedDate;
  final TextEditingController _dateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
        _dateController.text = "${date.day}/${date.month}/${date.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "What's your date of birth?",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: InputDecoration(
                  hintText: "dd/mm/yyyy",
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your date of birth';
                  }
                  return null;
                },
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Fab(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, '/sign_up/password');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
