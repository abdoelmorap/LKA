import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/screens/fees/fees_admin/fees_admin_new/fee_transactions_view.dart';
import 'package:infixedu/screens/fees/fees_admin/fees_admin_new/fees_invoice_view.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/FeesRecord.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/utils/widget/custom_search_delegate.dart';

class FeesInvoiceScreen extends StatefulWidget {
  @override
  _FeesInvoiceScreenState createState() => _FeesInvoiceScreenState();
}

class _FeesInvoiceScreenState extends State<FeesInvoiceScreen> {
  Future<FeesRecordList> fees;

  String _token;

  TextEditingController titleController, descripController;

  List<FeesRecord> invoices = [];

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
        fees = getFeesInvoice();
      });
    });
  }

  Future<FeesRecordList> getFeesInvoice() async {
    final response = await http.get(Uri.parse(InfixApi.adminFeesInvoiceList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      invoices.addAll(
          FeesRecordList.fromJson(jsonData['studentInvoices']).feesRecords);
      return FeesRecordList.fromJson(jsonData['studentInvoices']);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            height: 110.h,
            padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Color(0xFF93CFC4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: Container(
                    height: 70.h,
                    width: 70.w,
                    child: IconButton(
                        tooltip: 'Back',
                        icon: Icon(
                          Icons.arrow_back,
                          size: ScreenUtil().setSp(20),
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      "Fees Invoice".tr,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                IconButton(
                  onPressed: () => showSearch(
                    context: context,
                    delegate: SearchPage<FeesRecord>(
                      items: invoices,
                      searchLabel: 'Search fees invoices',
                      suggestion: Center(
                        child: Text('Filter people by name, class or section'),
                      ),
                      searchStyle: Get.textTheme.subtitle1.copyWith(
                        color: Colors.black,
                      ),
                      barTheme: Theme.of(context).copyWith(
                        textTheme: Theme.of(context).textTheme.copyWith(
                            headline6: Theme.of(context).textTheme.headline6),
                        appBarTheme: AppBarTheme(
                          color: Colors.white,
                          elevation: 0,
                        ),
                        iconTheme: IconThemeData(
                          color: Theme.of(context)
                              .textTheme
                              .headline6
                              .color, //change your color here
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          hintStyle: Theme.of(context).textTheme.headline6,
                          focusedErrorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                      ),
                      failure: Center(
                        child: Utils.noDataWidget(),
                      ),
                      filter: (record) => [
                        record.student,
                        record.recordClass,
                        record.section,
                        record.status
                      ],
                      builder: (record) => ListTile(
                        onTap: () {
                          Get.to(() => FeeInvoiceDetailsView(
                                invoiceId: record.id,
                              ));
                        },
                        title: Text(
                          record.student +
                                  " (${record.recordClass} - ${record.section})" ??
                              'NA',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: 14),
                        ),
                        subtitle: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    record.date,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(fontSize: 14),
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
                                    if (record.status == "paid") {
                                      return [
                                        PopupMenuItem(
                                          value: 'view',
                                          child: Text('View'.tr),
                                        ),
                                        PopupMenuItem(
                                          value: 'view-transactions',
                                          child: Text('View Transactions'.tr),
                                        ),
                                      ];
                                    } else if (record.status == "partial") {
                                      return [
                                        PopupMenuItem(
                                          value: 'view',
                                          child: Text('View'.tr),
                                        ),
                                        PopupMenuItem(
                                          value: 'view-transactions',
                                          child: Text('View Transactions'.tr),
                                        ),
                                      ];
                                    } else {
                                      return [
                                        PopupMenuItem(
                                          value: 'view',
                                          child: Text('View'.tr),
                                        ),
                                        PopupMenuItem(
                                          value: 'view-transactions',
                                          child: Text('View Transactions'.tr),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Delete'.tr),
                                        )
                                      ];
                                    }
                                  },
                                  onSelected: (String value) async {
                                    if (value == 'view') {
                                      Get.to(() => FeeInvoiceDetailsView(
                                            invoiceId: record.id,
                                          ));
                                    } else if (value == 'edit') {
                                    } else if (value == 'delete') {
                                      final response = await http.post(
                                        Uri.parse(
                                            InfixApi.adminFeesInvoiceDelete),
                                        headers: Utils.setHeader(_token),
                                        body: jsonEncode({
                                          'id': record.id,
                                        }),
                                      );
                                      if (response.statusCode == 200) {
                                        Utils.showToast('Deleted successfully');

                                        setState(() {
                                          fees = getFeesInvoice();
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
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          double.parse(record.amount.toString())
                                              .toStringAsFixed(2),
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
                                          'Paid',
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          double.parse(
                                                  record.paidAmount.toString())
                                              .toStringAsFixed(2),
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
                                          'Balance',
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          double.parse(
                                                  record.balance.toString())
                                              .toStringAsFixed(2),
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
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        getStatus(record),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  icon: Icon(
                    Icons.search,
                    size: 25.sp,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: FutureBuilder<FeesRecordList>(
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
                  itemCount: snapshot.data.feesRecords.length,
                  itemBuilder: (context, index) {
                    FeesRecord feeRecord = snapshot.data.feesRecords[index];

                    return ListTile(
                      title: Text(
                        feeRecord.student +
                                " (${feeRecord.recordClass} - ${feeRecord.section})" ??
                            'NA',
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
                                  feeRecord.date,
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
                                  if (feeRecord.status == "paid") {
                                    return [
                                      PopupMenuItem(
                                        value: 'view',
                                        child: Text('View'.tr),
                                      ),
                                      PopupMenuItem(
                                        value: 'view-transactions',
                                        child: Text('View Transactions'.tr),
                                      ),
                                    ];
                                  } else if (feeRecord.status == "partial") {
                                    return [
                                      PopupMenuItem(
                                        value: 'view',
                                        child: Text('View'.tr),
                                      ),
                                      PopupMenuItem(
                                        value: 'view-transactions',
                                        child: Text('View Transactions'.tr),
                                      ),
                                    ];
                                  } else {
                                    return [
                                      PopupMenuItem(
                                        value: 'view',
                                        child: Text('View'.tr),
                                      ),
                                      PopupMenuItem(
                                        value: 'view-transactions',
                                        child: Text('View Transactions'.tr),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'.tr),
                                      ),
                                    ];
                                  }
                                },
                                onSelected: (String value) async {
                                  if (value == 'view') {
                                    Get.to(() => FeeInvoiceDetailsView(
                                          invoiceId: feeRecord.id,
                                        ));
                                  } else if (value == 'view-transactions') {
                                    Get.to(() => FeeTransactionView(
                                          invoiceId: feeRecord.id,
                                        ));
                                  } else if (value == 'edit') {
                                  } else if (value == 'delete') {
                                    final response = await http.post(
                                      Uri.parse(
                                          InfixApi.adminFeesInvoiceDelete),
                                      headers: Utils.setHeader(_token),
                                      body: jsonEncode({
                                        'id': feeRecord.id,
                                      }),
                                    );
                                    if (response.statusCode == 200) {
                                      Utils.showToast('Deleted successfully');

                                      setState(() {
                                        fees = getFeesInvoice();
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
                                                fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        double.parse(
                                                feeRecord.amount.toString())
                                            .toStringAsFixed(2),
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
                                        'Paid',
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        double.parse(
                                                feeRecord.paidAmount.toString())
                                            .toStringAsFixed(2),
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
                                        'Balance',
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        double.parse(
                                                feeRecord.balance.toString())
                                            .toStringAsFixed(2),
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
                                                fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      getStatus(feeRecord),
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
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
          },
        ),
      ),
    );
  }

  Widget getStatus(FeesRecord feesRecord) {
    if (feesRecord.balance == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.green),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Paid'.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if ((feesRecord.paidAmount == 0
            ? feesRecord.paidAmount
            : double.parse(feesRecord.paidAmount.toString())) >
        0.0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.amber),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Partial'.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (feesRecord.paidAmount == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.red),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'unpaid'.toUpperCase(),
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
}
