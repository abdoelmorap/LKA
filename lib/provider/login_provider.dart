// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:infixedu/utils/apis/Apis.dart';
// class LoginProvider extends ChangeNotifier{
//
//
//   int _userID;
//   int get userID => this._userID;
//
//   int _roleID;
//   int get roleID => this._roleID;
//
//   int _schoolID;
//   int get schoolID => this._schoolID;
//
//   int _classID;
//   int get classID => this._classID;
//
//   int _sectionID;
//   int get sectionID => this._sectionID;
//
//   String _image;
//   String get image => this._image;
//
//   String _isAdministrator;
//   String get isAdministrator => this._isAdministrator;
//
//   int _zoom;
//   int get zoom => this._zoom;
//
//   Future<bool> getInfo(id) async {
//     bool isSucceed = false;
//
//
//     Response response = await get(InfixApi.getChildren(id));
//
//     if (response.statusCode == 200) {
//
//       Map<String, dynamic> user = jsonDecode(response.body) as Map;
//       isSucceed = user['success'];
//
//       if (isSucceed) {
//
//
//         _userID = user['data']['user']['user_id'];
//         _roleID = user['data']['user']['role_id'];
//         _schoolID = user['data']['user']['school_id'];
//         _classID = user['data']['user']['class_id'];
//         _sectionID = user['data']['user']['section_id'];
//
//         if (_roleID == 1 || _roleID == 4) {
//           _image = user['data']['userDetails']['staff_photo'] == null ||
//               user['data']['userDetails']['staff_photo'] == ''
//               ? 'public/uploads/staff/demo/staff.jpg'
//               : user['data']['userDetails']['staff_photo'];
//         } else if (_roleID == 2) {
//           _image = user['data']['userDetails']['student_photo'] == null ||
//               user['data']['userDetails']['student_photo'] == ''
//               ? 'public/uploads/staff/demo/staff.jpg'
//               : user['data']['userDetails']['student_photo'];
//         } else if (_roleID == 3) {
//           _image = user['data']['userDetails']['guardian_photo'] == null ||
//               user['data']['userDetails']['guardian_photo'] == ''
//               ? 'public/uploads/staff/demo/staff.jpg'
//               : user['data']['userDetails']['guardian_photo'];
//         }
//
//         notifyListeners();
//
//       }
//     }
//     return isSucceed;
//   }
//
// }
