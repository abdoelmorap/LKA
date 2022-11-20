import 'dart:convert';

import 'package:get/get.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/screens/chat/models/ChatFilesModel.dart';
import 'package:let_log/let_log.dart';

class ChatFilesController extends GetxController {
  final String chatId;
  final String type;

  ChatFilesController(this.chatId, this.type);

  var isLoading = false.obs;

  Rx<String> _token = "".obs;

  Rx<String> get token => this._token;

  Rx<String> _id = "".obs;

  Rx<String> get id => this._id;

  Rx<ChatFilesModel> chatFilesModel = ChatFilesModel().obs;

  Future<ChatFilesModel> getSingleFiles() async {
    Logger.warn(InfixApi.chatFiles + "/$type/$chatId");
    try {
      isLoading(true);
      await getIdToken().then((value) async {
        final response = await http.get(
            Uri.parse(InfixApi.chatFiles + "/$type/$chatId"),
            headers: Utils.setHeader(_token.toString()));
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          // log(jsonData);

          chatFilesModel.value = ChatFilesModel.fromJson(jsonData);
        } else {
          isLoading(false);
          throw Exception('failed to load');
        }
      });
    } catch (e) {
      isLoading(false);
      throw Exception('${e.toString()}');
    } finally {
      isLoading(false);
    }
    return chatFilesModel.value;
  }

  Future getIdToken() async {
    await Utils.getStringValue('token').then((value) async {
      _token.value = value;
      await Utils.getStringValue('id').then((value) async {
        _id.value = value;
      });
    });
  }

  @override
  void onInit() {
    getSingleFiles();
    super.onInit();
  }
}
