import 'package:flutter/material.dart';

MaterialStateProperty<Color> materialStatePropertyColor({required Color color}) =>
    MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        return color;
      },
    );
