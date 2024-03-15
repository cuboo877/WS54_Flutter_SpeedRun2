import 'dart:math';

import 'package:flutter/material.dart';

import '../constant/style_guide.dart';

class Utilities {
  static String randomPasswordCondition(
      String userID,
      bool hasLowerCase,
      bool hasUpperCase,
      bool hasNumber,
      bool hasSymbol,
      String customChars,
      int length) {
    StringBuffer buffer = StringBuffer();
    StringBuffer resultBuffer = StringBuffer();
    int customCharsLength = 0;
    if (customChars.trim().isEmpty) {
      customCharsLength = 0;
    } else {
      customCharsLength = customChars.length;
    }
    if (hasLowerCase) {
      buffer.write("abcdefghijklmnopqrstuvwxyz");
    }
    if (hasUpperCase) {
      buffer.write("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    }
    if (hasNumber) {
      buffer.write("01234564789");
    }
    if (hasSymbol) {
      buffer.write("!@#%^&*()_+.");
    }
    String result = "";
    Random random = Random();
    for (int i = 0; i < length - customCharsLength; i++) {
      resultBuffer.write(buffer.toString()[random.nextInt(buffer.length)]);
    }
    String resultBufferString = resultBuffer.toString();
    int insertIndex =
        random.nextInt(resultBufferString.length - 1); // -1 !!!!!！！！！！！！！！！！
    String customResult =
        "${resultBufferString.substring(0, insertIndex)}$customChars${resultBufferString.substring(insertIndex)}";
    return customResult;
  }

  static String randomID() {
    final random = Random();
    String result = "";
    for (int i = 0; i < 9; i++) {
      result += random.nextInt(9).toString();
    }
    return result;
  }

  static void showNormalSnackBar(
      BuildContext context, String content, int second) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColor.black,
      content: Text(
        content,
        style: const TextStyle(color: AppColor.white, fontSize: 20),
      ),
      duration: Duration(seconds: second),
    ));
  }
}
