import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../Screen/NhanSuScreen.dart' show NhanSuWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NhanSuModel extends FlutterFlowModel<NhanSuWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for txtFind widget.
  FocusNode? txtFindFocusNode;
  TextEditingController? txtFindController;
  String? Function(BuildContext, String?)? txtFindControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    txtFindFocusNode?.dispose();
    txtFindController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
