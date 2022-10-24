import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infixedu/screens/wallet/student/controller/student_wallet_controller.dart';
import 'package:infixedu/screens/wallet/student/model/Wallet.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/CustomBottomSheet.dart';
import 'package:infixedu/utils/CustomSnackBars.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:intl/intl.dart';

class StudentWalletTransactions extends StatefulWidget {
  const StudentWalletTransactions({Key key}) : super(key: key);

  @override
  State<StudentWalletTransactions> createState() =>
      _StudentWalletTransactionsState();
}

class _StudentWalletTransactionsState extends State<StudentWalletTransactions> {
  final StudentWalletController _controller =
      Get.put(StudentWalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'My Wallet'),
      body: Obx(
        () {
          if (_controller.isWalletLoading.value) {
            return Container(
                alignment: Alignment.center,
                child: CupertinoActivityIndicator());
          } else {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff7C32FF),
                                Color(0xffC738D8),
                              ],
                            )),
                        child: Text(
                          "Balance: ${_controller.wallet.value.currencySymbol}${_controller.wallet.value.myBalance}",
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _controller.file = File("").obs;
                          _controller.amountController.clear();
                          _controller.paymentNoteController.clear();
                          _controller.selectedPaymentMethod =
                              "Select Payment Method".tr.obs;
                          getDialog();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff7C32FF),
                                  Color(0xffC738D8),
                                ],
                              )),
                          child: Text(
                            "Add Balance",
                            style:
                                Theme.of(context).textTheme.subtitle2.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text('Date'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        )),
                              ),
                              Expanded(
                                child: Text('Method'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        )),
                              ),
                              Expanded(
                                child: Text('Amount'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        )),
                              ),
                              Expanded(
                                child: Text('Status'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RefreshIndicator(
                          onRefresh: () async {
                            await _controller.getMyWallet();
                          },
                          child: ListView.builder(
                            itemCount: _controller
                                .wallet.value.walletTransactions.length,
                            shrinkWrap: true,
                            itemBuilder: ((context, index) {
                              WalletTransaction walletTransaction = _controller
                                  .wallet.value.walletTransactions[index];
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                            '${DateFormat.yMMMd().format(DateTime.parse(walletTransaction.createdAt.toString())).toString()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4),
                                      ),
                                      Expanded(
                                        child: Text(
                                            '${walletTransaction.paymentMethod}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4),
                                      ),
                                      Expanded(
                                        child: Text(
                                            '${walletTransaction.amount.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                            onTap: () {
                                              if (walletTransaction.status ==
                                                  "reject") {
                                                CustomSnackBar().snackBarWarning(
                                                    "${walletTransaction.rejectNote}");
                                              }
                                            },
                                            child: getStatus(
                                                walletTransaction.status)),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  getStatus(String status) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: status == "approve"
              ? Colors.green
              : status == "reject"
                  ? Colors.amber
                  : Colors.red,
          borderRadius: BorderRadius.circular(5)),
      child: Text(
        '${status.capitalizeFirst}',
        style: Theme.of(context).textTheme.headline4.copyWith(
              color: status == "approve"
                  ? Colors.white
                  : status == "reject"
                      ? Colors.blueGrey
                      : Colors.white,
            ),
      ),
    );
  }

  getDialog() {
    Get.bottomSheet(
      CustomBottomSheet(
        title: "Add Balance",
        initialChildSize: 0.7,
        children: <Widget>[
          TextField(
            style: Theme.of(context).textTheme.headline4,
            controller: _controller.amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^(?!\.)(\d+)?\.?\d{0,2}'))
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: "Amount".tr,
              labelText: "Amount".tr,
              hintStyle: Theme.of(context).textTheme.headline4,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Obx(() {
            return DropdownButton(
              elevation: 0,
              isExpanded: true,
              hint: Text(
                "Select Payment Method".tr,
                style: Theme.of(context).textTheme.headline4,
              ),
              items: _controller.wallet.value.paymentMethods.map((item) {
                return DropdownMenuItem<String>(
                  value: item.method,
                  child: Text(
                    item.method,
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
            if (_controller.selectedPaymentMethod.value ==
                "Select Payment Method") {
              return SizedBox.shrink();
            } else {
              if (_controller.isBank.value) {
                return DropdownButton(
                  elevation: 0,
                  isExpanded: true,
                  hint: Text(
                    "Select Bank".tr,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  items: _controller.wallet.value.bankAccounts.map((item) {
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
            }
          }),
          Obx(() {
            if (_controller.selectedPaymentMethod.value ==
                "Select Payment Method") {
              return SizedBox.shrink();
            } else {
              if (_controller.isCheque.value || _controller.isBank.value) {
                return Column(
                  children: [
                    TextField(
                      style: Theme.of(context).textTheme.headline4,
                      controller: _controller.paymentNoteController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: "Note".tr,
                        hintStyle: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        _controller.pickDocument();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black.withOpacity(0.3)),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Obx(() {
                                print(_controller.file.value);
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    _controller.file.value == null ||
                                            _controller.file.value.path == ""
                                        ? _controller.isBank.value == true
                                            ? 'Select Bank payment slip'.tr
                                            : 'Select Cheque payment slip'.tr
                                        : _controller.file.value.path
                                            .split('/')
                                            .last,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                    maxLines: 2,
                                  ),
                                );
                              }),
                            ),
                            Text(
                              'Browse',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                    decoration: TextDecoration.underline,
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
            }
          }),
          Obx(() {
            return _controller.selectedPaymentMethod.value !=
                    "Select Payment Method"
                ? GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (_controller.isPaymentProcessing.value) {
                        return;
                      } else {
                        if (_controller.selectedPaymentMethod.value == "Bank" ||
                            _controller.selectedPaymentMethod.value ==
                                "Cheque") {
                          if (_controller.file.value == null) {
                            CustomSnackBar().snackBarWarning(
                              "Select a payment slip first".tr,
                            );
                          } else {
                            _controller.submitPayment(
                              file: _controller.file.value,
                            );
                          }
                        } else {
                          _controller.submitPayment(context: context);
                        }
                      }
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width * .5,
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: Utils.gradientBtnDecoration,
                        child: !_controller.isPaymentProcessing.value
                            ? Text(
                                "Submit".tr,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(color: Colors.white),
                              )
                            : CircularProgressIndicator(
                                color: Colors.white,
                              ),
                      ),
                    ),
                  )
                : SizedBox.shrink();
          })
        ],
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      persistent: true,
    );
  }
}
