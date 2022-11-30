import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class TextFieldWidget extends StatelessWidget {
  final String hint;
  bool isPassword;
  bool isPhone;
  bool isNumber;
  bool isTextArea;
  int? maxLength;
  bool? digitsOnly;
  TextEditingController? controller;
  TextFieldWidget(
      {Key? key,
      required this.hint,
      this.controller,
      required this.onChanged,
      required this.validator,
      this.isPassword = false,
      this.isTextArea = false,
      this.isPhone = false,
      this.maxLength,
      this.digitsOnly = false,
      this.isNumber = false})
      : super(key: key);

  String? Function(String?)? validator;

  String? Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        inputFormatters: digitsOnly! ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly] : null,
        controller: controller,
        obscureText: isPassword ? true : false,
        onChanged: onChanged,
        validator: validator,
        minLines: isTextArea ? 4 : 1,
        maxLines: isTextArea ? 4 : 1,
        maxLength: maxLength ?? null,
        // maxLengthEnforced: true,
        keyboardType: isPhone
            ? TextInputType.phone
            : isNumber
                ? TextInputType.number
                : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          fillColor: Colors.grey.withOpacity(.5),
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
