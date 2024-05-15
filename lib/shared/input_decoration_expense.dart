import 'package:flutter/material.dart';

const expenseInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(10.0),
  fillColor: Color.fromARGB(255, 196, 208, 225),
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.elliptical(8.0, 8.0)),
    borderSide: BorderSide(color: Color.fromARGB(249, 238, 232, 232), width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.elliptical(8.0, 8.0)),
    borderSide: BorderSide(color: Color.fromARGB(255, 4, 22, 58), width: 1.0),
  ),
);
