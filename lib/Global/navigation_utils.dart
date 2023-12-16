// navigation_utils.dart

import 'package:app_coffee_manage/Global/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> navigateToSelectedPage(BuildContext context, int index) async {
  switch (index) {
    case 0:
      Navigator.pushNamed(context, '/home');
      break;
    case 1:
      break;
    case 2:
      Navigator.pushNamed(context, '/order');
      break;
    case 3:
      showDialog(context: context, builder: (BuildContext context){
        return CustomConfirmDialog(title:"Đăng Xuất", content: "Xác nhận đăng xuất", onConfirm:() async {await FirebaseAuth.instance.signOut();Navigator.pushNamed(context, "/");}, onCancel: (){Navigator.of(context).pop();});
      });
      break;
  }
}
