import 'package:app_coffee_manage/firebase_options.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Model/LoginModel.dart';
export '../Model/LoginModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;
  String ipAddress = 'Unknown';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late SharedPreferences logindata;
  
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    _model.txtUsernameController ??= TextEditingController();
    _model.txtUsernameFocusNode ??= FocusNode();

    _model.txtPasswordController ??= TextEditingController();
    _model.txtPasswordFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }
  void checkValidation(){
    if(_model.txtUsernameController.text.isEmpty || _model.txtPasswordController.text.isEmpty || _model.txtUsernameController.text == "" || _model.txtPasswordController.text == "")
    {
      Fluttertoast.showToast(
          msg: "Vui lòng điền đầy đủ thông tin",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
          );
    }else{
      main();
    }
  }

  Future<void> main() async {
    showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
    logindata = await SharedPreferences.getInstance();
    var connectivityResult = await (Connectivity().checkConnectivity());
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    if (connectivityResult == ConnectivityResult.wifi) {
      try {
        final response = await http.get(Uri.parse('https://api64.ipify.org?format=json'));
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          setState(() {
            ipAddress = data['ip'];
            
          });
        } else {
          print('Failed to get IP address. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print("Error getting WiFi IP address: $e");
      }
    } else {
      print("Not connected to a WiFi network");
    }
    
    if (ipAddress.toString() != "14.191.113.188"){
          Fluttertoast.showToast(
          msg: "Bạn vui lòng sử dụng Internet của quán để đăng nhập.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
          );
    }
    else{
      String? _username = _model.txtUsernameController.text.toString();
      String? _password = _model.txtPasswordController.text.toString();
      try{
        UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _username,
              password: _password);
        if (userCredential != null){
          final user = userCredential.user;
          if (user!.emailVerified == false){
            Navigator.pop(context);
            Fluttertoast.showToast(
            msg: "Email chưa được xác minh. Vui lòng kiểm tra hộp thư đến.",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
            );
            user.sendEmailVerification();
          }else{
            DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/${user!.uid}');
            userRef.child("roll").onValue.listen((event) {
              logindata.setString('roll', event.snapshot.value.toString());
            });
            Navigator.pushNamed(context, '/home');
          }
        }
      }on FirebaseAuthException catch  (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'Invalid email or password' || e.code == 'Invalid email or password.') {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Sai mật khẩu.",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
            );
        
      } else {
         Navigator.pop(context);   

        Fluttertoast.showToast(
            msg: "An error occurred: ${e.code.toString()}",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
            );
      }
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
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional(0.00, -1.00),
                child: Text(
                  'Chào Mừng Trở Lại!',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF996633)
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                child: Text(
                  'Đăng nhập để trở lại hệ thống',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        fontSize: 16,
                        color: Color(0xFF996633)
                  ),
                  
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                child: TextFormField(
                  controller: _model.txtUsernameController,
                  focusNode: _model.txtUsernameFocusNode,
                  textCapitalization: TextCapitalization.none,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Enter Email...',
                    labelStyle: FlutterFlowTheme.of(context).labelMedium,
                    hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primaryText,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
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
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.person,
                    ),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                  keyboardType: TextInputType.emailAddress,
                  validator: _model.txtUsernameControllerValidator
                      .asValidator(context),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _model.txtPasswordController,
                  focusNode: _model.txtPasswordFocusNode,
                  obscureText: !_model.txtPasswordVisibility,
                  decoration: InputDecoration(
                    labelText: 'Enter Password...',
                    labelStyle: FlutterFlowTheme.of(context).labelMedium,
                    hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primaryText,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
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
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.password_sharp,
                    ),
                    suffixIcon: InkWell(
                      onTap: () => setState(
                        () => _model.txtPasswordVisibility =
                            !_model.txtPasswordVisibility,
                      ),
                      focusNode: FocusNode(skipTraversal: true),
                      child: Icon(
                        _model.txtPasswordVisibility
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 22,
                      ),
                    ),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                  keyboardType: TextInputType.visiblePassword,
                  validator: _model.txtPasswordControllerValidator
                      .asValidator(context),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(1.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 20, 0),
                  child: Text(
                    'Quên mật khẩu?',
                    textAlign: TextAlign.end,
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: FFButtonWidget(
                  onPressed: () {
                    checkValidation();
                  },
                  text: 'Đăng Nhập',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color:  Color(0xFF996633),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
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
                padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 30),
                child: Text(
                  'Hoặc',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                child: FFButtonWidget(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  text: 'Đăng Ký',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: Colors.white,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).primaryText,
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
            ],
          ),
        ),
      ),
    );
  }
}
