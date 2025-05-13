import 'package:flutter/material.dart';

class AnotherInput extends StatefulWidget {
  final dynamic keyboardType;
  final String hint;
  final bool textObscure;
  final Function changeSenseFunc;
  final Function validatorFunc;
  final int? maxLength;
  final dynamic prefIcon;
  final dynamic initialVal;
  final dynamic tapFunc;
  final bool readType;
  final dynamic controler;
  const AnotherInput({
    super.key,
    required this.keyboardType,
    required this.hint,
    required this.textObscure,
    required this.changeSenseFunc,
    required this.validatorFunc,
    this.maxLength,
    this.prefIcon,
    this.initialVal,
    this.tapFunc,
    required this.readType,
    this.controler,
  });

  @override
  State<AnotherInput> createState() => _AnotherInputState();
}

class _AnotherInputState extends State<AnotherInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      obscureText: widget.textObscure,
      readOnly: widget.readType,
      maxLength: widget.maxLength,
      initialValue: widget.initialVal,
      controller: widget.controler,
      onChanged: (value) => widget.changeSenseFunc(widget.hint, value),
      onTap: () => widget.tapFunc(context),
      validator: (value) => widget.validatorFunc(value),
      canRequestFocus: true,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: widget.prefIcon,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        // filled: true,
        // fillColor: Colors.white70,
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(20),
        //   borderSide: BorderSide.none,
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(20),
        //   borderSide: BorderSide.none,
        // ),
      ),
    );
  }
}
