import 'dart:async';
import 'dart:io';

import 'package:app_coffee_manage/Global/Bottom.dart';
import 'package:app_coffee_manage/Global/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Global/navigation_utils.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Model/MenuDetailModel.dart';
export '../Model/MenuDetailModel.dart';

class MenuDetailWidget extends StatefulWidget {
  const MenuDetailWidget({Key? key}) : super(key: key);

  @override
  _MenuDetailWidgetState createState() => _MenuDetailWidgetState();
}

class _MenuDetailWidgetState extends State<MenuDetailWidget> {
  late MenuDetailModel _model;
  late Widget _pic;
  int _currentIndex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> list = <String>['Coffee', 'Trà', 'Trà Sữa', 'Nước Ngọt'];
  String dropdownValue = "";
  String id = "";
  String _tenmon = "";
  String _gia = "";
  String _loai = "";
  String photoLink = "";
  late SharedPreferences menudata;
  
  StreamController<void> _userDataController = StreamController<void>();
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuDetailModel());

    _model.txtTenMonController ??= TextEditingController();
    _model.txtTenMonFocusNode ??= FocusNode();

    _model.txtLoaiController1 ??= TextEditingController();
    _model.txtLoaiFocusNode1 ??= FocusNode();

    _model.txtLoaiController2 ??= TextEditingController();
    _model.txtLoaiFocusNode2 ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    loadID();
  }
  _updateImgWidget() async {
    setState(() {
      _pic = CircularProgressIndicator();
    });
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(photoLink)).load(photoLink))
        .buffer
        .asUint8List();
    setState(() {
      _pic = Image.memory(bytes);
    });
    await FirebaseDatabase.instance.ref("menu/${id}/").update({'photoUrl' : photoLink.toString()});
  }
  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }
  void loadID() async {
    menudata = await SharedPreferences.getInstance();
    
    id = menudata.getString('id').toString();
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('menu/${id}');
    userRef.child("ten").onValue.listen((event) {
      _tenmon = event.snapshot.value.toString();
      _model.txtTenMonController.text = _tenmon.toString();
      
    });
    userRef.child("gia").onValue.listen((event) {
      _gia = event.snapshot.value.toString();
      _model.txtLoaiController1.text = _gia.toString();
    });
    userRef.child("loai").onValue.listen((event) {
      dropdownValue = event.snapshot.value.toString();
    });
    userRef.child("photoUrl").onValue.listen((event) {
        photoLink = event.snapshot.value.toString(); 
        _userDataController.add(null);
    });
          
  }
  void deleteData() {
    Navigator.pushNamed(context, '/menu');
    FirebaseDatabase.instance.reference().child('menu/${id}').remove();
  }
  void updateData() async {
    if (_model.txtTenMonController.text == "" ||
        _model.txtTenMonController.text.isEmpty ||
        _model.txtLoaiController1.text == "" ||
        _model.txtLoaiController1.text.isEmpty) {
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
        User? user = FirebaseAuth.instance.currentUser;
        _tenmon = _model.txtTenMonController.text.toString();
        _gia = _model.txtLoaiController1.text.toString();
        await FirebaseDatabase.instance.ref("menu/${id}/").update({'ten' : _tenmon, 'gia' : int.parse(_gia), 'loai' : dropdownValue.toString()});
        
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
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    // Use the picked image file
    uploadImageToFirebase(pickedFile.path);
  }
  }
  Future<void> uploadImageToFirebase(String filePath) async {
  File file = File(filePath);
  String fileName = id; // Use a unique name for the file

  try {
    firebase_storage.SettableMetadata metadata = firebase_storage.SettableMetadata(
      contentType: 'image/jpeg', // e.g., 'image/jpeg'
    );
    final snapshot = await firebase_storage.FirebaseStorage.instance
        .ref('menu/${fileName}')
        .putFile(file, metadata);
    
    photoLink = await firebase_storage.FirebaseStorage.instance.ref('menu/${fileName}').getDownloadURL();
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
      builder: ((context, snapshot) {
        if (_tenmon == "" || _gia == "" || dropdownValue == "" || photoLink == "" || photoLink == null){
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }else{
         
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
          
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushNamed(context, '/menu'),
          ),
          automaticallyImplyLeading: true,
          title: Text(
            'Thông Tin Chi Tiết',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional(0.00, 0.00),
                child: Container(
                  width: 120,
                  child: Stack(
                    alignment: AlignmentDirectional(1, 1),
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: _pic = photoLink != null
                              ? Image.network(
                                  photoLink.toString() != "null" ? photoLink.toString() : "https://www.shutterstock.com/image-vector/dotted-spiral-vortex-royaltyfree-images-600w-2227567913.jpg",
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
                          icon: Icon(
                            Icons.edit,
                            color: FlutterFlowTheme.of(context).primaryText,
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
              Align(
                alignment: AlignmentDirectional(-1.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tên món',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            controller: _model.txtTenMonController,
                            focusNode: _model.txtTenMonFocusNode,
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelStyle:
                                  FlutterFlowTheme.of(context).labelMedium,
                              hintStyle:
                                  FlutterFlowTheme.of(context).labelMedium,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding:
                                  EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium,
                            validator: _model.txtTenMonControllerValidator
                                .asValidator(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-1.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Giá',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            controller: _model.txtLoaiController1,
                            focusNode: _model.txtLoaiFocusNode1,
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelStyle:
                                  FlutterFlowTheme.of(context).labelMedium,
                              hintStyle:
                                  FlutterFlowTheme.of(context).labelMedium,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding:
                                  EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium,
                            validator: _model.txtLoaiController1Validator
                                .asValidator(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-1.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 5, 20, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Loại',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 2.0,
        ),
      ),
                  child: StreamBuilder(
                stream: FirebaseDatabase.instance.reference().child('thongtinquan/loai').onValue.asBroadcastStream(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  Map<dynamic, dynamic> values = snapshot.data.snapshot.value;

                  // Extract data and create a list of dropdown items
                  List<DropdownMenuItem<String>> dropdownItems = [];

                  if (values != null) {
                    values.forEach((key, value) {
                      String itemName = value['ten']; // Replace with your field name
                      dropdownItems.add(DropdownMenuItem<String>(
                        value: itemName,
                        child: Text(itemName, style: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
),
                      ));
                    });
                  }

                  // Display the dropdown with the populated items
                  return DropdownButton<String>(
                    items: dropdownItems,
                    onChanged: (String? newValue) {
                      // Handle the selected value
                      setState(() {
                            dropdownValue = newValue ?? '';
                          });
                    },
                    hint: Text(dropdownValue.toString() == "" ? "Chọn Menu" : dropdownValue.toString(), style: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
          ),),
                  );
                },
              ),
                ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FFButtonWidget(
                      onPressed: () {
                        showDialog(context: context, builder: (BuildContext context){
                          return CustomConfirmDialog(title:"Xoá", content: "Bạn có chắc chắn muốn xoá sản phẩm này?", onConfirm:() {deleteData();}, onCancel: (){Navigator.of(context).pop();});
                        });
                      },
                      text: 'Xoá',
                      options: FFButtonOptions(
                        height: 40,
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: Color(0xFFFF4D4D),
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
                    FFButtonWidget(
                      onPressed: () {
                        updateData();
                      },
                      text: 'Cập Nhật',
                      options: FFButtonOptions(
                        height: 40,
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: Color(0xFF70DB70),
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
                  ],
                ),
              ),
            ],
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
      }));
  }
}
