import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:group_button/group_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '/flutter_flow/flutter_flow_checkbox_group.dart';
import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Model/NhanSuDetailModel.dart';
export '../Model/NhanSuDetailModel.dart';

class NhanSuDetailWidget extends StatefulWidget {
  const NhanSuDetailWidget({Key? key}) : super(key: key);

  @override
  _NhanSuDetailWidgetState createState() => _NhanSuDetailWidgetState();
}

class _NhanSuDetailWidgetState extends State<NhanSuDetailWidget> {
  late NhanSuDetailModel _model;
  late Widget _pic;
  int _currentIndex = 0;
  bool? isCheckedOrder = false;
  bool? isCheckedNhanSu = false;
  bool? isCheckedMenu = false;
  bool? isCheckedThuChi = false;
  late SharedPreferences logindata;
  String? uid;
  String? _fullName;
  String? _email;
  String? _photoUrl;
  String? _phoneNumber;
  String? _roll;
  String? _quyen;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<void> _userDataController = StreamController<void>();

  @override
  void initState() {
    main();
    super.initState();
    _model = createModel(context, () => NhanSuDetailModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void _launchPhone(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunch(phoneLaunchUri.toString())) {
      await launch(phoneLaunchUri.toString());
    } else {
      print('Could not launch $phoneLaunchUri');
    }
  }
  void updateRoll(String _roll) async{
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/${uid}/");
      await ref.update({"roll": _roll});
  }

  void changeQuyenOrder() async {
    if (isCheckedOrder == true) {
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/${uid}/");
      await ref.update({"quyen": _quyen.toString() + ",Order"});
    } else {
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/${uid}/");
      await ref.update(
          {"quyen": _quyen!.replaceAll(",Order", '').trim().toString()});
    }
  }

  void changeQuyenMenu() async {
    if (isCheckedMenu == true) {
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/${uid}/");
      await ref.update({"quyen": _quyen.toString() + ",Menu"});
    } else {
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/${uid}/");
      await ref
          .update({"quyen": _quyen!.replaceAll(",Menu", '').trim().toString()});
    }
  }

  void changeQuyenNhanSu() async {
    if (isCheckedNhanSu == true) {
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/${uid}/");
      await ref.update({"quyen": _quyen.toString() + ",Nhân Sự"});
    } else {
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/${uid}/");
      await ref.update(
          {"quyen": _quyen!.replaceAll(",Nhân Sự", '').trim().toString()});
    }
  }

  void changeQuyenThuChi() async {
    if (isCheckedThuChi == true) {
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/${uid}/");
      await ref.update({"quyen": _quyen.toString() + ",Thu Chi"});
    } else {
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/${uid}/");
      await ref.update(
          {"quyen": _quyen!.replaceAll(",Thu Chi", '').trim().toString()});
    }
  }

  Future<void> main() async {
    logindata = await SharedPreferences.getInstance();
    uid = logindata.getString("id").toString();
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('users/${uid}');
    userRef.child("fullname").onValue.listen((event) {
      _fullName = event.snapshot.value.toString();
    });
    userRef.child("email").onValue.listen((event) {
      _email = event.snapshot.value.toString();
    });
    userRef.child("photoUrl").onValue.listen((event) {
      _photoUrl = event.snapshot.value.toString();
    });
    userRef.child("phoneNumber").onValue.listen((event) {
      _phoneNumber = event.snapshot.value.toString();
    });
    userRef.child("roll").onValue.listen((event) {
      _roll = event.snapshot.value.toString();
    });
    userRef.child("quyen").onValue.listen((event) {
      _quyen = event.snapshot.value.toString();
      _quyen.toString().contains("Order")
          ? isCheckedOrder = true
          : isCheckedOrder = false;
      _quyen.toString().contains("Menu")
          ? isCheckedMenu = true
          : isCheckedMenu = false;
      _quyen.toString().contains("Nhân Sự")
          ? isCheckedNhanSu = true
          : isCheckedNhanSu = false;
      _quyen.toString().contains("Thu Chi")
          ? isCheckedThuChi = true
          : isCheckedThuChi = false;

      _userDataController.add(null);
    });
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

    return StreamBuilder(
        stream: _userDataController.stream,
        builder: ((context, snapshot) {
          if (_fullName == null ||
              _email == null ||
              _photoUrl == null ||
              _phoneNumber == null ||
              _roll == null ||
              _quyen == null) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            return GestureDetector(
              onTap: () => _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
              child: Scaffold(
                key: scaffoldKey,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(
                      color: FlutterFlowTheme.of(context).primaryText),
                  automaticallyImplyLeading: true,
                  title: Text(
                    'Thông Tin Nhân Viên',
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
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.00, -1.00),
                          child: Container(
                            width: 120,
                            height: 120,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: _pic = _photoUrl != null
                                ? Image.network(
                                    _photoUrl.toString(),
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset('images/camera.png'),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Họ và tên : ',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: AlignmentDirectional(1, 0),
                                child: Text(
                                  _fullName.toString(),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 16,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Số điện thoại :',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(1, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 10, 0),
                                    child: Text(
                                      _phoneNumber.toString(),
                                      textAlign: TextAlign.end,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 16,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _launchPhone(_phoneNumber.toString());
                                },
                                child: Icon(
                                  Icons.call,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Email :',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(1, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 10, 0),
                                    child: Text(
                                      _email.toString(),
                                      textAlign: TextAlign.end,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 16,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: Text(
                                  'Bộ phận :',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: FlutterFlowRadioButton(
                                  options: ['Chủ Quán', 'Nhân Viên', 'Bảo Vệ']
                                      .toList(),
                                  onChanged: (val) => setState(() {
                                    updateRoll(val.toString());
                                  }),
                                  controller:
                                      _model.radioButtonValueController ??=
                                          FormFieldController<String>(
                                              _roll.toString()),
                                  optionHeight: 32,
                                  textStyle:
                                      FlutterFlowTheme.of(context).labelMedium,
                                  selectedTextStyle:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                  buttonPosition: RadioButtonPosition.left,
                                  direction: Axis.vertical,
                                  radioButtonColor:
                                      FlutterFlowTheme.of(context).primary,
                                  inactiveRadioButtonColor:
                                      FlutterFlowTheme.of(context)
                                          .secondaryText,
                                  toggleable: false,
                                  horizontalAlignment: WrapAlignment.start,
                                  verticalAlignment: WrapCrossAlignment.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: Text(
                                  'Quyền :',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 0, 0),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Checkbox(
                                          value: isCheckedOrder,
                                          activeColor: Colors.orangeAccent,
                                          onChanged: (newBool) {
                                            setState(() {
                                              isCheckedOrder = newBool;
                                              changeQuyenOrder();
                                            });
                                          },
                                        ),
                                        title: Text("Order",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      ListTile(
                                        leading: Checkbox(
                                          value: isCheckedNhanSu,
                                          activeColor: Colors.orangeAccent,
                                          onChanged: (newBool) {
                                            setState(() {
                                              isCheckedNhanSu = newBool;
                                              changeQuyenNhanSu();
                                            });
                                          },
                                        ),
                                        title: Text("Nhân Sự",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      ListTile(
                                        leading: Checkbox(
                                          value: isCheckedMenu,
                                          activeColor: Colors.orangeAccent,
                                          onChanged: (newBool) {
                                            setState(() {
                                              isCheckedMenu = newBool;
                                              changeQuyenMenu();
                                            });
                                          },
                                        ),
                                        title: Text("Menu",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      ListTile(
                                        leading: Checkbox(
                                          value: isCheckedThuChi,
                                          activeColor: Colors.orangeAccent,
                                          onChanged: (newBool) {
                                            setState(() {
                                              isCheckedThuChi = newBool;
                                              changeQuyenThuChi();
                                            });
                                          },
                                        ),
                                        title: Text("Thu Chi",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }));
  }
}
