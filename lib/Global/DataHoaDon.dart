import 'package:app_coffee_manage/Model/HoaDon.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
late SharedPreferences bandata;
String? _ban;
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
Future<List<HoaDon>> fetchDataFromFirebase() async {
  bandata = await SharedPreferences.getInstance();
  _ban = bandata.getString("tenban").toString();
  List<HoaDon> dataList = [];

  DataSnapshot snapshot = (await FirebaseDatabase.instance.reference().child('ban/${removeDiacritics(_ban.toString().toLowerCase())}/order/').once()).snapshot;
  Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>?;
  int i = 0;
  if (values != null) {
    values.forEach((key, value) {
      i = i+1;
      dataList.add(HoaDon(
        id:  value['id'],
        stt: i,
        mon: value['ten'],
        sl: value['soluong'],
        thanhTien: value['gia'],
      ));
    });
  }

  return dataList;
}
