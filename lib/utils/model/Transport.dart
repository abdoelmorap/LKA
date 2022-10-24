class Transport {
  String route;
  String no;
  String model;
  dynamic madeYear;
  String driverName;
  String mobile;
  String license;

  Transport(
      {this.route,
      this.no,
      this.model,
      this.madeYear,
      this.driverName,
      this.mobile,
      this.license});

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
        route: json['route'],
        no: json['vehicle_no'],
        model: json['vehicle_model'],
        madeYear: json['made_year'],
        driverName: json['driver_name'],
        mobile: json['mobile'],
        license: json['driving_license']);
  }
}

class TransportList {
  List<Transport> transports;

  TransportList(this.transports);

  factory TransportList.fromJson(List<dynamic> jsonArr) {
    List<Transport> transports = [];

    transports = jsonArr.map((i) => Transport.fromJson(i)).toList();

    return TransportList(transports);
  }
}
