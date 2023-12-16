import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../Screen/AddMenuScreen.dart' show AddMenuWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddMenuModel extends FlutterFlowModel<AddMenuWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for txtTenMon widget.
  FocusNode? txtTenMonFocusNode;
  TextEditingController? txtTenMonController;
  String? Function(BuildContext, String?)? txtTenMonControllerValidator;
  // State field(s) for txtGia widget.
  FocusNode? txtGiaFocusNode;
  TextEditingController? txtGiaController;
  String? Function(BuildContext, String?)? txtGiaControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    txtTenMonFocusNode?.dispose();
    txtTenMonController?.dispose();

    txtGiaFocusNode?.dispose();
    txtGiaController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
