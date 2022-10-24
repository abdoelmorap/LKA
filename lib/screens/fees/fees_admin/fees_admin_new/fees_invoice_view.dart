import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/FeeInvoiceDetailsModel.dart';
import 'package:intl/intl.dart';

class FeeInvoiceDetailsView extends StatefulWidget {
  final int invoiceId;
  FeeInvoiceDetailsView({this.invoiceId});
  @override
  _FeeInvoiceDetailsViewState createState() => _FeeInvoiceDetailsViewState();
}

class _FeeInvoiceDetailsViewState extends State<FeeInvoiceDetailsView> {
  Future<FeeInvoiceDetailsModel> fees;
  String _token;

  FeeInvoiceDetailsModel feeInvoiceDetailsModel = FeeInvoiceDetailsModel();

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value;
        fees = getFeesInvoice();
      });
    });
    super.initState();
  }

  Future<FeeInvoiceDetailsModel> getFeesInvoice() async {
    final response = await http.get(
        Uri.parse(InfixApi.feesInvoiceView(widget.invoiceId)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      feeInvoiceDetailsModel = FeeInvoiceDetailsModel.fromJson(jsonData);

      return FeeInvoiceDetailsModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Fees Invoice',
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<FeeInvoiceDetailsModel>(
        future: fees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          } else {
            if (snapshot.hasData) {
              return ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        AppConfig.appLogo,
                        width: Get.width * 0.2,
                        height: Get.width * 0.2,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Invoice'.tr +
                                ": ${snapshot.data.invoiceInfo.invoiceId}",
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Create Date'.tr +
                                ": ${DateFormat.yMMMd().format(snapshot.data.invoiceInfo.createDate)}",
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Due Date'.tr +
                                ": ${DateFormat.yMMMd().format(snapshot.data.invoiceInfo.dueDate)}",
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: snapshot.data.invoiceDetails.length,
                    itemBuilder: (context, index) {
                      InvoiceDetail feeRecord =
                          snapshot.data.invoiceDetails[index];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          feeRecord.typeName ?? 'NA',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 14),
                        ),
                        subtitle: Column(
                          children: <Widget>[
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
                                          'Amount'.tr,
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
                                          'Weaver'.tr,
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
                                                  feeRecord.weaver.toString())
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
                                          'Fine'.tr,
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
                                                  feeRecord.fine.toString())
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
                                          'Paid'.tr,
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
                                                  feeRecord.subTotal.toString())
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
                                          'Total'.tr,
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
                                                  feeRecord.total.toString())
                                              .toStringAsFixed(2),
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
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
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount'.tr,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            double.parse(getGrandTotalAmount().toString())
                                .toStringAsFixed(2),
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Waiver'.tr,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            double.parse(getTotalWeiver().toString())
                                .toStringAsFixed(2),
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Fine'.tr,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            double.parse(getTotalFine().toString())
                                .toStringAsFixed(2),
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Paid'.tr,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            double.parse(getTotalPaidAmount().toString())
                                .toStringAsFixed(2),
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grand Total'.tr,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            double.parse(((getGrandTotalAmount() -
                                            getTotalWeiver()) +
                                        getTotalFine())
                                    .toString())
                                .toStringAsFixed(2),
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Due Balance'.tr,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            double.parse(getDueBalance().toString())
                                .toStringAsFixed(2),
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }

  getTotalFine() {
    double amount = 0.0;
    feeInvoiceDetailsModel.invoiceDetails.forEach((element) {
      amount += element.fine;
    });
    return amount;
  }

  getTotalWeiver() {
    double amount = 0.0;
    feeInvoiceDetailsModel.invoiceDetails.forEach((element) {
      amount += element.weaver;
    });
    return amount;
  }

  getTotalPaidAmount() {
    double amount = 0.0;
    feeInvoiceDetailsModel.invoiceDetails.forEach((element) {
      amount += element.subTotal;
    });
    return amount;
  }

  getGrandTotalAmount() {
    double amount = 0.0;

    feeInvoiceDetailsModel.invoiceDetails.forEach((element) {
      amount += element.amount;
    });
    return amount;
  }

  getDueBalance() {
    double amount = 0.0;

    feeInvoiceDetailsModel.invoiceDetails.forEach((element) {
      amount += element.total;
    });
    return amount;
  }
}
