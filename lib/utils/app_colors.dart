import 'package:flutter/material.dart';
class AppColors {
  static const Color cardColor = Color.fromARGB(255, 150, 214, 223);
  static Color appColor = Color(0xff3E2E6B);
  static const Color buttonColor = Color(0xff224079);
  static const Color appCard = Color.fromARGB(255, 244, 179, 255);

  static const Color primaryColor = Color(0xff01509F);
  static const Color orderCardColor = Color.fromARGB(255, 120, 205, 255);
  static const Color orderCardTitle = Color.fromARGB(255, 35, 87, 184);

  static const Color isEmployees = Color(0xff01509F);
  static const Color isAreas = Color.fromARGB(255, 77, 76, 76);
  static const Color isOrderCard = Color.fromARGB(255, 158, 201, 218);
  static const Color isOrder = Color.fromARGB(255, 63, 106, 122);
  static const Color isCustomers = Color.fromARGB(255, 44, 17, 95);
  static const Color isMechanics = Color.fromARGB(255, 0, 104, 52);
  
  static Color getEmployee(Set<MaterialState> states) {
    return Color.fromARGB(255, 182, 218, 255);
  }
  static Color getColors(Set<MaterialState> states) {
    return Colors.white;
  }
  static Color getArea(Set<MaterialState> states) {
    return Color.fromARGB(255, 207, 207, 207);
  }
  static Color getCustomer(Set<MaterialState> states) {
    return Color.fromARGB(255, 213, 191, 253);
  }
  static Color getMechanic(Set<MaterialState> states) {
    return Color.fromARGB(255, 198, 255, 227);
  }
  static Color getAll(Set<MaterialState> states) {
    return Color.fromARGB(255, 197, 252, 252);
  }
}
