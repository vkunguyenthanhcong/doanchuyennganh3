import 'dart:async';
import 'dart:ui';
import 'package:app_coffee_manage/Model/Menu.dart';
import 'package:app_coffee_manage/Model/Order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Global/custom_dialog.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Model/AddOrderModel.dart';
export '../Model/AddOrderModel.dart';

class AddOrderWidget extends StatefulWidget {
  const AddOrderWidget({Key? key}) : super(key: key);

  @override
  _AddOrderWidgetState createState() => _AddOrderWidgetState();
}

class _AddOrderWidgetState extends State<AddOrderWidget> {
  late AddOrderModel _model;
  late SharedPreferences bandata;
  StreamController<void> _userDataController = StreamController<void>();
  StreamController<void> _checkTongTien = StreamController<void>();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _ban = "";
  List<Menu> menus = [];
  String selectedValue = '';
  String find = "";
  String _tongTien = "";
  String _soLuong = "";
  String? _fullName;
  String? _thuNgan;
  String? _maHoaDon;
  String? _gioVao;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddOrderModel());

    _model.txtFindController ??= TextEditingController();
    _model.txtFindFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    loadTenBan();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  final auth = FirebaseAuth.instance;
  final Billref = FirebaseDatabase.instance.ref();
  void checkBill() async {
    DateTime now = DateTime.now();
    final snapshot =
        await Billref.child('ban/${removeDiacritics(_ban.toLowerCase())}/')
            .get();
    _thuNgan = snapshot.child('thungan').value.toString();
    _maHoaDon = snapshot.child('mahoadon').value.toString();
    _gioVao = snapshot.child('giovao').value.toString();
    if (_thuNgan == "No" && _maHoaDon == "No" && _gioVao == "No") {
      Billref.child('ban/${removeDiacritics(_ban.toLowerCase())}/').update({
        "thungan": user!.displayName.toString(),
        "mahoadon": removeDiacritics(_ban.toLowerCase()) +
            DateFormat('yyyyMMddHHmm').format(now),
        "giovao": DateFormat('HH:mm').format(now)
      });
    }
  }

  void addMenu(String id, int gia, String ten) async {
    checkBill();
    _fullName = user!.displayName.toString();
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('yyyy-MM-dd-HH:mm:ssss').format(now);

    DatabaseReference ref = FirebaseDatabase.instance.ref(
        "ban/${removeDiacritics(_ban.toLowerCase())}/order/${id + formattedDateTime}/");
    await ref.set({
      "gia": gia,
      "ten": ten,
      "id": id + formattedDateTime,
      "soluong": 1,
    });
    DatabaseReference _ref = FirebaseDatabase.instance
        .ref("ban/${removeDiacritics(_ban.toLowerCase())}/");
    await _ref.update({
      "tongtien": int.parse(_tongTien.toString()) + gia,
      "soluong": int.parse(_soLuong.toString()) + 1,
      "trangthai": "Busy"
    });
  }

  void deleteBill() async {
    Navigator.pushNamed(context, '/order');
    FirebaseDatabase.instance
        .ref('ban/${removeDiacritics(_ban.toLowerCase())}/order')
        .remove();
    DatabaseReference _ref = FirebaseDatabase.instance
        .ref("ban/${removeDiacritics(_ban.toLowerCase())}/");
    await _ref.update({"tongtien": 0, "soluong": 0, "trangthai": "Free", "giovao" : "No", "thungan" : "No", "mahoadon" : "No"});
    _tongTien = "0";
    _soLuong = "0";
  }

  String removeDiacritics(String input) {
    return input
        .replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
        .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
        .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
        .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
        .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
        .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
        .replaceAll(RegExp(r'[đ]'), 'd')
        .replaceAll(' ', '');
  }

  void loadTenBan() async {
    bandata = await SharedPreferences.getInstance();
    _ban = bandata.getString("tenban").toString();
    _userDataController.add(null);
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
        builder: (context, snapshot) {
          if (_ban == "") {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            DatabaseReference ref = FirebaseDatabase.instance
                .reference()
                .child('ban/${removeDiacritics(_ban.toLowerCase())}/');
            ref.child("tongtien").onValue.listen((event) {
              _tongTien = event.snapshot.value.toString();
            });
            ref.child("soluong").onValue.listen((event) {
              _soLuong = event.snapshot.value.toString();
              _checkTongTien.add(null);
            });
            return StreamBuilder(
              stream: _checkTongTien.stream,
              builder: ((context, snapshot) {
                if (_tongTien == "" || _soLuong == "") {
                  return Center(
                    child: Container(child: CircularProgressIndicator()),
                  );
                } else {
                  return GestureDetector(
                    onTap: () => _model.unfocusNode.canRequestFocus
                        ? FocusScope.of(context)
                            .requestFocus(_model.unfocusNode)
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
                          _ban.toString(),
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
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
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(8, 0, 8, 20),
                                child: TextFormField(
                                  controller: _model.txtFindController,
                                  focusNode: _model.txtFindFocusNode,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Tìm kiếm',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium,
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.find_replace_sharp,
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        _model.txtFindController.text = "";
                                        setState(() {
                                          find = "";
                                        });
                                      },
                                      child: Icon(
                                        Icons.cancel,
                                      ),
                                    ),
                                  ),
                                  onChanged: (String value) {
                                    setState(() {});
                                  },
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                  validator: _model.txtFindControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20, 0, 0, 0),
                                    child: FFButtonWidget(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomConfirmDialog(
                                                  title: "Xoá hoá đơn",
                                                  content:
                                                      "Bạn có chắc chắn muốn xoá dữ liệu này?",
                                                  onConfirm: () {
                                                    Navigator.pop(context);
                                                    deleteBill();
                                                  },
                                                  onCancel: () {
                                                    Navigator.pop(context);
                                                  });
                                            });
                                      },
                                      text: '',
                                      icon: Icon(
                                        Icons.restore_from_trash,
                                        size: 30,
                                      ),
                                      options: FFButtonOptions(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                15, 10, 7, 10),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color: Colors.white,
                                            ),
                                        elevation: 3,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
                                      child: InkWell(
                                        onTap: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (_) => LoadMenu());
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.7,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(10, 0, 0, 0),
                                                child: Text(
                                                  _soLuong.toString(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(10, 0, 0, 0),
                                                child: Text(
                                                  '|',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(10, 0, 0, 0),
                                                child: Text(
                                                  'Tổng tiền : ',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          1.00, 0.00),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                10, 0, 0, 0),
                                                    child: Text(
                                                      _tongTien.toString(),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Readex Pro',
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          1.00, 0.00),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                5, 0, 10, 0),
                                                    child: Text(
                                                      'đ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Readex Pro',
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              //                 StreamBuilder(
                              //   stream: FirebaseDatabase.instance.reference().child('thongtinquan/loai').onValue.asBroadcastStream(),
                              //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                              //     if (!snapshot.hasData) {
                              //       return CircularProgressIndicator();
                              //     }
                              //     Map<dynamic, dynamic> values = snapshot.data.snapshot.value;

                              //     // Extract data and create a list of dropdown items
                              //     List<DropdownMenuItem<String>> dropdownItems = [];

                              //     if (values != null) {
                              //       values.forEach((key, value) {
                              //         String itemName = value['ten']; // Replace with your field name
                              //         dropdownItems.add(DropdownMenuItem<String>(
                              //           value: itemName,
                              //           child: Text(itemName),
                              //         ));
                              //       });
                              //     }

                              //     // Display the dropdown with the populated items
                              //     return DropdownButton<String>(
                              //       items: dropdownItems,
                              //       onChanged: (String? newValue) {
                              //         // Handle the selected value
                              //         setState(() {
                              //               selectedValue = newValue ?? '';
                              //             });
                              //       },

                              //       hint: Text(selectedValue.toString() == "" ? "Chọn Menu" : selectedValue.toString()),
                              //     );
                              //   },
                              // ),

                              StreamBuilder(
                                  stream: FirebaseDatabase.instance
                                      .reference()
                                      .child("menu")
                                      .onValue
                                      .asBroadcastStream(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.snapshot.value != null) {
                                      Map map = snapshot.data.snapshot.value;
                                      menus.clear();
                                      map.forEach((dynamic, v) => {
                                            if ((v["ten"]
                                                    .toString()
                                                    .toLowerCase())
                                                .contains(_model
                                                    .txtFindController.text
                                                    .toString()
                                                    .toLowerCase()))
                                              {
                                                menus.add(new Menu(v["ten"],
                                                    v["gia"], v["photoUrl"]))
                                              }
                                          });
                                      return Expanded(
                                        child: SizedBox(
                                          height: 200.0,
                                          child: new GridView.builder(
                                            clipBehavior: Clip.none,
                                            physics: ScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 5,
                                              crossAxisSpacing: 1.0,
                                              mainAxisSpacing: 1.0,
                                            ),
                                            itemCount: menus.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final tenmon =
                                                  menus[index].ten.toString();
                                              if (_model.txtFindController.text
                                                  .toString()
                                                  .isEmpty) {
                                                return InkWell(
                                                    onTap: () {
                                                      addMenu(
                                                          removeDiacritics(menus[
                                                                  index]
                                                              .ten
                                                              .toString()
                                                              .toLowerCase()),
                                                          int.parse(menus[index]
                                                              .gia
                                                              .toString()),
                                                          menus[index]
                                                              .ten
                                                              .toString());
                                                    },
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                              width: 300,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                image:
                                                                    DecorationImage(
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .low,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: Image
                                                                      .network(
                                                                    menus[index]
                                                                        .photoUrl
                                                                        .toString(),
                                                                  ).image,
                                                                ),
                                                              ),
                                                              child: ClipRRect(
                                                                child:
                                                                    BackdropFilter(
                                                                  filter: ImageFilter
                                                                      .blur(
                                                                          sigmaX:
                                                                              3,
                                                                          sigmaY:
                                                                              3),
                                                                  child: Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            1.00,
                                                                            -1.00),
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              50,
                                                                          height:
                                                                              20,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                          ),
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                AlignmentDirectional(0.00, 0.00),
                                                                            child:
                                                                                Text(
                                                                              formatNumber(int.parse(menus[index].gia.toString())),
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Readex Pro',
                                                                                    color: Colors.white,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.00,
                                                                              1.00),
                                                                          child:
                                                                              Text(
                                                                            menus[index].ten.toString(),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Readex Pro',
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    ));
                                              } else if (tenmon
                                                  .toLowerCase()
                                                  .contains(_model
                                                      .txtFindController.text
                                                      .toLowerCase())) {
                                                return InkWell(
                                                    onTap: () {
                                                      addMenu(
                                                          removeDiacritics(menus[
                                                                  index]
                                                              .ten
                                                              .toString()
                                                              .toLowerCase()),
                                                          int.parse(menus[index]
                                                              .gia
                                                              .toString()),
                                                          menus[index]
                                                              .ten
                                                              .toString());
                                                    },
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                              width: 100,
                                                              height: 100,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                image:
                                                                    DecorationImage(
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .low,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: Image
                                                                      .network(
                                                                    menus[index]
                                                                        .photoUrl
                                                                        .toString(),
                                                                  ).image,
                                                                ),
                                                              ),
                                                              child: ClipRRect(
                                                                child:
                                                                    BackdropFilter(
                                                                  filter: ImageFilter
                                                                      .blur(
                                                                          sigmaX:
                                                                              3,
                                                                          sigmaY:
                                                                              3),
                                                                  child: Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            1.00,
                                                                            -1.00),
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              50,
                                                                          height:
                                                                              20,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                          ),
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                AlignmentDirectional(0.00, 0.00),
                                                                            child:
                                                                                Text(
                                                                              formatNumber(int.parse(menus[index].gia.toString())),
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Readex Pro',
                                                                                    color: Colors.white,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.00,
                                                                              1.00),
                                                                          child:
                                                                              Text(
                                                                            menus[index].ten.toString(),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Readex Pro',
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    ));
                                              } else {
                                                return Visibility(
                                                  visible: false,
                                                  child: SizedBox(
                                                    height: 500.0,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: Text("Không Có Dữ Liệu"),
                                      );
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }),
            );
          }
        });
  }
}

String formatNumber(int number) {
  if (number >= 1000 && number < 10000) {
    return '${(number / 1000).toStringAsFixed(0)}k';
  } else if (number >= 10000) {
    return '${(number / 1000).toStringAsFixed(0)}k';
  } else {
    return number.toString();
  }
}

class LoadMenu extends StatelessWidget {
  late SharedPreferences bandata;
  String? _ban;
  String removeDiacritics(String input) {
    return input
        .replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
        .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
        .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
        .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
        .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
        .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
        .replaceAll(RegExp(r'[đ]'), 'd')
        .replaceAll(' ', '');
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
        query: FirebaseDatabase.instance.ref('ban/ban1/order'),
        itemBuilder: ((context, snapshot, animation, index) {
          return Container(
            child: Text(snapshot.child('ten').value.toString()),
          );
        }));
  }
}
