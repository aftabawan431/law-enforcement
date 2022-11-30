import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ScaffoldHelper on BuildContext? {
  void show({required String message, Color backgroundColor = Colors.grey}) {
    if (this == null) {
      return;
    }

    // Fluttertoast.showToast(
    //   msg: message,
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.SNACKBAR,
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: Colors.redAccent,
    //   textColor: Colors.white,
    //   fontSize: 16.sp,
    // );

    ScaffoldMessenger.maybeOf(this!)
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp),
          ),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 2),
          // shape: const StadiumBorder(),
          // margin: const EdgeInsets.only(bottom: 100, left: 40, right: 40),
          // padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
          behavior: SnackBarBehavior.fixed,
        ),
      );
  }
}

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(alpha, (red * value).round(), (green * value).round(), (blue * value).round());
  }
}

extension GetGenderText on int {
  String getGender() {
    if (this == 0) {
      return 'Male';
    } else if (this == 1) {
      return 'Female';
    } else {
      return 'Prefer not to say';
    }
  }
}
