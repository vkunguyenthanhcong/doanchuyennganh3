import 'package:app_coffee_manage/Screen/AddMenuScreen.dart';
import 'package:app_coffee_manage/Screen/AddOrderScreen.dart';
import 'package:app_coffee_manage/Screen/HomeScreen.dart';
import 'package:app_coffee_manage/Screen/LoginScreen.dart';
import 'package:app_coffee_manage/Screen/MainScreen.dart';
import 'package:app_coffee_manage/Screen/MenuDetailScreen.dart';
import 'package:app_coffee_manage/Screen/OrderScreen.dart';
import 'package:app_coffee_manage/Screen/MenuScreen.dart';
import 'package:app_coffee_manage/Screen/ProfileScreen.dart';
import 'package:app_coffee_manage/Screen/SignUpScreen.dart';
import 'package:app_coffee_manage/Screen/SplashScreen.dart';
import 'package:app_coffee_manage/Screen/ThongTinQuanScreen.dart';
import 'package:flutter/material.dart';
void main() {
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
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          child: HomePageWidget(),
        ),
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
      },
    );
  }
}