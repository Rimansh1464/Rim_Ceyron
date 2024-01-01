import 'package:flutter/material.dart';

import 'colors.dart';

void nextScreen(context, page) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

Container comContainer(context, Height, Width, text) {
  return Container(
    height: Height,
    width: Width,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      gradient: LinearGradient(
        colors: [
          primary,
          primary2,
        ],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF4C2E84).withOpacity(0.2),
          offset: const Offset(0, 15.0),
          blurRadius: 60.0,
        ),
      ],
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

void openSnackBar(BuildContext context, String snackMessage, Color color) {
  SnackBar snackBar = SnackBar(
    backgroundColor: color,
    content: Text(snackMessage),
    action: SnackBarAction(
      label: "OK",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
