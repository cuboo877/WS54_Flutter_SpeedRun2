import 'dart:ui';

class AppColor {
  static const white = Color(0xFFFFFFFF);
  static const lightgrey = Color(0xFF5B5A5A);
  static const soFkLightGrey = Color.fromARGB(255, 217, 215, 215); // 灰
  static const black = Color.fromARGB(255, 0, 0, 0);
  static const darkBlue = Color.fromARGB(255, 46, 24, 166);
  static const red = Color.fromARGB(255, 224, 0, 0);
  static const green = Color.fromARGB(255, 29, 154, 7);
}

class AppTextStyle {
  static final mediumBlackTitle = TextStyle(
      color: AppColor.white,
      fontWeight: FontWeight.bold,
      fontFamily: "Averta",
      fontSize: 30);

  static final bigBlackTitle = TextStyle(
      color: AppColor.white,
      fontWeight: FontWeight.bold,
      fontFamily: "Averta",
      fontSize: 40);
}
