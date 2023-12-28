import 'dart:async';

import 'package:app_coffee_manage/Model/HoaDon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Global/DataHoaDon.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Model/HoaDonModel.dart';
export '../Model/HoaDonModel.dart';

class HoaDonWidget extends StatefulWidget {
  const HoaDonWidget({Key? key}) : super(key: key);

  @override
  _HoaDonWidgetState createState() => _HoaDonWidgetState();
}

class _HoaDonWidgetState extends State<HoaDonWidget> {
  late HoaDonModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? fullName;
  late SharedPreferences bandata;
  String? _ban;
  StreamController<void> _banDataStream = StreamController<void>();
  int _tongTien = 0;
  String? _maHoaDon;
  String? _thuNgan;
  String? _gioVao;
  int sum = 0;

  @override
  void initState() {
    
    super.initState();
    _model = createModel(context, () => HoaDonModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    initial();
    loadBan();
  }
  updateData(int gia, int sum) async {
      DatabaseReference _ref = FirebaseDatabase.instance
        .ref("ban/${removeDiacritics(_ban!.toLowerCase())}/");
    await _ref.update({"tongtien": _tongTien - gia, "soluong" : sum - 1});
  }
  void noData() async{
    FirebaseDatabase.instance
        .ref('ban/${removeDiacritics(_ban!.toLowerCase())}/order')
        .remove();
    DatabaseReference _ref = FirebaseDatabase.instance
        .ref("ban/${removeDiacritics(_ban!.toLowerCase())}/");
    await _ref.update({"tongtien": 0, "soluong": 0, "trangthai": "Free", "giovao" : "No", "thungan" : "No", "mahoadon" : "No"});
  }
  
  void loadBan() async {
    bandata = await SharedPreferences.getInstance();
    _ban = bandata.getString("tenban").toString();
    try {
      DatabaseReference HDRef = FirebaseDatabase.instance
        .reference()
        .child('ban/${removeDiacritics(_ban.toString()).toLowerCase()}/');
    HDRef.child("tongtien").onValue.listen((event) {
      _tongTien = int.parse(event.snapshot.value.toString());
    });
    HDRef.child("mahoadon").onValue.listen((event) {
      _maHoaDon = event.snapshot.value.toString();
    });
    HDRef.child("thungan").onValue.listen((event) {
      _thuNgan = event.snapshot.value.toString();
    });
    HDRef.child("giovao").onValue.listen((event) {
      _gioVao = event.snapshot.value.toString();
    });
    _banDataStream.add(null);
    }catch (e){
      Navigator.pushNamed(context, '/order');
    }
  }
  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  String removeDiacritics(String input) {
    return input
        .replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
        .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
        .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
        .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
        .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
        .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
        .replaceAll(RegExp(r'[đ]'), 'd')
        .replaceAll(' ', '');
  }

  void initial() async {
    User? user = FirebaseAuth.instance.currentUser;
    fullName = user!.displayName.toString();
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

    return StreamBuilder(
      stream: _banDataStream.stream,
      builder: (context, snapshhot) {
        if (_ban == "" ||
            _tongTien == 0 ||
            _maHoaDon == null ||
            _thuNgan == null ||
            _gioVao == null) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return GestureDetector(
            onTap: () => _model.unfocusNode.canRequestFocus
                ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                : FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(
                    color: FlutterFlowTheme.of(context).primaryText),
                automaticallyImplyLeading: true,
                title: Text(
                  'Hoá Đơn',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 16,
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
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, -1),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                        child: Text(
                          'Hoá Đơn ' + _ban.toString(),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Mã HĐ : ',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    _maHoaDon.toString(),
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'TN : ',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    _thuNgan.toString(),
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Giờ vào : ',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    _gioVao.toString(),
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Giờ ra : ',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    0.toString(),
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: FutureBuilder<List<HoaDon>>(
                            future: fetchDataFromFirebase(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                noData();
                                return Text('Không có dữ liệu.');          
                              } else {
                                List<DataRow> dataRows =
                                    snapshot.data!.map((data) {
                                  sum = sum + 1;
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(data.stt.toString())),
                                      DataCell(Text(data.mon.toString())),
                                      DataCell(Text(data.sl.toString())),
                                      DataCell(Text(formatNumber(int.parse(
                                              data.thanhTien.toString()))
                                          .toString())),
                                      
                                      DataCell(InkWell(
                                        onTap: () {
                                          FirebaseDatabase.instance
                                              .ref(
                                                  'ban/${removeDiacritics(_ban!.toLowerCase()).toString()}/order/${data.id.toString()}')
                                              .remove();
                                          updateData(int.parse(data.thanhTien.toString()), sum);
                                          setState(() {
                                            _tongTien = _tongTien - int.parse(data.thanhTien.toString());
                                            if (_tongTien == 0){
                                              Navigator.pop(context);
                                              Navigator.pushNamed(context, '/order');
                                              noData();
                                             
                                            }
                                          });
                                        },
                                        child: Icon(
                                          Icons.cancel_presentation_outlined,
                                          size: 20,
                                        ),
                                      )),
                                    ],
                                  );
                                }).toList();

                                return DataTable2(
                                  
                                  columnSpacing: 0,
                                  horizontalMargin: 10,
                                  columns: [
                                    DataColumn2(
                                        label: Text('#'),
                                        size: ColumnSize.S,
                                        fixedWidth: 20),
                                    DataColumn2(
                                        label: Text('Món'),
                                        size: ColumnSize.L,
                                        fixedWidth: 180),
                                    DataColumn2(
                                        label: Text('SL'),
                                        size: ColumnSize.M,
                                        fixedWidth: 40),
                                    DataColumn2(
                                      label: Text('Thành tiền'),
                                      size: ColumnSize.L,
                                    ),
                                    DataColumn2(
                                      label: Text('Xoá'),
                                      size: ColumnSize.S,
                                    ),
                                  ],
                                  rows: dataRows,
                                  // Add other properties and styling as needed
                                );
                              }
                            },
                          )),
                    ),

                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng tiền : ',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            formatNumber(int.parse(_tongTien.toString()))
                                    .toString() +
                                ' đ',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 50, 20, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'TPBANK : NGUYEN THANH CONG',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          QrImageView(
                            data:
                                '00020101021138640010A000000727013400069704260120MOMO23350M00425705150208QRIBFTTA53037045405' +
                                    '${_tongTien.toString()}' +
                                    '5802VN62190515MOMOW2W42570515630415D7',
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        ],
                      ),
                    ),
                    // Generated code for this Row Widget...
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FFButtonWidget(
                            onPressed: () {
                              print('Button pressed ...');
                            },
                            text: 'In Hoá Đơn',
                            options: FFButtonOptions(
                              height: 40,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
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
                          FFButtonWidget(
                            onPressed: () {},
                            text: 'Thanh Toán',
                            options: FFButtonOptions(
                              height: 40,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
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
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }
}
