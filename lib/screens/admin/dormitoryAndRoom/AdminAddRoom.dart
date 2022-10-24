// Dart imports:
import 'dart:convert';

// Flutter imports:
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
import 'package:infixedu/utils/model/AdminDormitory.dart';
import 'package:infixedu/utils/model/RoomType.dart';

class AddRoom extends StatefulWidget {
  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  TextEditingController roomNoController = TextEditingController();
  TextEditingController noOfBedController = TextEditingController();
  TextEditingController costPerBedController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  Future<AdminDormitoryList> dormitories;
  Future<AdminRoomTypeList> rooms;
  Response response;
  Dio dio = Dio();

  String selectedDormitory;
  dynamic selectedDormitoryId;
  String selectedRoom;
  dynamic selectedRoomId;
  String _token;

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
        dormitories = getAllDormitory();
        dormitories.then((dormiVal) {
          setState(() {
            selectedDormitory = dormiVal.dormitories[0].title;
            selectedDormitoryId = dormiVal.dormitories[0].id;
          });
        });
        rooms = getAllRoomType();
        rooms.then((roomVal) {
          setState(() {
            selectedRoom = roomVal.rooms[0].title;
            selectedRoomId = roomVal.rooms[0].id;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Add Room',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextField(
                controller: roomNoController,
                style: Theme.of(context).textTheme.headline4,
                decoration: InputDecoration(hintText: 'Room no'.tr),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextField(
                controller: noOfBedController,
                style: Theme.of(context).textTheme.headline4,
                decoration: InputDecoration(hintText: 'Number of bed'.tr),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextField(
                controller: costPerBedController,
                style: Theme.of(context).textTheme.headline4,
                decoration: InputDecoration(hintText: 'Cost per bed'.tr),
              ),
            ),
            FutureBuilder<AdminDormitoryList>(
              future: dormitories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: getDormitoryDropdown(
                        context, snapshot.data.dormitories),
                  );
                } else {
                  return Container();
                }
              },
            ),
            FutureBuilder<AdminRoomTypeList>(
              future: rooms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: getRoomTypeDropdown(context, snapshot.data.rooms),
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
            Container(
              padding: const EdgeInsets.only(bottom: 16.0, top: 50.0),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent,
                ),
                onPressed: () {
                  addRoomData(
                          roomNoController.text,
                          '$selectedDormitoryId',
                          '$selectedRoomId',
                          costPerBedController.text,
                          noOfBedController.text,
                          noteController.text)
                      .then((value) {
                    if (value) {
                      roomNoController.text = '';
                      noOfBedController.text = '';
                      noteController.text = '';
                      costPerBedController.text = '';
                    }
                  });
                  Utils.showToast(
                      '${roomNoController.text}    ${noOfBedController.text}    ${costPerBedController.text}   $selectedRoomId  ${noteController.text}   $selectedRoomId');
                },
                child: new Text("Save".tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRoomTypeDropdown(
      BuildContext context, List<AdminRoomType> roomList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: roomList.map((item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                item.title,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            selectedRoom = value;
            selectedRoomId = getCode(roomList, value);
          });
        },
        value: selectedRoom,
      ),
    );
  }

  Widget getDormitoryDropdown(
      BuildContext context, List<AdminDormitory> dormitoryList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: dormitoryList.map((item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                item.title,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            selectedDormitory = value;
            selectedDormitoryId = getCode(dormitoryList, value);
          });
        },
        value: selectedDormitory,
      ),
    );
  }

  Future<bool> addRoomData(String roomNumber, String dormitoryId, String roomId,
      String cost, String numberOfBed, String des) async {
    FormData formData = FormData.fromMap({
      "room_number": roomNumber,
      "dormitory": dormitoryId,
      "room_type": roomId,
      "number_of_bed": numberOfBed,
      "cost_per_bed": cost,
      "description": des,
      "name": '$roomNumber',
    });
    try {
      response = await dio
          .post(
        InfixApi.dormitoryRoomList,
        data: formData,
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
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
      if (response.statusCode == 200) {
        Utils.showToast('Room Added Successfully'.tr);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  int getCode<T>(T t, String title) {
    int code;
    for (var cls in t) {
      if (cls.title == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }

  Future<AdminDormitoryList> getAllDormitory() async {
    final response = await http.get(Uri.parse(InfixApi.dormitoryList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return AdminDormitoryList.fromJson(jsonData['data']['dormitory_lists']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<AdminRoomTypeList> getAllRoomType() async {
    final response = await http.get(Uri.parse(InfixApi.roomTypeList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return AdminRoomTypeList.fromJson(jsonData['data']['room_type_lists']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
