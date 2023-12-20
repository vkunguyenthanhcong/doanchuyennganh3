import 'dart:io';

import 'package:app_coffee_manage/Screen/AddMenuScreen.dart';
import 'package:app_coffee_manage/Screen/AddOrderScreen.dart';
import 'package:app_coffee_manage/Screen/AddTableScreen.dart';
import 'package:app_coffee_manage/Screen/HoaDonScreen.dart';
import 'package:app_coffee_manage/Screen/HomeScreen.dart';
import 'package:app_coffee_manage/Screen/LoginScreen.dart';
import 'package:app_coffee_manage/Screen/MainScreen.dart';
import 'package:app_coffee_manage/Screen/MenuDetailScreen.dart';
import 'package:app_coffee_manage/Screen/NhanSuDetailScreen.dart';
import 'package:app_coffee_manage/Screen/NhanSuScreen.dart';
import 'package:app_coffee_manage/Screen/OrderScreen.dart';
import 'package:app_coffee_manage/Screen/MenuScreen.dart';
import 'package:app_coffee_manage/Screen/ProfileScreen.dart';
import 'package:app_coffee_manage/Screen/SignUpScreen.dart';
import 'package:app_coffee_manage/Screen/SplashScreen.dart';
import 'package:app_coffee_manage/Screen/ThongTinQuanScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
Future<void> main() async {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Coffee App ManageS",
      theme: ThemeData(
      ),
      routes: <String, WidgetBuilder>{
        '/': (context) => SplashScreen(
            child:HomePageWidget()
        ),
        '/start' : (context) => HomePageWidget(),
        '/home': (context) => MainWidget(),
        '/login': (context) => LoginWidget(),
        '/signup' : (context) => SignUpWidget(),
        '/thongtincanhan' : (context) => ProfileWidget(),
        '/menu': (context) => MenuWidget(),
        '/menudetail' : (context) => MenuDetailWidget(),
        '/addmenu' : (context) => AddMenuWidget(),
        '/thongtinquan' : (context) => ThongTinQuanWidget(),
        '/order' : (context) => OrderWidget(),
        '/addorder' : (context) => AddOrderWidget(),
        '/hoadon' : (context) => HoaDonWidget(),
        '/addTable' : (context) => AddBanWidget(),
        '/nhansu' : (context) => NhanSuWidget(),
        '/nhansudetail' : (context) => NhanSuDetailWidget()
      },
    );
  }
}