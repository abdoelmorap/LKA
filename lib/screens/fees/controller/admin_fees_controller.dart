import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/utils/CustomSnackBars.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/FeesAdminAddPaymentModel.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

class AdminFeesController extends GetxController {
  Rx<String> _token = "".obs;

  Rx<String> get token => this._token;

  Rx<String> _id = "".obs;

  Rx<String> get id => this._id;

  Rx<bool> isLoading = false.obs;

  Rx<FeesAdminAddPaymentModel> feesAdminAddPaymentModel =
      FeesAdminAddPaymentModel().obs;

  Rx<BankAccount> selectedBank = BankAccount().obs;

  Rx<double> addInWallet = 0.0.obs;

  var addWalletList = [].obs;

  var amountList = [].obs;

  var paidAmountList = [].obs;

  var dueList = [].obs;

  Rx<double> totalPaidAmount = 0.0.obs;

  var noteList = [].obs;

  var feeTypeList = [].obs;
  var weaverList = [].obs;
  var fineList = [].obs;

  Rx<bool> isCheque = false.obs;

  Rx<bool> isBank = false.obs;

  Rx<String> selectedPaymentMethod = "Select Payment Method".tr.obs;

  Rx<bool> isPaymentProcessing = false.obs;

  dio.Dio _dio = dio.Dio();

  TextEditingController paymentNoteController = TextEditingController();

  Future<FeesAdminAddPaymentModel> getFeesInvoice(invoiceId) async {
    isLoading(true);
    await getIdToken().then((value) async {
      try {
        final response = await http.get(
            Uri.parse(InfixApi.adminFeesAddPayment + '/$invoiceId'),
            headers: Utils.setHeader(_token.value.toString()));

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);

          feesAdminAddPaymentModel.value =
              FeesAdminAddPaymentModel.fromJson(jsonData);

          if (feesAdminAddPaymentModel.value.bankAccounts.length != 0) {
            selectedBank.value =
                feesAdminAddPaymentModel.value.bankAccounts.first;
          }

          feesAdminAddPaymentModel.value.paymentMethods
              .insert(0, PaymentMethod(method: "Select Payment Method".tr));

          addInWallet.value = 0.0;
          addWalletList.clear();
          amountList.clear();
          paidAmountList.clear();
          dueList.clear();
          noteList.clear();
          feeTypeList.clear();
          weaverList.clear();
          fineList.clear();
          totalPaidAmount.value = 0.0;
          isPaymentProcessing.value = false;

          feesAdminAddPaymentModel.value.invoiceDetails.forEach((element) {
            addWalletList.add(0.0);

            feeTypeList.add(element.feesType);

            amountList.add(element.amount);

            dueList.add(element.dueAmount);

            weaverList.add(element.weaver);

            fineList.add(element.fine);

            paidAmountList.add(0.0);

            noteList.add(" ");
          });

          isLoading(false);
        } else {
          throw Exception('Failed to load');
        }
        isLoading(false);
      } catch (e) {
        isLoading(false);
      }
    });

    return feesAdminAddPaymentModel.value;
  }

  Future submitPayment({File file, BuildContext context}) async {
    if (selectedPaymentMethod.value == "Select Payment Method".tr) {
      CustomSnackBar().snackBarWarning("Select a Payment method first!".tr);
    } else {
      if (selectedPaymentMethod.value == "Cheque") {
        final paymentData = dio.FormData.fromMap({
          "wallet_balance": feesAdminAddPaymentModel.value.walletBalance,
          "add_wallet": addWalletList.reduce((a, b) => a + b),
          "payment_method": selectedPaymentMethod.value,
          "payment_note": "${paymentNoteController.text}",
          "file": await dio.MultipartFile.fromFile(file.path),
          "invoice_id": feesAdminAddPaymentModel.value.invoiceInfo.id,
          "student_id": feesAdminAddPaymentModel.value.invoiceInfo.recordId,
          "fees_type[]": feeTypeList,
          "amount[]": amountList,
          "due[]": dueList,
          "extraAmount[]": addWalletList,
          "paid_amount[]": paidAmountList,
          "note[]": noteList,
          "weaver[]": weaverList,
          "fine[]": fineList,
          "total_paid_amount": totalPaidAmount.value
        });
        await processPayment(paymentData);
      } else if (selectedPaymentMethod.value == "Bank") {
        final paymentData = dio.FormData.fromMap({
          "wallet_balance": feesAdminAddPaymentModel.value.walletBalance,
          "add_wallet": addWalletList.reduce((a, b) => a + b),
          "payment_method": selectedPaymentMethod.value,
          "bank": "${selectedBank.value.id}",
          "payment_note": "${paymentNoteController.text}",
          "file": await dio.MultipartFile.fromFile(file.path),
          "invoice_id": feesAdminAddPaymentModel.value.invoiceInfo.id,
          "student_id": feesAdminAddPaymentModel.value.invoiceInfo.recordId,
          "fees_type[]": feeTypeList,
          "amount[]": amountList,
          "due[]": dueList,
          "extraAmount[]": addWalletList,
          "paid_amount[]": paidAmountList,
          "note[]": noteList,
          "weaver[]": weaverList,
          "fine[]": fineList,
          "total_paid_amount": totalPaidAmount.value
        });
        await processPayment(paymentData);
      } else if (selectedPaymentMethod.value == "Cash") {
        final paymentData = dio.FormData.fromMap({
          "wallet_balance": feesAdminAddPaymentModel.value.walletBalance,
          "add_wallet": addWalletList.reduce((a, b) => a + b),
          "payment_method": selectedPaymentMethod.value,
          "invoice_id": feesAdminAddPaymentModel.value.invoiceInfo.id,
          "student_id": feesAdminAddPaymentModel.value.invoiceInfo.recordId,
          "fees_type[]": feeTypeList,
          "amount[]": amountList,
          "due[]": dueList,
          "extraAmount[]": addWalletList,
          "paid_amount[]": paidAmountList,
          "note[]": noteList,
          "weaver[]": weaverList,
          "fine[]": fineList,
          "total_paid_amount": totalPaidAmount.value
        });
        await processPayment(paymentData);
      }
    }
  }

  Future processPayment(dio.FormData formData, {BuildContext context}) async {
    print('on processPayment');
    log(formData.fields.toString());
    // return;
    try {
      isPaymentProcessing(true);
      var data;
      await _dio
          .post(InfixApi.adminFeesAddPaymentStore,
              data: formData,
              options: dio.Options(
                headers: Utils.setHeader(_token.value.toString()),
              ))
          .then((value) async {
        log(value.toString());
        if (value.statusCode == 200) {
          if (selectedPaymentMethod.value == "Cash" ||
              selectedPaymentMethod.value == "Cheque" ||
              selectedPaymentMethod.value == "Bank") {
            isPaymentProcessing(false);

            Get.back();
            CustomSnackBar().snackBarSuccess("Payment Added".tr);
          }
        } else {
          data = new Map<String, dynamic>.from(value.data);
          log(data.toString());
        }
      }).catchError((error) {
        if (error is dio.DioError) {
          isPaymentProcessing(false);

          final errorData = new Map<String, dynamic>.from(error.response.data);

          String combinedMessage = "";

          errorData["errors"].forEach((key, messages) {
            for (var message in messages)
              combinedMessage = combinedMessage + "$message\n";
          });
          CustomSnackBar().snackBarError("$combinedMessage");

          print("error ${error.toString()}");
        }
      });
    } catch (e) {
    } finally {}
  }

  void chequeBankOrOthers() {
    isCheque.value = false;
    isBank.value = false;
    if (selectedPaymentMethod.value == "Cheque") {
      isCheque.value = true;
    } else if (selectedPaymentMethod.value == "Bank") {
      isBank.value = true;
    } else {
      isCheque.value = false;
      isBank.value = false;
    }
  }

  Future getIdToken() async {
    await Utils.getStringValue('token').then((value) async {
      _token.value = value;
      await Utils.getStringValue('id').then((value) {
        _id.value = value;
      });
    });
  }

  @override
  void onInit() {
    getIdToken();
    super.onInit();
  }
}
