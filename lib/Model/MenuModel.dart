import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../Screen/MenuScreen.dart' show MenuWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MenuModel extends FlutterFlowModel<MenuWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for txtSearch widget.
  FocusNode? txtSearchFocusNode;
  TextEditingController? txtSearchController;
  String? Function(BuildContext, String?)? txtSearchControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    txtSearchFocusNode?.dispose();
    txtSearchController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
