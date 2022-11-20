class AdminRoomType {
  String title;
  dynamic id;

  AdminRoomType({this.title, this.id});

  factory AdminRoomType.fromJson(Map<String, dynamic> json) {
    return AdminRoomType(
      title: json['type'],
      id: json['id'],
    );
  }
}

class AdminRoomTypeList {
  List<AdminRoomType> rooms;

  AdminRoomTypeList(this.rooms);

  factory AdminRoomTypeList.fromJson(List<dynamic> jsonArr) {
    List<AdminRoomType> roomList = [];

    roomList = jsonArr.map((i) => AdminRoomType.fromJson(i)).toList();

    return AdminRoomTypeList(roomList);
  }
}
