import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToastOrSnackBar(BuildContext context, String msg) {
  if (Platform.isAndroid) {
    Fluttertoast.showToast(msg: msg);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        width: 400,
      ),
    );
  }
}
