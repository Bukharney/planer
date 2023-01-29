import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  });

  final TextEditingController? controller;
  final String hint;
  final String title;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[200] : Colors.grey[800],
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: widget == null
                          ? hintStyle
                          : hintStyle.copyWith(
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 20),
                    ),
                  ),
                ),
                widget ?? const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
