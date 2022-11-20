class Vehicle {
  dynamic id;
  String vehicleNo;
  String vehicleModel;
  String madeYear;
  String note;

  Vehicle({this.id, this.vehicleNo, this.vehicleModel,this.madeYear,this.note});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? '',
      vehicleNo: json['vehicle_no'] ?? '',
      vehicleModel: json['vehicle_model'] ?? '',
      madeYear: json['made_year'] == null ? 'N/A' : json['made_year'].toString(),
      note: json['note'] ?? 'N/A',
    );
  }
}

class AssignVehicleList {
  List<Vehicle> assignVehicle;

  AssignVehicleList(this.assignVehicle);

  factory AssignVehicleList.fromJson(List<dynamic> json) {
    List<Vehicle> assignVehicleList = [];

    assignVehicleList = json.map((i) => Vehicle.fromJson(i)).toList();

    return AssignVehicleList(assignVehicleList);
  }
}
