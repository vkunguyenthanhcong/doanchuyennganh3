// navigation_utils.dart

import 'package:app_coffee_manage/Global/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> navigateToSelectedPage(BuildContext context, int index) async {
  late SharedPreferences logindata;
  String? _roll;
  logindata = await SharedPreferences.getInstance();
  _roll = logindata.getString('roll');
  switch (index) {
    case 0:
      Navigator.pushNamed(context, '/home');
      break;
    case 1:
      break;
    case 2:
      if (_roll == "User") {
        Fluttertoast.showToast(
          msg: "Bạn chưa được cấp quyền",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Navigator.pushNamed(context, '/order');
        break;
      }
    case 3:
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomConfirmDialog(
                title: "Đăng Xuất",
                content: "Xác nhận đăng xuất",
                onConfirm: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "/start");
                },
                onCancel: () {
                  Navigator.of(context).pop();
                });
          });
      break;
  }
}
