import 'dart:developer';

import 'package:get/get.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';

class UserController extends GetxController {
  Rx<int> _studentId = 0.obs;

  Rx<int> get studentId => this._studentId;

  Rx<String> _token = "".obs;

  Rx<String> get token => this._token;

  Rx<String> _schoolId = "".obs;

  Rx<String> get schoolId => this._schoolId;

  Rx<String> _role = "".obs;

  Rx<String> get role => this._role;

  Rx<bool> isLoading = false.obs;

  Rx<StudentRecords> _studentRecord = StudentRecords().obs;

  Rx<StudentRecords> get studentRecord => this._studentRecord;

  Rx<Record> selectedRecord = Record().obs;

  Future getStudentRecord() async {
    log('get record ${_studentId.value}');
    try {
      isLoading(true);
      await getIdToken().then((value) async {
        print("STD ${_studentId.value}");
        Utils.saveIntValue("myStudentId", _studentId.value);
        final response = await http.get(
            Uri.parse(InfixApi.studentRecord(_studentId.value)),
            headers: Utils.setHeader(_token.toString()));

        if (response.statusCode == 200) {
          final studentRecords = studentRecordsFromJson(response.body);
          _studentRecord.value = studentRecords;
          selectedRecord.value = _studentRecord.value.records.first;
          isLoading(false);
        } else {
          isLoading(false);
          throw Exception('failed to load');
        }
      });
    } catch (e) {
      isLoading(false);
      throw Exception('failed to load');
    }
  }

  Future getIdToken() async {
    await Utils.getStringValue('token').then((value) async {
      _token.value = value;
      await Utils.getStringValue('rule').then((ruleValue) {
        _role.value = ruleValue;
      }).then((value) async {
        if (_role.value == "2") {
          await Utils.getIntValue('studentId').then((studentIdVal) {
            _studentId.value = studentIdVal;
          });
        }
        await Utils.getStringValue('schoolId').then((schoolIdVal) {
          _schoolId.value = schoolIdVal;
        });
      });
    });
  }

  @override
  void onInit() {
    super.onInit();
  }
}
