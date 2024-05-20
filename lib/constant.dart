import 'package:flutter/material.dart';

ButtonStyle buttonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) {
      // Check if the button is pressed or disabled, and return the appropriate color
      if (states.contains(MaterialState.pressed)) {
        return Colors.white.withOpacity(0.8); // Adjust opacity if needed
      } else if (states.contains(MaterialState.disabled)) {
        return Colors.grey; // Adjust disabled color if needed
      }
      return Colors.white; // Default button color
    },
  ),
  backgroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) {
      // Check if the button is pressed or disabled, and return the appropriate color
      if (states.contains(MaterialState.pressed)) {
        return Color(0xffE15524).withOpacity(0.8); // Adjust opacity if needed
      } else if (states.contains(MaterialState.disabled)) {
        return Colors.grey; // Adjust disabled color if needed
      }
      return Color(0xffE15524); // Default button color
    },
  ),
  minimumSize: MaterialStateProperty.all(
      Size(double.infinity, 60)), // Set the desired height

  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0), // Set border radius here
    ),
  ),
);

ButtonStyle btnStyle(double btnWidth, double btnHeight) {
  return ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        // Check if the button is pressed or disabled, and return the appropriate color
        if (states.contains(MaterialState.pressed)) {
          return Colors.white.withOpacity(0.8); // Adjust opacity if needed
        } else if (states.contains(MaterialState.disabled)) {
          return Colors.grey; // Adjust disabled color if needed
        }
        return Colors.white; // Default button color
      },
    ),
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        // Check if the button is pressed or disabled, and return the appropriate color
        if (states.contains(MaterialState.pressed)) {
          return Color(0xffE15524).withOpacity(0.8); // Adjust opacity if needed
        } else if (states.contains(MaterialState.disabled)) {
          return Colors.grey; // Adjust disabled color if needed
        }
        return Color(0xffE15524); // Default button color
      },
    ),
    minimumSize: MaterialStateProperty.all(
        Size(btnWidth, btnHeight)), // Set the desired height

    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0), // Set border radius here
      ),
    ),
  );
}

Color themeColor = Color(0xffE15524);
