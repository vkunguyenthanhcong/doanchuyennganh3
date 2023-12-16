import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../Screen/ThongTinQuanScreen.dart' show ThongTinQuanWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ThongTinQuanModel extends FlutterFlowModel<ThongTinQuanWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for txtTen widget.
  FocusNode? txtTenFocusNode;
  TextEditingController? txtTenController;
  String? Function(BuildContext, String?)? txtTenControllerValidator;
  // State field(s) for txtSoLuongBan widget.
  FocusNode? txtSoLuongBanFocusNode;
  TextEditingController? txtSoLuongBanController;
  String? Function(BuildContext, String?)? txtSoLuongBanControllerValidator;

  FocusNode? txtTenLoaiFocusNode;
  TextEditingController? txtTenLoaiController;
  String? Function(BuildContext, String?)? txtTenLoaiControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    txtTenFocusNode?.dispose();
    txtTenController?.dispose();

    txtSoLuongBanFocusNode?.dispose();
    txtSoLuongBanController?.dispose();

    txtTenLoaiFocusNode?.dispose();
    txtTenLoaiController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
