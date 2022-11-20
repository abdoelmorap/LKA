// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/Fee.dart';
import '../../../utils/Utils.dart';

// import 'dart:developer';



class FeeService {
  int _id;
  String _token;

  FeeService(this._id, this._token);

  List<FeeElement> feeMap = [];
  List<double> totalMap = [];

  bool isNullOrEmpty(Object o) => o == null || "" == o;

  Future<List<FeeElement>> fetchFee() async {
    try{
      feeMap.clear();

      //Utils.showToast(InfixApi.getFeesUrl(_id));

      final response = await http.get(Uri.parse(InfixApi.getFeesUrl(_id)),
          headers: Utils.setHeader(_token.toString()));

      var jsonData = json.decode(response.body);

      bool isSuccess = jsonData['success'];
      var data = feeFromJson(response.body);

      if (isSuccess) {
        for (var f in data.data.fees) {
          feeMap.add(FeeElement(
              feesName: f.feesName,
              dueDate: f.dueDate,
              amount: f.amount,
              paid: f.paid,
              balance: f.balance,
              discountAmount:
              this.isNullOrEmpty(f.discountAmount) ? 0 : f.discountAmount,
              fine: f.fine,
              feesTypeId: f.feesTypeId,
              currencySymbol: data.data.currencySymbol.currencySymbol));
        }
      } else {
        Utils.showToast('try again later');
      }
    }catch (e){
      print(e);
    }
    return feeMap;
  }

  Future<List<double>> fetchTotalFee() async {
    try{
      double _amount = 0;
      double _discount = 0;
      double _fine = 0;
      double _paid = 0;
      double _balance = 0;

      final response = await http.get(Uri.parse(InfixApi.getFeesUrl(_id)),
          headers: Utils.setHeader(_token.toString()));

      var jsonData = json.decode(response.body);

      bool isSuccess = jsonData['success'];
      final data = feeFromJson(response.body);

      if (isSuccess) {
        data.data.fees.forEach((element) {
          _amount = _amount + double.parse(element.amount.toString());

          element.paid == 0
              ? _paid = _paid + 0.0
              : _paid = _paid + double.parse(element.paid.toString());

          element.fine == 0
              ? _fine = _fine + 0.0
              : _fine = _fine + double.parse(element.fine.toString());

          element.discountAmount == null || element.discountAmount == ""
              ? _discount = _discount + 0.0
              : _discount = _discount + double.parse(element.discountAmount.toString());

          _balance = _balance + double.parse(element.balance.toString());
        });
        totalMap.add(_amount);
        totalMap.add(_discount);
        totalMap.add(_fine);
        totalMap.add(_paid);
        totalMap.add(_balance);
      } else {
        Utils.showToast('try again later');
      }
    }catch (e){
      print(e);
    }
    return totalMap;
  }
}
