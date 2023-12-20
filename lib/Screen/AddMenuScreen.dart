import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Model/AddMenuModel.dart';
export '../Model/AddMenuModel.dart';

class AddMenuWidget extends StatefulWidget {
  const AddMenuWidget({Key? key}) : super(key: key);

  @override
  _AddMenuWidgetState createState() => _AddMenuWidgetState();
}

class _AddMenuWidgetState extends State<AddMenuWidget> {
  late AddMenuModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  File? _selectedImage;
  List<String> list = <String>['Coffee', 'Trà', 'Trà Sữa', 'Nước Ngọt'];
  String dropdownValue = "";
  String? tenmon;
  int? giamon;
  String? linkmon;
  String? id;
  String? fileUrl;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddMenuModel());

    _model.txtTenMonController ??= TextEditingController();
    _model.txtTenMonFocusNode ??= FocusNode();

    _model.txtGiaController ??= TextEditingController();
    _model.txtGiaFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        fileUrl = pickedFile.path;
      });
    }
  }
  String removeDiacritics(String input) {
  return input.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
              .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
              .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
              .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
              .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
              .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
              .replaceAll(RegExp(r'[đ]'), 'd');
}
  Future<void> uploadData() async {
    if (fileUrl == "" || fileUrl == "null" || fileUrl == null){
      Fluttertoast.showToast(
            msg: "Vui lòng chọn hình ảnh",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
            );
    }else{
      showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      tenmon = _model.txtTenMonController.text.toString();
    giamon = int.parse( _model.txtGiaController.text.toString());
    String? photolink;
    id = removeDiacritics(tenmon.toString().replaceAll(' ', '').toLowerCase());
    DatabaseReference ref = FirebaseDatabase.instance.ref("menu/${id}");
    File file = File(fileUrl.toString());
    String fileName = id.toString(); // Use a unique name for the file

  try {
    firebase_storage.SettableMetadata metadata = firebase_storage.SettableMetadata(
      contentType: 'image/jpeg', // e.g., 'image/jpeg'
    );
    final snapshot = await firebase_storage.FirebaseStorage.instance
        .ref('menu/${fileName}')
        .putFile(file, metadata);
    
    photolink = await firebase_storage.FirebaseStorage.instance.ref('menu/${fileName}').getDownloadURL();
    await ref.set({
      "ten": tenmon.toString(),
      "gia":  giamon,
      "loai" : dropdownValue.toString(),
      "photoUrl" : photolink.toString(),
      "id" : id.toString()
    }).whenComplete(() => Navigator.pushNamed(context, '/menu'));
  } on firebase_storage.FirebaseException catch (e) {
    print('Error uploading image to Firebase Storage: $e');
  }
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
          title: Text(
            'Thêm Menu',
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                            child: _selectedImage != null
                              ? Image.file(
                                  _selectedImage!,
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
                              Icons.cloud_upload,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                            onPressed: () {
                              _pickImage();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.00, -1.00),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      'Tên món :',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 5, 8, 0),
                  child: TextFormField(
                    controller: _model.txtTenMonController,
                    focusNode: _model.txtTenMonFocusNode,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
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
                    validator: _model.txtTenMonControllerValidator
                        .asValidator(context),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.00, -1.00),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      'Giá :',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 5, 8, 0),
                  child: TextFormField(
                    controller: _model.txtGiaController,
                    focusNode: _model.txtGiaFocusNode,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
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
                        _model.txtGiaControllerValidator.asValidator(context),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.00, -1.00),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 5),
                    child: Text(
                      'Loại:',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () {
                      uploadData();
                    },
                    text: 'Thêm',
                    options: FFButtonOptions(
                      width: 250,
                      height: 40,
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: Color(0xFF99FFCC),
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Readex Pro',
                                color: FlutterFlowTheme.of(context).primaryText,
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
