import 'package:flutter/material.dart';

final FormDecoration = InputDecoration(
  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    // contentPadding: const EdgeInsets.only(
    //   left: 20.0,
    //   top: 10.0,
    //   bottom: 10.0,
    //
    // ),


  enabledBorder: OutlineInputBorder(

      borderSide: BorderSide(
        color: Colors.black12,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(40)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black12,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(40)),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(40)),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black12,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(40),
  ),
  fillColor: Colors.white,
  filled: true,
);
