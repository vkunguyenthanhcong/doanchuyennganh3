import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/Order.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Model/OrderModel.dart';
export '../Model/OrderModel.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget>
    with TickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;
  late OrderModel _model;
  List<Order> orders = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late SharedPreferences bandata;
  late SharedPreferences logindata;
  String? _roll;

  
  @override
  void initState() {
    load();
    super.initState();
    _model = createModel(context, () => OrderModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    
  }

  void load() async{
    logindata = await SharedPreferences.getInstance();
    _roll = logindata.getString('roll');
  }
  

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_roll == "Chủ Quán") {
                                Navigator.pushNamed(context, '/addTable');
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Bạn chưa được cấp quyền",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
            
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 8,
          child: Icon(
            Icons.add,
            color: FlutterFlowTheme.of(context).info,
            size: 24,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Text(
            'Order',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment(0, 0),
                      child: TabBar(
                        labelColor: FlutterFlowTheme.of(context).primaryText,
                        unselectedLabelColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        labelStyle: FlutterFlowTheme.of(context).titleMedium,
                        unselectedLabelStyle: TextStyle(),
                        indicatorColor: FlutterFlowTheme.of(context).primary,
                        padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                        tabs: [
                          Tab(
                            text: 'Hoá Đơn',
                          ),
                          Tab(
                            text: 'Khu Vực',
                          ),
                        ],
                        controller: _model.tabBarController,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _model.tabBarController,
                        children: [
                          StreamBuilder(
                              stream: FirebaseDatabase.instance.reference().child("ban").orderByChild("trangthai").equalTo("Busy").onValue.asBroadcastStream(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData &&  snapshot.data!.snapshot.value != null) {
                                  Map map = snapshot.data.snapshot.value;
                                  orders.clear();
                                  map.forEach((dynamic, v) => orders
                                      .add(new Order(v["ten"], v["tongtien"], v["trangthai"])));
                                  orders.sort((a, b) => _compareNumericOrder(a.ten, b.ten));
                                  return GridView.builder(
                                    padding: EdgeInsets.zero,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1,
                                    ),
                                    itemCount: orders.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () async {
                                          bandata = await SharedPreferences.getInstance();
                                          bandata.setString('tenban', orders[index].ten);
                                          Navigator.pushNamed(context, '/hoadon');},
                                        child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Card(
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              color:
                                                  orders[index].tinhtrang == "Free" ? Color(0xFF66ff99)  : Color(0xFFff8080),
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.00, 0.00),
                                                child: Text(
                                                  orders[index].tongtien.toString() +
                                                      " VNĐ",
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium,
                                                ),
                                              ),
                                            ),
                                            ),
                                          Text(
                                            'Hoá Đơn - ' + orders[index].ten,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                      );
                                    },
                                  );
                                } 
                                else {
                                  return Center(child: Text("Không Có Hoá Đơn"),);
                                }
                              }),
                          StreamBuilder(
                              stream: FirebaseDatabase.instance.reference().child("ban").onValue.asBroadcastStream(),
                              
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData  &&  snapshot.data!.snapshot.value != null) {
                                  Map map = snapshot.data.snapshot.value;
                                  orders.clear();
                                  map.forEach((dynamic, v) => orders
                                      .add(new Order(v["ten"], v["tongtien"], v["trangthai"])));
                                  orders.sort((a, b) => _compareNumericOrder(a.ten, b.ten));
                                  return GridView.builder(
                                    padding: EdgeInsets.zero,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1,
                                    ),
                                    itemCount: orders.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () async {
                                          bandata = await SharedPreferences.getInstance();
                                          bandata.setString('tenban', orders[index].ten);
                                          Navigator.pushNamed(context, '/addorder');},
                                        child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Card(
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              color:
                                                  orders[index].tinhtrang == "Free" ? Color(0xFF66ff99)  : Color(0xFFff8080),
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.00, 0.00),
                                                child: Text(
                                                  orders[index].tongtien.toString() +
                                                      " VNĐ",
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium,
                                                ),
                                              ),
                                            ),
                                            ),
                                          Text(
                                            orders[index].ten,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                      );
                                    },
                                  );
                                } else {
                                  return Center(child: Text("Không Có Khu Vực. Vui Lòng Cập Nhật Lại."),);
                                }
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int _compareNumericOrder(String a, String b) {
  // Extract numeric portions and convert to integers
  int numericA = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  int numericB = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  return numericA.compareTo(numericB);
}