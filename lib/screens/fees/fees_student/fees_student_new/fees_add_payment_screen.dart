import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/screens/fees/controller/student_fees_controller.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/CustomSnackBars.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/screens/fees/model/StudentAddPaymentModel.dart';
import 'package:intl/intl.dart';

class FeesAddPaymentScreen extends StatefulWidget {
  final int invoiceId;
  final Function updateData;
  FeesAddPaymentScreen({this.invoiceId, this.updateData});

  @override
  _FeesAddPaymentScreenState createState() => _FeesAddPaymentScreenState();
}

class _FeesAddPaymentScreenState extends State<FeesAddPaymentScreen> {
  final StudentFeesController _controller = Get.put(StudentFeesController());

  @override
  void initState() {
    _controller.getFeesInvoice(widget.invoiceId);
    super.initState();
  }

  File _file;

  Future pickDocument() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path);
      });
    } else {
      Utils.showToast('Cancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Add Fees Payment',
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else {
          return Stack(
            children: [
              _controller.isPaymentProcessing.value
                  ? Center(child: CircularProgressIndicator())
                  : Container(),
              Opacity(
                opacity: _controller.isPaymentProcessing.value ? 0.2 : 1.0,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
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
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Invoice'.tr +
                                  ": ${_controller.addPaymentModel.value.invoiceInfo.invoiceId}",
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Due Date'.tr +
                                  ": ${DateFormat.yMMMd().format(_controller.addPaymentModel.value.invoiceInfo.dueDate)}",
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Wallet Balance'.tr +
                                  ": ${_controller.addPaymentModel.value.invoiceInfo.studentInfo.user.walletBalance.toStringAsFixed(2)}",
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Obx(() {
                              if (_controller.addWalletList.length > 0) {
                                return Text(
                                  'Add in Wallet'.tr +
                                      ": ${_controller.addWalletList.reduce((a, b) => a + b).toStringAsFixed(2)}",
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(fontWeight: FontWeight.bold),
                                );
                              } else {
                                return Text(
                                  'Add in Wallet'.tr + ": 0.00",
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(fontWeight: FontWeight.bold),
                                );
                              }
                            }),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      'Fees List'.tr,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: _controller
                          .addPaymentModel.value.invoiceDetails.length,
                      itemBuilder: (context, index) {
                        InvoiceDetail invoiceDetails = _controller
                            .addPaymentModel.value.invoiceDetails[index];

                        return FeesListRow(
                            invoiceDetails: invoiceDetails, index: index);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      return DropdownButton(
                        elevation: 0,
                        isExpanded: true,
                        hint: Text(
                          "Select Payment Method.".tr,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        items: _controller.addPaymentModel.value.paymentMethods
                            .map((item) {
                          return DropdownMenuItem<String>(
                            value: item.paymentMethod,
                            child: Text(
                              item.paymentMethod,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          );
                        }).toList(),
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(fontSize: 13.0),
                        onChanged: (value) {
                          _controller.selectedPaymentMethod.value = value;

                          _controller.chequeBankOrOthers();
                        },
                        value: _controller.selectedPaymentMethod.value,
                      );
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      if (_controller.isBank.value) {
                        return DropdownButton(
                          elevation: 0,
                          isExpanded: true,
                          hint: Text(
                            "Select Bank".tr,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          items: _controller.addPaymentModel.value.bankAccounts
                              .map((item) {
                            return DropdownMenuItem<BankAccount>(
                              value: item,
                              child: Text(
                                "${item.bankName} (${item.accountNumber})",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            );
                          }).toList(),
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 13.0),
                          onChanged: (value) {
                            _controller.selectedBank.value = value;
                          },
                          value: _controller.selectedBank.value,
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
                    Obx(() {
                      if (_controller.isCheque.value ||
                          _controller.isBank.value) {
                        return Column(
                          children: [
                            TextField(
                              style: Theme.of(context).textTheme.headline4,
                              controller: _controller.paymentNoteController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "Note".tr,
                                hintStyle:
                                    Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                pickDocument();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.3)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          _file == null
                                              ? _controller.isBank.value == true
                                                  ? 'Select Bank payment slip'
                                                      .tr
                                                  : 'Select Cheque payment slip'
                                                      .tr
                                              : _file.path.split('/').last,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .copyWith(),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Browse',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (_controller.selectedPaymentMethod.value == "Bank" ||
                            _controller.selectedPaymentMethod.value ==
                                "Cheque") {
                          if (_file == null) {
                            CustomSnackBar().snackBarWarning(
                              "Select a payment slip first".tr,
                            );
                          } else {
                            _controller.submitPayment(
                              file: _file,
                            );
                          }
                        } else {
                          _controller.submitPayment(context: context);
                        }
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .5,
                          height: 50.0,
                          alignment: Alignment.center,
                          decoration: Utils.gradientBtnDecoration,
                          child: Text(
                            "Pay".tr,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}

class FeesListRow extends StatefulWidget {
  final InvoiceDetail invoiceDetails;
  final int index;
  FeesListRow({this.invoiceDetails, this.index});
  @override
  _FeesListRowState createState() => _FeesListRowState();
}

class _FeesListRowState extends State<FeesListRow> {
  final StudentFeesController _controller = Get.put(StudentFeesController());

  double dueAmount;
  double currentDue;

  @override
  void initState() {
    dueAmount = widget.invoiceDetails.dueAmount;
    currentDue = widget.invoiceDetails.dueAmount;
    print(dueAmount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        widget.invoiceDetails.feesTypeName ?? 'NA',
        style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14),
      ),
      subtitle: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Amount'.tr,
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
                        widget.invoiceDetails.amount.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Due'.tr,
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
                        double.parse(currentDue.toString()).toStringAsFixed(2),
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Weaver'.tr,
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
                        widget.invoiceDetails.weaver.toStringAsFixed(2),
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Fine'.tr,
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
                        widget.invoiceDetails.fine.toStringAsFixed(2),
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: TextField(
                        maxLines: 1,
                        enabled: true,
                        onChanged: (text) {
                          setState(() {
                            if (text.length > 0) {
                              var currentText = double.parse(text.toString());

                              currentDue = dueAmount - currentText;

                              if (currentText >= dueAmount) {
                                currentDue = 0.0;

                                _controller.addWalletList[widget.index] =
                                    currentText - dueAmount;
                              } else {
                                _controller.addWalletList[widget.index] = 0;
                              }

                              _controller.paidAmountList[widget.index] =
                                  currentText;

                              _controller.dueList[widget.index] = currentDue;

                              _controller.totalPaidAmount.value = _controller
                                  .paidAmountList
                                  .reduce((previousValue, element) =>
                                      previousValue + element);
                            } else {
                              currentDue = widget.invoiceDetails.dueAmount;
                            }
                          });
                        },
                        style: Theme.of(context).textTheme.headline4,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(?!\.)(\d+)?\.?\d{0,2}')),
                        ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: "Paid Amount".tr,
                          hintStyle: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: TextField(
                        maxLines: 1,
                        enabled: true,
                        style: Theme.of(context).textTheme.headline4,
                        onChanged: (text) {
                          if (text.length > 0) {
                            _controller.noteList[widget.index] = text;
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: "Note".tr,
                          hintStyle: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
