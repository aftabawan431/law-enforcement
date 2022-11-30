// ignore: file_names
import 'package:flutter/material.dart';

import '../../data/constants/colors.dart';

class ElevatedButtonWidget extends StatelessWidget {
  ElevatedButtonWidget({Key? key, required this.title, required this.onPressed, this.valueNotifier}) : super(key: key);
  final String title;
  ValueNotifier<bool>? valueNotifier;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    valueNotifier ??= ValueNotifier(false);
    return ValueListenableBuilder<bool>(
        valueListenable: valueNotifier!,
        builder: (_, value, __) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              onPressed: value ? () {} : onPressed,
              child: value
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ))
                  : Text(title),
            ),
          );
        });
  }
}
