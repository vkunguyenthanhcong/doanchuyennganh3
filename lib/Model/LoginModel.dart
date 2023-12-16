import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../Screen/LoginScreen.dart' show LoginWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginModel extends FlutterFlowModel<LoginWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for txtUsername widget.
  FocusNode? txtUsernameFocusNode;
  TextEditingController? txtUsernameController;
  String? Function(BuildContext, String?)? txtUsernameControllerValidator;
  // State field(s) for txtPassword widget.
  FocusNode? txtPasswordFocusNode;
  TextEditingController? txtPasswordController;
  late bool txtPasswordVisibility;
  String? Function(BuildContext, String?)? txtPasswordControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    txtPasswordVisibility = false;
  }

  void dispose() {
    unfocusNode.dispose();
    txtUsernameFocusNode?.dispose();
    txtUsernameController?.dispose();

    txtPasswordFocusNode?.dispose();
    txtPasswordController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
