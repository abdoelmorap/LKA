class VehicleRoute {
  dynamic id;
  String title;
  dynamic far;
  dynamic activeStatus;

  VehicleRoute({this.id, this.title, this.far, this.activeStatus});

  factory VehicleRoute.fromJson(Map<String, dynamic> json) {
    return VehicleRoute(
        id: json['id'],
        title: json['title'],
        far: json['far'],
        activeStatus: json['active_status']);
  }
}

class VehicleRouteList {
  List<VehicleRoute> routes;

  VehicleRouteList(this.routes);

  factory VehicleRouteList.fromJson(List<dynamic> jsonArr) {
    List<VehicleRoute> roomList = [];

    roomList = jsonArr.map((i) => VehicleRoute.fromJson(i)).toList();

    return VehicleRouteList(roomList);
  }
}
