import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/utils/apis/Apis.dart';

class CustomController extends GetxController {
  var isLoading = false.obs;
  var errorMsg = "".obs;
  var connected = false.obs;

  Future loadData() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(InfixApi.service),
          headers: {'Accept': 'application/json'});
      print(response.body);
      var decode = jsonDecode(response.body);
      isLoading(false);
      connected.value = decode;
      return connected.value;
    } catch (e) {
      isLoading(false);
      errorMsg.value = e.toString();
      throw e.toString();
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    loadData();
    super.onInit();
  }
}
