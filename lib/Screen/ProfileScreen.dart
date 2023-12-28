import 'dart:async';
import 'dart:io';

import 'package:app_coffee_manage/Global/Bottom.dart';
import 'package:app_coffee_manage/Global/navigation_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Model/ProfileModel.dart';
export '../Model/ProfileModel.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;
  late Widget _pic;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  String fullname = "";
  String email = "";
  String photolink = "";
  String phone = "";
  String gioiTinh = "";
  String ca = "";
  String chucvu = "";
  StreamController<void> _userDataController = StreamController<void>();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());

    _model.txtHotenController ??= TextEditingController();
    _model.txtHotenFocusNode ??= FocusNode();

    _model.txtSoDienThoaiController ??= TextEditingController();
    _model.txtSoDienThoaiFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    setState(() {
      main();
    });
  }

  _updateImgWidget() async {
    setState(() {
      _pic = CircularProgressIndicator();
    });
    Uint8List bytes =
        (await NetworkAssetBundle(Uri.parse(photolink)).load(photolink))
            .buffer
            .asUint8List();
    setState(() {
      _pic = Image.memory(bytes);
    });
    await FirebaseDatabase.instance
        .ref("users/${user?.uid}/")
        .update({'photoUrl': photolink.toString()});
    user?.updatePhotoURL(photolink.toString());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> main() async {
    User? user = FirebaseAuth.instance.currentUser;
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('users/${user!.uid}');
    userRef.child("fullname").onValue.listen((event) {
      fullname = event.snapshot.value.toString();
      _model.txtHotenController.text = event.snapshot.value.toString();
    });
    userRef.child("email").onValue.listen((event) {
      email = event.snapshot.value.toString();
    });
    userRef.child("photoUrl").onValue.listen((event) {
      photolink = event.snapshot.value.toString();
    });
    userRef.child("phoneNumber").onValue.listen((event) {
      phone = event.snapshot.value.toString();
      _model.txtSoDienThoaiController.text = event.snapshot.value.toString();
    });
    userRef.child("calamviec").onValue.listen((event) {
      ca = event.snapshot.value.toString();
    });
    userRef.child("roll").onValue.listen((event) {
      chucvu = event.snapshot.value.toString();
    });
    userRef.child("sex").onValue.listen((event) {
      gioiTinh = event.snapshot.value.toString();
      _userDataController.add(null);
    });
  }

  void updateInformation() async {
    if (_model.txtHotenController.text == "" ||
        _model.txtHotenController.text.isEmpty ||
        _model.txtSoDienThoaiController.text == "" ||
        _model.txtSoDienThoaiController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Vui lòng điền đầy đủ thông tin",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      FocusManager.instance.primaryFocus?.unfocus();

      await FirebaseDatabase.instance.ref("users/${user?.uid}/").update({
        'fullname': _model.txtHotenController.text.toString(),
        'phoneNumber': _model.txtSoDienThoaiController.text.toString(),
        'sex': _model.rdSexValue.toString()
      });

      user?.updateDisplayName(_model.txtHotenController.text.toString());
      Fluttertoast.showToast(
        msg: "Cập nhật thành công",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Use the picked image file
      uploadImageToFirebase(pickedFile.path);
    }
  }

  Future<void> uploadImageToFirebase(String filePath) async {
    File file = File(filePath);
    String fileName = user!.uid; // Use a unique name for the file

    try {
      firebase_storage.SettableMetadata metadata =
          firebase_storage.SettableMetadata(
        contentType: 'image/jpeg', // e.g., 'image/jpeg'
      );
      final snapshot = await firebase_storage.FirebaseStorage.instance
          .ref('images/${fileName}')
          .putFile(file, metadata);

      photolink = await firebase_storage.FirebaseStorage.instance
          .ref('images/${fileName}')
          .getDownloadURL();
      print('Image uploaded to Firebase Storage');
      _updateImgWidget();
    } on firebase_storage.FirebaseException catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
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
    return StreamBuilder<void>(
      stream: _userDataController.stream,
      builder: (context, snapshot) {
        if (fullname == "" ||
            email == "" ||
            photolink == "" ||
            phone == "" ||
            gioiTinh == "" ||
            ca == "") {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
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
                iconTheme: IconThemeData(
                    color: FlutterFlowTheme.of(context).primaryText),
                automaticallyImplyLeading: true,
                title: Text(
                  'Thông Tin Cá Nhân',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
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
                child: Align(
                  alignment: AlignmentDirectional(0.00, -1.00),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.00, -1.00),
                        child: Container(
                          width: 120,
                          child: Stack(
                            alignment: AlignmentDirectional(1, 1),
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
                                  child: _pic = photolink != null
                                      ? Image.network(
                                          photolink.toString(),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset('images/camera.png'),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(1.00, 1.00),
                                child: FlutterFlowIconButton(
                                  borderRadius: 20,
                                  borderWidth: 0,
                                  buttonSize: 40,
                                  fillColor: Color(0xFFFFFF00),
                                  hoverColor:
                                      FlutterFlowTheme.of(context).secondary,
                                  icon: Icon(
                                    Icons.edit,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    pickImage();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Text(
                          fullname.toString(),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                        child: Text(
                          email.toString(),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                              child: TextFormField(
                                controller: _model.txtHotenController,
                                focusNode: _model.txtHotenFocusNode,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Họ và tên',
                                  labelStyle:
                                      FlutterFlowTheme.of(context).labelMedium,
                                  hintStyle:
                                      FlutterFlowTheme.of(context).labelMedium,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium,
                                validator: _model.txtHotenControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                              child: TextFormField(
                                controller: _model.txtSoDienThoaiController,
                                focusNode: _model.txtSoDienThoaiFocusNode,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Số điện thoại',
                                  labelStyle:
                                      FlutterFlowTheme.of(context).labelMedium,
                                  hintStyle:
                                      FlutterFlowTheme.of(context).labelMedium,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium,
                                validator: _model
                                    .txtSoDienThoaiControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-1.00, 0.00),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 10, 0, 0),
                                child: FlutterFlowRadioButton(
                                  options: ['Nam', 'Nữ'].toList(),
                                  onChanged: (val) => setState(() {
                                    gioiTinh = val.toString();
                                  }),
                                  controller: _model.rdSexValueController ??=
                                      FormFieldController<String>(
                                          gioiTinh.toString()),
                                  optionHeight: 32,
                                  textStyle:
                                      FlutterFlowTheme.of(context).labelMedium,
                                  selectedTextStyle:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                  buttonPosition: RadioButtonPosition.left,
                                  direction: Axis.horizontal,
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
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20, 0, 0, 0),
                                    child: Text(
                                      'Ca làm việc : ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    ca.toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 16,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20, 0, 0, 0),
                                    child: Text(
                                      'Chức vụ : ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    chucvu.toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 16,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(20, 30, 20, 0),
                              child: FFButtonWidget(
                                onPressed: () {
                                  updateInformation();
                                },
                                text: 'Cập Nhật Thông Tin',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 50,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 24, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: Color(0xFFFF9999),
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
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavigationWidget(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                    navigateToSelectedPage(context, index);
                  });
                },
              ),
            ),
          );
        }
      },
    );
  }
}
