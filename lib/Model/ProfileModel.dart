import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '../Screen/ProfileScreen.dart' show ProfileWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for txtHoten widget.
  FocusNode? txtHotenFocusNode;
  TextEditingController? txtHotenController;
  String? Function(BuildContext, String?)? txtHotenControllerValidator;
  // State field(s) for txtSoDienThoai widget.
  FocusNode? txtSoDienThoaiFocusNode;
  TextEditingController? txtSoDienThoaiController;
  String? Function(BuildContext, String?)? txtSoDienThoaiControllerValidator;
  // State field(s) for rdSex widget.
  FormFieldController<String>? rdSexValueController;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    txtHotenFocusNode?.dispose();
    txtHotenController?.dispose();

    txtSoDienThoaiFocusNode?.dispose();
    txtSoDienThoaiController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.

  String? get rdSexValue => rdSexValueController?.value;
}
