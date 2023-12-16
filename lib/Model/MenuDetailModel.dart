import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../Screen/MenuDetailScreen.dart' show MenuDetailWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MenuDetailModel extends FlutterFlowModel<MenuDetailWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for txtTenMon widget.
  FocusNode? txtTenMonFocusNode;
  TextEditingController? txtTenMonController;
  String? Function(BuildContext, String?)? txtTenMonControllerValidator;
  // State field(s) for txtLoai widget.
  FocusNode? txtLoaiFocusNode1;
  TextEditingController? txtLoaiController1;
  String? Function(BuildContext, String?)? txtLoaiController1Validator;
  // State field(s) for txtLoai widget.
  FocusNode? txtLoaiFocusNode2;
  TextEditingController? txtLoaiController2;
  String? Function(BuildContext, String?)? txtLoaiController2Validator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    txtTenMonFocusNode?.dispose();
    txtTenMonController?.dispose();

    txtLoaiFocusNode1?.dispose();
    txtLoaiController1?.dispose();

    txtLoaiFocusNode2?.dispose();
    txtLoaiController2?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
