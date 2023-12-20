class Menu {
  String ten;
  int? gia;
  String photoUrl;
 
  Menu(this.ten,this.gia, this.photoUrl);
  factory Menu.fromMap(Map<dynamic, dynamic> data) {
    return Menu(
      data['ten'],
      data['gia'],
      data['photoUrl'],
    );
  }
}