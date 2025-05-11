import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final dynamic keyboardType;
  final String hint;
  final bool textObscure;
  final Function changeSenseFunc;
  final Function validatorFunc;
  final int? maxLength;
  final dynamic prefIcon;
  const Input({
    super.key,
    required this.keyboardType,
    required this.hint,
    required this.textObscure,
    required this.changeSenseFunc,
    required this.validatorFunc,
    this.maxLength,
    this.prefIcon,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      obscureText: widget.textObscure,
      maxLength: widget.maxLength,
      onChanged: (value) => widget.changeSenseFunc(widget.hint, value),
      validator: (value) => widget.validatorFunc(value),
      canRequestFocus: true,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: widget.prefIcon,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade200,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
