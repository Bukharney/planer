import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'theme.dart';

class NotifiedView extends StatelessWidget {
  const NotifiedView({super.key, required this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          label.toString().split("|")[0],
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Text(
          label.toString().split("|")[1],
          style: titleStyle,
        ),
      ),
    );
  }
}
