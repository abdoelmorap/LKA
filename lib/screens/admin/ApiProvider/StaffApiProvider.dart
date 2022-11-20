// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/LeaveAdmin.dart';
import 'package:infixedu/utils/model/LibraryCategoryMember.dart';
import 'package:infixedu/utils/model/Staff.dart';

class StaffApiProvider {
  String token;

  Future<LibraryMemberList> getAllCategory() async {
    await Utils.getStringValue('token').then((value) {
      token = value;
    });
    final response = await http.get(Uri.parse(InfixApi.getStuffCategory),headers: Utils.setHeader(token));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LibraryMemberList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<StaffList> getAllStaff(dynamic staffId) async {
    await Utils.getStringValue('token').then((value) {
      token = value;
    });
    final response = await http.get(
        Uri.parse(InfixApi.getAllStaff(staffId)),
        headers: Utils.setHeader(token));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StaffList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<LeaveAdminList> getAllLeave(String url, String endPoint) async {
    await Utils.getStringValue('token').then((value) {
      token = value;
    });
    final response =
        await http.get(Uri.parse(url), headers: Utils.setHeader(token));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LeaveAdminList.fromJson(jsonData['data'][endPoint]);
    } else {
      throw Exception('Failed to load');
    }
  }
}
