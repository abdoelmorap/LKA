// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/exception/DioException.dart';
import 'package:infixedu/utils/model/Staff.dart';
import 'package:infixedu/utils/model/Vehicle.dart';
import 'package:infixedu/utils/widget/Line.dart';

class AddVehicle extends StatefulWidget {
  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  TextEditingController vehicleNoController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController yearMadeModelController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  Future<StaffList> staffs;
  Response response;
  Dio dio = Dio();
  Future vehicles;

  String selectedDriver;
  dynamic selectedId;
  String _token;
  bool staffFound = false;

  static List<Tab> tabs = <Tab>[
    Tab(
      text: 'Add Vehicle'.tr,
    ),
    Tab(
      text: 'Vehicle List'.tr,
    ),
  ];

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
      });
      vehicles = getAllVehicles();
      staffs = getAllStaff();
      staffs.then((staffVal) {
        setState(() {
          if (staffVal.staffs.length < 0) {
            staffFound = false;
          } else {
            staffFound = true;
            selectedDriver = staffVal.staffs[0].name;
            selectedId = staffVal.staffs[0].id;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Add Vehicle',
      ),
      body: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: DefaultTabController(
          length: tabs.length,
          initialIndex: 0,
          child: Builder(
            builder: (context) {
              final TabController tabController =
                  DefaultTabController.of(context);
              tabController.addListener(() {
                if (tabController.indexIsChanging) {
                  setState(() {
                    vehicles = getAllVehicles();
                  });
                }
              });
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  title: TabBar(
                    labelColor: Colors.black,
                    labelPadding: EdgeInsets.zero,
                    indicatorColor: Colors.purple,
                    tabs: tabs,
                    indicatorPadding: EdgeInsets.zero,
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: TabBarView(
                    children: [
                      addVehicle(),
                      vehicleList(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget vehicleList() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: FutureBuilder<AssignVehicleList>(
            future: vehicles,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.assignVehicle.length > 0) {
                  return ListView.separated(
                      itemCount: snapshot.data.assignVehicle.length,
                      separatorBuilder: (context, index) {
                        return BottomLine();
                      },
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Model'.tr,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        snapshot.data.assignVehicle[index]
                                            .vehicleModel,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Number'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        snapshot
                                            .data.assignVehicle[index].vehicleNo
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Made Year'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        snapshot
                                            .data.assignVehicle[index].madeYear
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Note'.tr,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        snapshot.data.assignVehicle[index].note,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      });
                } else {
                  return Utils.noDataWidget();
                }
              } else {
                return Center(child: CupertinoActivityIndicator());
              }
            }),
      ),
    );
  }

  Widget addVehicle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: vehicleNoController,
              style: Theme.of(context).textTheme.headline4,
              decoration: InputDecoration(hintText: 'Vehicle No'.tr),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: vehicleModelController,
              style: Theme.of(context).textTheme.headline4,
              decoration: InputDecoration(hintText: 'Vehicle Model'.tr),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: yearMadeModelController,
              style: Theme.of(context).textTheme.headline4,
              decoration: InputDecoration(hintText: 'Year Made'.tr),
            ),
          ),
          FutureBuilder<StaffList>(
            future: staffs,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: getDriverDropdown(context, snapshot.data.staffs),
                );
              } else {
                return Container();
              }
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: noteController,
              style: Theme.of(context).textTheme.headline4,
              decoration: InputDecoration(hintText: 'Note'.tr),
            ),
          ),
          Expanded(child: Container()),
          staffFound
              ? Container(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurpleAccent,
                    ),
                    onPressed: () {
                      addVehicleData(
                              vehicleNoController.text,
                              vehicleModelController.text,
                              '$selectedId',
                              noteController.text,
                              yearMadeModelController.text)
                          .then((value) {
                        if (value) {
                          vehicleNoController.text = '';
                          vehicleModelController.text = '';
                          noteController.text = '';
                          yearMadeModelController.text = '';
                        }
                      });
                    },
                    child: new Text("Save".tr),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                )
        ],
      ),
    );
  }

  Widget getDriverDropdown(BuildContext context, List<Staff> driverList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: driverList.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            selectedDriver = value;
            selectedId = getCode(driverList, value);
          });
        },
        value: selectedDriver,
      ),
    );
  }

  Future<bool> addVehicleData(String vehicleNo, String model, String driverId,
      String note, String year) async {
    print(InfixApi.addVehicle(vehicleNo, model, driverId, note, year));
    response = await dio
        .post(
      InfixApi.addVehicle(vehicleNo, model, driverId, note, year),
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": _token.toString(),
        },
      ),
    )
        .catchError((e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showToast(errorMessage);
    });
    if (response.statusCode == 200) {
      Utils.showToast('Vehicle Added'.tr);
      return true;
    } else {
      return false;
    }
  }

  int getCode<T>(T t, String title) {
    int code;
    for (var cls in t) {
      if (cls.name == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }

  Future<StaffList> getAllStaff() async {
    final response = await http.get(Uri.parse(InfixApi.driverList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StaffList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<AssignVehicleList> getAllVehicles() async {
    final response = await http.get(Uri.parse(InfixApi.vehicles),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return AssignVehicleList.fromJson(jsonData['data']['assign_vehicles']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
