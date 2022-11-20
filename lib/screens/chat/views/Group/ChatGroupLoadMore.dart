import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as GETx;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:infixedu/screens/chat/controller/chat_controller.dart';
import 'package:infixedu/screens/chat/controller/chat_group_open_controller.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/chat/models/ChatGroupOpenModel.dart';
import 'package:infixedu/screens/chat/models/GroupThread.dart';
import 'package:let_log/let_log.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ChatGroupLoadMore extends LoadingMoreBase<GroupThread> {
  final String groupId;
  ChatGroupLoadMore(this.groupId, this.chatGroupOpenController);
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int productsLength = 0;

  dynamic source;

  final ChatGroupOpenController chatGroupOpenController;

  final ChatController _chatController = GETx.Get.put(ChatController());

  Dio _dio = Dio();

  @override
  void add(GroupThread element) {
    super.add(element);
  }

  @override
  bool get hasMore => _hasMore;

  @override
  void onStateChanged(LoadingMoreBase<GroupThread> source) {
    print("stateChange");
    super.onStateChanged(source);
  }

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    // pageIndex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    bool isSuccess = false;
    try {
      String _token = "";
      await Utils.getStringValue('token').then((value) async {
        _token = value;
        //to show loading more clearly, in your app,remove this
        // await Future.delayed(Duration(milliseconds: 500));
        var result;

        if (this.length == 0) {
          result = await _dio.get(
            "${InfixApi.chatGroupOpen}/$groupId",
            options: Options(
              headers: Utils.setHeader(_token.toString()),
            ),
          );
        } else {
          result = await _dio.post(
            "${InfixApi.chatGroupMsgLoadMore}",
            data: jsonEncode(
              {
                "ids":
                    chatGroupOpenController.msgIds.toSet().toList().toString(),
                "group_id": groupId,
              },
            ),
            options: Options(
              headers: Utils.setHeader(_token.toString()),
            ),
          );
          Logger.net(
            InfixApi.chatGroupMsgLoadMore,
            data: jsonEncode(
              {
                "ids":
                    chatGroupOpenController.msgIds.toSet().toList().toString(),
                "group_id": groupId,
              },
            ),
          );
        }
        print(result.data);
        // var reversed;
        final data = new Map<String, dynamic>.from(result.data);

        if (this.length == 0) {
          source = ChatGroupOpenModel.fromJson(data);
          if (source.group.threads.length != 0) {
            if (_chatController.chatSettings.value.chatSettings.chatMethod !=
                "pusher") {
              chatGroupOpenController.lastThreadId.value =
                  source.group.threads.first.id;
            }
          } else {
            if (_chatController.chatSettings.value.chatSettings.chatMethod !=
                "pusher") {
              chatGroupOpenController.lastThreadId.value = null;
            }
          }
        } else {
          source = ChatGroupLoadMoreModel.fromJson(data);
          // if (source.singleThreads != null) {
          //   reversed = source.singleThreads.toList().reversed;
          // }
        }

        if (pageIndex == 1) {
          this.clear();
        }
        if (this.length == 0) {
          if (source.group.threads != null &&
              source.group.threads.length != 0) {
            productsLength = source.group.threads.length;
            source.group.threads.forEach((value) {
              chatGroupOpenController.msgIds.add(value.id);
            });
            for (var item in source.group.threads) {
              this.add(item);
            }
          }
        } else {
          if (source.singleThreads != null &&
              source.singleThreads.length != 0) {
            productsLength = source.singleThreads.length;
            source.singleThreads.forEach((value) {
              chatGroupOpenController.msgIds.add(value.id);
            });
            for (var item in source.singleThreads.reversed) {
              this.add(item);
            }
          }
        }

        if (pageIndex == 1) {
          if (source.group.threads != null &&
              source.group.threads.length != 0) {
            _hasMore = true;
          } else {
            _hasMore = false;
          }
        } else {
          if (source.singleThreads != null &&
              source.singleThreads.length != 0) {
            _hasMore = true;
          } else {
            _hasMore = false;
          }
        }

        pageIndex++;
        isSuccess = true;
      });
    } catch (exception, _) {
      isSuccess = false;
      print(exception);
      print(_);
    }
    return isSuccess;
  }

  @override
  void dispose() {
    // cancelStream();
    super.dispose();
  }

  Future checkNewMsg() async {
    ChatGroupCheckMsgModel data;

    try {
      Map jsonData = {
        "user_id": chatGroupOpenController.id.value,
        "last_thread_id": chatGroupOpenController.lastThreadId.value,
        "group_id": groupId,
      };
      Logger.debug('jsonCHECK', jsonData);
      final response = await _dio.post(
        InfixApi.chatGroupMsgCheck,
        options: Options(
          headers: Utils.setHeader(chatGroupOpenController.token.toString()),
        ),
        data: jsonEncode(jsonData),
      );

      final msgCheckResultData = new Map<String, dynamic>.from(response.data);

      // Logger.debug('RESPONSE CHECK', msgCheckResultData);

      if (response.statusCode == 200) {
        // print(msgCheckResultData['message']);

        Logger.debug('NOT NULL CHECK $msgCheckResultData');

        data = ChatGroupCheckMsgModel.fromJson(response.data);
        insert(0, data.messages.entries.first.value);

        chatGroupOpenController.msgIds
            .insert(0, data.messages.entries.first.value.id);

        onStateChanged(this);
        // await chatGroupOpenController.getAll();
      } else {
        throw Exception('failed to load');
      }
    } catch (e) {
      // throw Exception('${e.toString()}');
    }
    return data;
  }

  Future deleteGroupMessage(int threadId) async {
    EasyLoading.show(status: 'Deleting...');
    try {
      Map jsonData = {
        "thread_id": threadId,
      };

      print(jsonData);

      final response = await _dio.post(
        InfixApi.chatGroupMessageDelete,
        options: Options(
          headers:
              Utils.setHeader(chatGroupOpenController.token.value.toString()),
        ),
        data: jsonEncode(jsonData),
      );

      final msgCheckResultData = new Map<String, dynamic>.from(response.data);

      if (response.statusCode == 200) {
        Logger.debug('AFTER DELETE CHECK $msgCheckResultData');
      } else {
        throw Exception('failed to load');
      }
    } catch (e) {
      // throw Exception('${e.toString()}');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future submitText({Map data, bool hasFile, FormData formData}) async {
    print(jsonEncode(data));

    try {
      final response = await _dio.post(
        InfixApi.submitChatGroupText,
        options: Options(
          headers:
              Utils.setHeader(chatGroupOpenController.token.value.toString()),
        ),
        data: hasFile ? formData : jsonEncode(data),
      );
      print("SUBMIT TEXT RESPONSE => ${response.data}");
      print("SUBMIT TEXT STATUSCODE => ${response.statusCode}");
      if (response.statusCode == 200) {
        if (_chatController.chatSettings.value.chatSettings.chatMethod !=
            'pusher') {
          final msgCheckResultData =
              new Map<String, dynamic>.from(response.data);
          final thread = GroupThread.fromJson(msgCheckResultData['thread']);

          insert(0, thread);

          chatGroupOpenController.msgIds.insert(0, thread.id);
          print(chatGroupOpenController.msgIds);

          onStateChanged(this);
          chatGroupOpenController.lastThreadId.value = thread.id;
        }
      } else {
        throw Exception('failed to load');
      }
    } catch (e) {
      throw Exception('${e.toString()}');
    } finally {}
  }
}
