// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:age/age.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// Project imports:
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/InfixMap.dart';

class ProfileService {
  String email;
  String password;
  String id;
  String token;

  ProfileService({this.email, this.password, this.id,this.token});

  List<InfixMap> infixMap = [];

  Future<List<InfixMap>> fetchPersonalServices(int index) async {

    infixMap.clear();

    final response = await http.get(Uri.parse(InfixApi.getChildren(id)),headers: id == null ? null : Utils.setHeader(token.toString()));

    print(response.statusCode);
    var jsonData = json.decode(response.body);

    var details = jsonData['data']['userDetails'];
    var religion = jsonData['data']['religion'];
    var blood = jsonData['data']['blood_group'];
    var transport = jsonData['data']['transport'];
    String dob = details['date_of_birth'];
    String replaced = dob.replaceAll('-', '/');
    var formatted = DateFormat('y/M/d').parse(replaced);
    DateTime birthday = DateTime(formatted.year,formatted.month,formatted.day);
    DateTime today = DateTime.now();
    AgeDuration age;
    age = Age.dateDifference(
        fromDate: birthday, toDate: today, includeToDate: false);
    // print(age.years);
    switch (index) {
      case 0:
        infixMap.add(InfixMap('Date of birth', details['date_of_birth']));
        infixMap.add(InfixMap('Age', '${age.years.toString()} years'));
        infixMap.add(
            InfixMap('Religion', religion != null ? religion['name'] : null));
        infixMap.add(InfixMap('Phone number', details['mobile']));
        infixMap.add(InfixMap('Email address', details['email']));
        infixMap.add(InfixMap('Present address', details['current_address']));
        infixMap
            .add(InfixMap('Permanent address', details['permanent_address']));
        infixMap
            .add(InfixMap('Blood group', blood != null ? blood['name'] : null));
        break;
      case 1:
        details['fathers_photo'] != null
            ? infixMap
            .add(InfixMap('Fathers\'s Photo', details['fathers_photo']))
            : infixMap.add(InfixMap(
            'Fathers\'s Photo', "https://i.imgur.com/7PqjiH7.jpg"));
        infixMap.add(InfixMap('Father\'s name', details['fathers_name']));
        infixMap.add(InfixMap('Father\'s phone', details['fathers_mobile']));
        infixMap.add(
            InfixMap('Father\'s occupation', details['fathers_occupation']));
        details['mothers_photo'] != null
            ? infixMap
                .add(InfixMap('Mothers\'s Photo', details['mothers_photo']))
            : infixMap.add(InfixMap(
                'Mothers\'s Photo', "https://i.imgur.com/7PqjiH7.jpg"));
        infixMap.add(InfixMap('Mother\'s name', details['mothers_name']));
        infixMap.add(InfixMap('Mother\'s phone', details['mothers_mobile']));
        infixMap.add(
            InfixMap('Mother\'s occupation', details['mothers_occupation']));
        details['guardians_photo'] != null
            ? infixMap
            .add(InfixMap('Guardians\'s Photo', details['guardians_photo']))
            : infixMap.add(InfixMap(
            'Guardians\'s Photo', "https://i.imgur.com/7PqjiH7.jpg"));
        infixMap.add(InfixMap('Guardian\'s name', details['guardians_name']));
        infixMap.add(InfixMap('Guardian\'s email', details['guardians_email']));
        infixMap.add(InfixMap(
            'Guardian\'s occupation', details['guardians_occupation']));
        infixMap
            .add(InfixMap('Guardian\'s phone', details['guardians_mobile']));
        infixMap.add(
            InfixMap('Guardian\'s relation', details['guardians_relation']));
        break;
      case 2:
        if (transport != null) {
          infixMap.add(InfixMap('Driver\'s name', transport['driver_name']));
          infixMap.add(InfixMap('Car no', transport['vehicle_no']));
          infixMap.add(InfixMap('Car model', transport['vehicle_model']));
          infixMap.add(InfixMap('Car info', transport['note']));
        }
        break;
      case 3:
        infixMap.add(InfixMap('Height', details['height'] + '(inch)'));
        infixMap.add(InfixMap('Weight', details['weight'] + '(kg)'));
        infixMap.add(InfixMap('Caste', details['caste']));
        infixMap.add(InfixMap('National ID', details['national_id_no']));
        infixMap.add(InfixMap('Local ID', details['local_id_no']));
        infixMap.add(InfixMap('Bank Name', details['bank_name']));
        infixMap.add(InfixMap('Bank Account ', details['bank_account_no']));
        break;
      case 4:
        infixMap.add(InfixMap('name', details['full_name']));
        infixMap.add(InfixMap('section_name', details['section_name']));
        infixMap.add(InfixMap('class_name', details['class_name']));
        infixMap.add(InfixMap('roll_no', details['roll_no'].toString()));
        infixMap.add(InfixMap('adm', details['admission_no'].toString()));
        break;
    }

    //Utils.showToast(infixMap[0].key+' '+infixMap[0].value);

    return infixMap;
  }
}
