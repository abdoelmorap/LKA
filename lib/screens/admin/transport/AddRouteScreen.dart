// 🐦 Flutter imports:

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
import 'package:infixedu/utils/model/Route.dart';

// ignore: must_be_immutable
class AddRoute extends StatefulWidget {
  @override
  _AddRouteState createState() => _AddRouteState();
}

class _AddRouteState extends State<AddRoute> {
  TextEditingController titleController = TextEditingController();

  TextEditingController fareController = TextEditingController();

  String _token;
  String id;

  Response response;

  Dio dio = Dio();

  Future getRoute;

  static List<Tab> tabs = <Tab>[
    Tab(
      text: 'Route List'.tr,
    ),
    Tab(
      text: 'Add New'.tr,
    ),
  ];

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      _token = value;
    }).then((value) {
      setState(() {
        Utils.getStringValue('id').then((value) {
          id = value;
        });
        getRoute = getRouteList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Route',
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
                  print(tabController.index);
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
                    labelStyle: Theme.of(context).textTheme.headline4,
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: TabBarView(
                    children: [
                      routeList(),
                      addRoute(),
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

  Widget routeList() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: FutureBuilder<VehicleRouteList>(
            future: getRoute,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.routes.length > 0) {
                  return ListView.separated(
                      itemCount: snapshot.data.routes.length,
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemBuilder: (context, index) {
                        return Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Route'.tr,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    snapshot.data.routes[index].title,
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Fare'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    snapshot.data.routes[index].far.toString(),
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ],
                              ),
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

  Widget addRoute() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            style: Theme.of(context).textTheme.headline4,
            decoration: InputDecoration(hintText: 'Route title here'.tr),
          ),
          TextField(
            controller: fareController,
            style: Theme.of(context).textTheme.headline4,
            decoration: InputDecoration(hintText: 'Enter fare here'.tr),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 16.0),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurpleAccent,
              ),
              onPressed: () {
                addRouteData(titleController.text, fareController.text, id)
                    .then((value) {
                  if (value) {
                    titleController.text = '';
                    fareController.text = '';
                  }
                });
              },
              child: new Text("Save".tr),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: missing_return
  Future<VehicleRouteList> getRouteList() async {
    final response = await http.get(
        Uri.parse(InfixApi.transportRoute),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return VehicleRouteList.fromJson(data['data']);
    }
  }

  Future<bool> addRouteData(String title, String fare, String uid) async {
    response = await dio
        .post(
      InfixApi.addRoute(title, fare, uid),
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": _token.toString(),
        },
      ),
    )
        .catchError((e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      print(errorMessage);
      Utils.showToast(errorMessage);
    });
    if (response.statusCode == 200) {
      Utils.showToast('Route Added');
      return true;
    } else {
      return false;
    }
  }
}
