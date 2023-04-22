import 'package:flutter/material.dart';
import 'colors.dart';

final ButtonStyle buttonPrimary = ElevatedButton.styleFrom(
  minimumSize: const Size(200, 50),
  backgroundColor: Colors.red,
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(50)
    )
  )
);