import 'package:app_coffee_manage/Global/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Model/ThongTinQuanModel.dart';
export '../Model/ThongTinQuanModel.dart';

class ThongTinQuanWidget extends StatefulWidget {
  const ThongTinQuanWidget({Key? key}) : super(key: key);

  @override
  _ThongTinQuanWidgetState createState() => _ThongTinQuanWidgetState();
}

class _ThongTinQuanWidgetState extends State<ThongTinQuanWidget> {
  late ThongTinQuanModel _model;
  int? soban;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ThongTinQuanModel());

    _model.txtTenController ??= TextEditingController();
    _model.txtTenFocusNode ??= FocusNode();

    _model.txtSoLuongBanController ??= TextEditingController();
    _model.txtSoLuongBanFocusNode ??= FocusNode();

    _model.txtTenLoaiController ??= TextEditingController();
    _model.txtTenLoaiFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    loadData();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('thongtinquan/loai');

  void loadData() {
    DatabaseReference ref = FirebaseDatabase.instance.ref('thongtinquan/');
    ref.child('tenquan').onValue.listen((DatabaseEvent event) {
      _model.txtTenController.text = event.snapshot.value.toString();
    });
    ref.child('soluong').onValue.listen((DatabaseEvent event) {
      _model.txtSoLuongBanController.text = event.snapshot.value.toString();
    });
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

  void uploadData() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    soban = int.tryParse(_model.txtSoLuongBanController.text.toString());
    DatabaseReference quanref = FirebaseDatabase.instance.ref("thongtinquan/");
    await quanref.update({
      "tenquan": _model.txtTenController.text.toString(),
      "soluong": _model.txtSoLuongBanController.text.toString(),
    });
    for (int i = 1; i <= soban!; i++) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("ban/ban${i.toString()}");
      await ref.set({
        "ten": "Bàn " + i.toString(),
        "id": "ban" + i.toString(),
        "trangthai": "Free",
        "soluong": 0,
        "tongtien": 0,
      });
    }
    Navigator.pop(context);
    Fluttertoast.showToast(
      msg: "Cập nhật thành công",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Align(
            alignment: AlignmentDirectional(0.00, -1.00),
            child: Text(
              'Thông Tin Quán',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Outfit',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional(-1.00, -1.00),
                  child: Text(
                    'Tên Quán :',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.00, -1.00),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: TextFormField(
                      controller: _model.txtTenController,
                      focusNode: _model.txtTenFocusNode,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintStyle: FlutterFlowTheme.of(context).labelMedium,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      validator:
                          _model.txtTenControllerValidator.asValidator(context),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.00, -1.00),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      'Số Lượng Bàn :',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.00, -1.00),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: TextFormField(
                      controller: _model.txtSoLuongBanController,
                      focusNode: _model.txtSoLuongBanFocusNode,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintStyle: FlutterFlowTheme.of(context).labelMedium,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      validator: _model.txtSoLuongBanControllerValidator
                          .asValidator(context),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1, -1),
                        child: Text(
                          'Loại :',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await showDialog<void>(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: Stack(
                                      clipBehavior: Clip.none,
                                      children: <Widget>[
                                        Positioned(
                                          right: -40,
                                          top: -40,
                                          child: InkResponse(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const CircleAvatar(
                                              backgroundColor: Colors.red,
                                              child: Icon(Icons.close),
                                            ),
                                          ),
                                        ),
                                        Form(
                                          child: Column(
                                            key: _formKey,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    -1.00, -1.00),
                                                child: Text(
                                                  'Loại :',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    -1.00, -1.00),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 10, 0, 0),
                                                  child: TextFormField(
                                                    controller: _model
                                                        .txtTenLoaiController,
                                                    focusNode: _model
                                                        .txtTenLoaiFocusNode,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium,
                                                    validator: _model
                                                        .txtTenControllerValidator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: ElevatedButton(
                                                  child: const Text('Thêm'),
                                                  onPressed: () async {
                                                    if (_model
                                                        .txtTenLoaiController
                                                        .text
                                                        .isEmpty) {
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Vui lòng điền đầy đủ thông tin.",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                    } else {
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                      DatabaseReference ref =
                                                          FirebaseDatabase
                                                              .instance
                                                              .ref(
                                                                  "thongtinquan/loai/${removeDiacritics(_model.txtTenLoaiController.text.toString().toLowerCase()).toString()}");
                                                      await ref.set({
                                                        "id": removeDiacritics(
                                                            _model
                                                                .txtTenLoaiController
                                                                .text
                                                                .toString()
                                                                .toLowerCase()),
                                                        "ten": _model
                                                            .txtTenLoaiController
                                                            .text
                                                            .toString(),
                                                      });
                                                      _model.txtTenLoaiController.text = "";
                                                    }
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                        },
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                          child: Icon(
                            Icons.add_box,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: new FirebaseAnimatedList(
                        query: ref,
                        defaultChild: Text("Loading..."),
                        itemBuilder: ((context, snapshot, animation, index) {
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot.child('ten').value.toString(),
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomConfirmDialog(
                                              title: "Xoá",
                                              content:
                                                  "Bạn có chắc chắn muốn xoá dữ liệu này?",
                                              onConfirm: () {
                                                Navigator.pop(context);
                                                FirebaseDatabase.instance
                                                    .ref(
                                                        'thongtinquan/loai/${snapshot.child('id').value.toString()}')
                                                    .remove();
                                              },
                                              onCancel: () {
                                                Navigator.pop(context);
                                              });
                                        });
                                  },
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }))),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 50),
                  child: FFButtonWidget(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomConfirmDialog(
                                title: "Cập Nhật Thông Tin",
                                content:
                                    "Bạn có chắc chắn muốn cập nhật thông tin?",
                                onConfirm: () {
                                  Navigator.pop(context);
                                  uploadData();
                                },
                                onCancel: () {
                                  Navigator.pop(context);
                                });
                          });
                    },
                    text: 'Cập Nhật',
                    options: FFButtonOptions(
                      width: MediaQuery.sizeOf(context).width * 0.75,
                      height: 40,
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                      elevation: 3,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
