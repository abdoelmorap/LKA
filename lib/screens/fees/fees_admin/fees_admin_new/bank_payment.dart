import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/Classes.dart';
import 'package:infixedu/screens/fees/model/FeesBankPaymet.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/utils/model/Section.dart';
import 'package:intl/intl.dart';

class FeeBankPaymentSearch extends StatefulWidget {
  @override
  _FeeBankPaymentSearchState createState() => _FeeBankPaymentSearchState();
}

class _FeeBankPaymentSearchState extends State<FeeBankPaymentSearch> {
  final TextEditingController datePickerController = TextEditingController();
  String _token;
  String rule;
  String _id;
  Future classes;
  Future<SectionList> sections;
  Future<FeeBankPaymentModel> bankPayment;
  dynamic classId;
  dynamic sectionId;
  String _selectedClass;
  String _selectedSection;
  String _selectedStatus;

  bool showSearch = false;

  List<String> _statusList = [
    'pending',
    'approve',
    'reject',
  ];

  @override
  void initState() {
    _selectedStatus = _statusList.first;
    Utils.getStringValue('token').then((value) async {
      setState(() {
        _token = value;
        bankPayment = getBankPayments();
        Utils.getStringValue('id').then((idValue) {
          _id = idValue;
          Utils.getStringValue('rule').then((ruleValue) {
            rule = ruleValue;
            classes = getAllClass(int.parse(_id));
            classes.then((value) {
              _selectedClass = value.classes[0].name;
              classId = value.classes[0].id;
              sections = getAllSection(int.parse(_id), classId);
              sections.then((sectionValue) {
                _selectedSection = sectionValue.sections[0].name;
                sectionId = sectionValue.sections[0].id;
              });
            });
          });
        });
      });
    });
    super.initState();
  }

  Future<FeeBankPaymentModel> getBankPayments() async {
    final response = await http.get(
        Uri.parse(InfixApi.adminFeesBankPaymentList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      log(jsonData.toString());
      return FeeBankPaymentModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
  }

  // ignore: missing_return
  Future<FeeBankPaymentModel> getBankPaymentSearchResult(Map data) async {
    try {
      final response = await http.post(
          Uri.parse(InfixApi.adminFeesBankPaymentSearch),
          body: jsonEncode(data),
          headers: Utils.setHeader(_token.toString()));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print('eer ${FeeBankPaymentModel.fromJson(jsonData)}');
        return FeeBankPaymentModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      print(e);
    }
  }

  Future getAllClass(int id) async {
    final response = await http.get(Uri.parse(InfixApi.getClassById(id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (rule == "1" || rule == "5") {
        return AdminClassList.fromJson(jsonData['data']['teacher_classes']);
      } else {
        return ClassList.fromJson(jsonData['data']['teacher_classes']);
      }
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<SectionList> getAllSection(dynamic id, dynamic classId) async {
    final response = await http.get(
        Uri.parse(InfixApi.getSectionById(id, classId)),
        headers: Utils.setHeader(_token.toString()));

    print(InfixApi.getSectionById(id, classId));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return SectionList.fromJson(jsonData['data']['teacher_sections']);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Fees Bank Payment',
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: classes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 10),
              shrinkWrap: true,
              children: <Widget>[
                showSearch
                    ? Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final initialDate = DateTime.now();
                              final DateTimeRange picked =
                                  await showDateRangePicker(
                                context: context,
                                helpText: 'Select start and End Date',
                                fieldStartHintText: 'Start Date',
                                fieldEndHintText: 'End Date',
                                currentDate: initialDate,
                                firstDate: DateTime(1900, initialDate.month + 1,
                                    initialDate.day),
                                lastDate: DateTime(2100, initialDate.month + 1,
                                    initialDate.day),
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      primaryColor: Colors.deepPurple,
                                      appBarTheme: AppBarTheme(
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    child: child,
                                  );
                                },
                              );

                              if (picked != null) {
                                setState(() {
                                  datePickerController.text =
                                      "${DateFormat('MM/dd/yyyy').format(picked.start)} - ${DateFormat('MM/dd/yyyy').format(picked.end)}";
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: TextFormField(
                                controller: datePickerController,
                                enabled: false,
                                style: Theme.of(context).textTheme.headline4,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  hintText: "Select Date",
                                  hintStyle:
                                      Theme.of(context).textTheme.headline4,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          getClassDropdown(snapshot.data.classes),
                          SizedBox(
                            height: 10,
                          ),
                          FutureBuilder<SectionList>(
                            future: sections,
                            builder: (context, secSnap) {
                              if (secSnap.hasData) {
                                return getSectionDropdown(
                                    secSnap.data.sections);
                              } else {
                                return Center(
                                    child: CupertinoActivityIndicator());
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          getStatusList(_statusList),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 50.0,
                                decoration: Utils.gradientBtnDecoration,
                                child: Text(
                                  "Search".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                          color: Colors.white, fontSize: 14),
                                ),
                              ),
                              onTap: () {
                                

                                Map data = {
                                  'payment_date': datePickerController.text,
                                  'class': classId,
                                  'section': sectionId,
                                  'approve_status': _selectedStatus
                                };
                                setState(() {
                                  bankPayment =
                                      getBankPaymentSearchResult(data);
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                FutureBuilder<FeeBankPaymentModel>(
                  future: bankPayment,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CupertinoActivityIndicator());
                    } else {
                      if (snapshot.hasData) {
                        if (snapshot.data.feesPayments.length == 0) {
                          return Utils.noDataWidget();
                        } else {
                          return ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                            itemCount: snapshot.data.feesPayments.length,
                            itemBuilder: (context, index) {
                              FeesPayment feePayment =
                                  snapshot.data.feesPayments[index];

                              return ListTile(
                                title: Text(
                                  feePayment.feeStudentInfo.fullName ?? 'NA',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontSize: 14),
                                ),
                                subtitle: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "${DateFormat.yMMMd().format(feePayment.createdAt)}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(fontSize: 12),
                                            maxLines: 1,
                                          ),
                                        ),
                                        PopupMenuButton(
                                          child: Icon(
                                            Icons.more_vert,
                                            color: Colors.deepPurple,
                                            size: 20,
                                          ),
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem(
                                                value: 'view',
                                                child: Text('View'.tr),
                                              ),
                                              PopupMenuItem(
                                                value: 'approve',
                                                child: Text('Approve'.tr),
                                              ),
                                              PopupMenuItem(
                                                value: 'reject',
                                                child: Text('Reject'.tr),
                                              )
                                            ];
                                          },
                                          onSelected: (String value) async {
                                            if (value == 'view') {
                                            } else if (value == 'approve') {
                                              final response = await http.post(
                                                Uri.parse(InfixApi
                                                    .adminApproveBankPayment),
                                                headers:
                                                    Utils.setHeader(_token),
                                                body: jsonEncode({
                                                  'transcation_id':
                                                      feePayment.id,
                                                }),
                                              );
                                              if (response.statusCode == 200) {
                                                Utils.showToast(
                                                    'Payment Approved'.tr);

                                                setState(() {
                                                  bankPayment =
                                                      getBankPayments();
                                                });
                                                return true;
                                              } else {
                                                return false;
                                              }
                                            } else {
                                              final response = await http.post(
                                                Uri.parse(InfixApi
                                                    .adminRejectBankPayment),
                                                headers:
                                                    Utils.setHeader(_token),
                                                body: jsonEncode({
                                                  'transcation_id':
                                                      feePayment.id,
                                                }),
                                              );
                                              if (response.statusCode == 200) {
                                                Utils.showToast(
                                                    'Payment Rejected'.tr);

                                                setState(() {
                                                  bankPayment =
                                                      getBankPayments();
                                                });
                                                return true;
                                              } else {
                                                return false;
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Amount',
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                  getPaidAmount(feePayment)
                                                      .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.dialog(
                                                  Scaffold(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    body: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          child: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                2,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            color: Colors.white,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(20),
                                                                        child:
                                                                            Text(
                                                                          "Note"
                                                                              .tr,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline5,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: GestureDetector(
                                                                          onTap: () {
                                                                            Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                          },
                                                                          child: Icon(
                                                                            Icons.close,
                                                                            color:
                                                                                Colors.black,
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      ListView(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                    ),
                                                                    shrinkWrap:
                                                                        true,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(feePayment
                                                                              .paymentNote ??
                                                                          ""),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Note',
                                                    maxLines: 1,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Text(
                                                    "Note".tr,
                                                    maxLines: 1,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'File',
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                  "View".tr,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Status',
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                getStatus(
                                                    feePayment.paidStatus),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }
                  },
                ),
              ],
            );
          } else {
            return Center(child: CupertinoActivityIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
        foregroundColor: Colors.deepPurple,
        backgroundColor: Colors.deepPurple,
        tooltip: 'Search Bank Payment',
        onPressed: () {
          setState(() {
            showSearch = !showSearch;
          });
        },
      ),
    );
  }

  Widget getStatus(String status) {
    if (status == "approve") {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.green),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Approved'.tr.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (status == "pending") {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.amber),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Pending'.tr.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (status == "reject") {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.red),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Rejected'.tr.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  getPaidAmount(FeesPayment feesPayment) {
    double amount = 0.0;

    feesPayment.transcationDetails.forEach((element) {
      amount += element.paidAmount;
    });

    return amount;
  }

  Widget getStatusList(List<String> _statusList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: _statusList.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Text(
                item.capitalizeFirst,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 15),
        onChanged: (value) {
          setState(() {
            _selectedStatus = value;
          });
        },
        value: _selectedStatus,
      ),
    );
  }

  Widget getClassDropdown(List classes) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        isDense: false,
        items: classes.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 15),
        onChanged: (value) {
          setState(() {
            _selectedClass = value;
            classId = getCode(classes, value);

            sections = getAllSection(int.parse(_id), classId);
            sections.then((sectionValue) {
              _selectedSection = sectionValue.sections[0].name;
              sectionId = sectionValue.sections[0].id;
            });

            debugPrint('User select class $classId');
          });
        },
        value: _selectedClass,
      ),
    );
  }

  Widget getSectionDropdown(List<Section> sectionlist) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: sectionlist.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 15),
        onChanged: (value) {
          setState(() {
            _selectedSection = value;

            sectionId = getCode(sectionlist, value);

            sections = getAllSection(int.parse(_id), classId);

            debugPrint('User select section $sectionId');
          });
        },
        value: _selectedSection,
      ),
    );
  }

  int getCode<T>(T t, String title) {
    int code;
    for (var cls in t) {
      if (cls.name == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }
}

class FeesBankPaymentResultScreen extends StatefulWidget {
  @override
  _FeesBankPaymentResultScreenState createState() =>
      _FeesBankPaymentResultScreenState();
}

class _FeesBankPaymentResultScreenState
    extends State<FeesBankPaymentResultScreen> {
  Future<FeeBankPaymentModel> fees;

  String _token;

  TextEditingController titleController, descripController;

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
        fees = getFeesGroups();
      });
    });
  }

  Future<FeeBankPaymentModel> getFeesGroups() async {
    final response = await http.get(
        Uri.parse(InfixApi.adminFeesBankPaymentList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return FeeBankPaymentModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Fees Bank Payment',
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<FeeBankPaymentModel>(
        future: fees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          } else {
            if (snapshot.hasData) {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data.feesPayments.length,
                itemBuilder: (context, index) {
                  FeesPayment feesPayment = snapshot.data.feesPayments[index];

                  return ListTile(
                    title: Text(
                      feesPayment.feeStudentInfo.fullName ?? 'NA',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      "${feesPayment.createdAt ?? 'NA'}",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  );
                },
              );
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          }
        },
      ),
    );
  }
}
