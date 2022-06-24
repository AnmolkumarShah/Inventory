import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnakeBar(
    BuildContext context, String text) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.notification_important,
            color: Colors.white,
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.notification_important,
            color: Colors.white,
          ),
        ],
      ),
      duration: const Duration(milliseconds: 4000),
      // width: 280.0,
      backgroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 10,
        // Inner padding for SnackBar content.
      ),
      // behavior: SnackBarBehavior.floating,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10.0),
      // ),
    ),
  );
}
