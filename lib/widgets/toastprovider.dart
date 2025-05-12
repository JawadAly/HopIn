import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showCustomToast(String text, String desc, dynamic toastType) {
  toastification.show(
    title: Text(text),
    type: toastType,
    description: Text(desc),
    alignment: Alignment.bottomRight,
    autoCloseDuration: const Duration(seconds: 5),
  );
}
