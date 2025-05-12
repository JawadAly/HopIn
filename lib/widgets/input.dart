import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final dynamic keyboardType;
  final String hint;
  final bool textObscure;
  final Function changeSenseFunc;
  final Function validatorFunc;
  final int? maxLength;
  final dynamic prefIcon;
  final dynamic tapFunc;
  final bool? readType;
  final dynamic controler;
  final dynamic submitionFunc;
  Input({
    required this.keyboardType,
    required this.hint,
    required this.textObscure,
    required this.changeSenseFunc,
    required this.validatorFunc,
    this.maxLength,
    this.prefIcon,
    this.tapFunc,
    this.readType,
    this.controler,
    this.submitionFunc,
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
      onFieldSubmitted: widget.submitionFunc,
      readOnly: widget.readType ?? false,
      maxLength: widget.maxLength,
      controller: widget.controler,
      onChanged: (value) => widget.changeSenseFunc(widget.hint, value),
      validator: (value) => widget.validatorFunc(value),
      onTap: widget.tapFunc != null ? () => widget.tapFunc!(context) : null,
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
