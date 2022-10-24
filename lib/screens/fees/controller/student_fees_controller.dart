import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/controller/user_controller.dart';
import 'package:infixedu/screens/fees/paymentGateway/RazorPay/razorpay_service.dart';
import 'package:infixedu/screens/fees/paymentGateway/khaltiPayment/khalti_payment_screen.dart';
import 'package:infixedu/screens/fees/paymentGateway/paypal/paypal_payment.dart';
import 'package:infixedu/screens/fees/paymentGateway/stripe/stripe_payment.dart';
import 'package:infixedu/utils/CustomSnackBars.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/FeesRecord.dart';
import 'package:infixedu/screens/fees/model/StudentAddPaymentModel.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

class StudentFeesController extends GetxController {
  final UserController userController = Get.put(UserController());

  Rx<FeesRecordList> feesRecordList = FeesRecordList().obs;

  Rx<bool> isFeesLoading = false.obs;

  Rx<bool> isLoading = false.obs;

  Rx<StudentAddPaymentModel> addPaymentModel = StudentAddPaymentModel().obs;

  Rx<double> addInWallet = 0.0.obs;

  var addWalletList = [].obs;

  var amountList = [].obs;

  var paidAmountList = [].obs;

  var dueList = [].obs;

  Rx<double> totalPaidAmount = 0.0.obs;

  var noteList = [].obs;

  var feeTypeList = [].obs;

  Rx<String> selectedPaymentMethod = "Select Payment Method".tr.obs;

  Rx<BankAccount> selectedBank = BankAccount().obs;

  Rx<bool> isCheque = false.obs;

  Rx<bool> isBank = false.obs;

  Rx<bool> isPaymentProcessing = false.obs;

  dio.Dio _dio = dio.Dio();

  TextEditingController paymentNoteController = TextEditingController();

  final plugin = PaystackPlugin();

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

  Future submitPayment({File file, BuildContext context}) async {
    if (selectedPaymentMethod.value == "Select Payment Method".tr) {
      CustomSnackBar().snackBarWarning("Select a Payment method first!".tr);
    } else {
      if (selectedPaymentMethod.value == "Cheque") {
        final paymentData = dio.FormData.fromMap({
          "wallet_balance":
              addPaymentModel.value.invoiceInfo.studentInfo.user.walletBalance,
          "add_wallet": addWalletList.reduce((a, b) => a + b),
          "payment_method": selectedPaymentMethod.value,
          "payment_note": "${paymentNoteController.text}",
          "file": await dio.MultipartFile.fromFile(file.path),
          "invoice_id": addPaymentModel.value.invoiceInfo.id,
          "student_id": addPaymentModel.value.invoiceInfo.recordId,
          "fees_type[]": feeTypeList,
          "amount[]": amountList,
          "due[]": dueList,
          "extraAmount[]": addWalletList,
          "paid_amount[]": paidAmountList,
          "note[]": noteList,
          "total_paid_amount": totalPaidAmount.value
        });
        await processPayment(paymentData);
      } else if (selectedPaymentMethod.value == "Bank") {
        final paymentData = dio.FormData.fromMap({
          "wallet_balance":
              addPaymentModel.value.invoiceInfo.studentInfo.user.walletBalance,
          "add_wallet": addWalletList.reduce((a, b) => a + b),
          "payment_method": selectedPaymentMethod.value,
          "bank": "${selectedBank.value.id}",
          "payment_note": "${paymentNoteController.text}",
          "file": await dio.MultipartFile.fromFile(file.path),
          "invoice_id": addPaymentModel.value.invoiceInfo.id,
          "student_id": addPaymentModel.value.invoiceInfo.recordId,
          "fees_type[]": feeTypeList,
          "amount[]": amountList,
          "due[]": dueList,
          "extraAmount[]": addWalletList,
          "paid_amount[]": paidAmountList,
          "note[]": noteList,
          "total_paid_amount": totalPaidAmount.value
        });
        await processPayment(paymentData);
      } else if (selectedPaymentMethod.value == "Wallet") {
        final paymentData = dio.FormData.fromMap({
          "wallet_balance":
              addPaymentModel.value.invoiceInfo.studentInfo.user.walletBalance,
          "add_wallet": addWalletList.reduce((a, b) => a + b),
          "payment_method": selectedPaymentMethod.value,
          "invoice_id": addPaymentModel.value.invoiceInfo.id,
          "student_id": addPaymentModel.value.invoiceInfo.recordId,
          "fees_type[]": feeTypeList,
          "amount[]": amountList,
          "due[]": dueList,
          "extraAmount[]": addWalletList,
          "paid_amount[]": paidAmountList,
          "note[]": noteList,
          "total_paid_amount": totalPaidAmount.value
        });

        await processPayment(paymentData);
      } else {
        final paymentData = dio.FormData.fromMap({
          "wallet_balance":
              addPaymentModel.value.invoiceInfo.studentInfo.user.walletBalance,
          "add_wallet": addWalletList.reduce((a, b) => a + b),
          "payment_method": selectedPaymentMethod.value,
          "invoice_id": addPaymentModel.value.invoiceInfo.id,
          "student_id": addPaymentModel.value.invoiceInfo.recordId,
          "fees_type[]": feeTypeList,
          "amount[]": amountList,
          "due[]": dueList,
          "extraAmount[]": addWalletList,
          "paid_amount[]": paidAmountList,
          "note[]": noteList,
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
          .post(InfixApi.studentPaymentStore,
              data: formData,
              options: dio.Options(
                headers: Utils.setHeader(userController.token.value.toString()),
              ))
          .then((value) async {
        log(value.toString());
        if (value.statusCode == 200) {
          if (selectedPaymentMethod.value == "Wallet" ||
              selectedPaymentMethod.value == "Cheque" ||
              selectedPaymentMethod.value == "Bank") {
            isPaymentProcessing(false);
            await fetchFeesRecord(userController.studentId.value,
                userController.studentRecord.value.records.first.id);
            Get.back();
            CustomSnackBar().snackBarSuccess("Payment Added".tr);
          } else {
            data = new Map<String, dynamic>.from(value.data);

            if (selectedPaymentMethod.value == "PayPal") {
              Get.to(() => PaypalPayment(
                    fee: "${data['description']}",
                    amount: "${data['amount']}",
                    onFinish: (onFinish) async {
                      await confirmPaymentCallBack(
                          data['transcationId'].toString());
                    },
                  ));
            } else if (selectedPaymentMethod.value == "Stripe") {
              Get.to(() => StripePaymentScreen(
                    id: addPaymentModel.value.invoiceInfo.studentInfo.user.id
                        .toString(),
                    paidBy: addPaymentModel
                        .value.invoiceInfo.studentInfo.user.id
                        .toString(),
                    email: addPaymentModel
                        .value.invoiceInfo.studentInfo.user.email,
                    method: 'Stripe Payment',
                    amount:
                        double.parse("${data['amount']}").toStringAsFixed(2),
                    onFinish: (onFinish) async {
                      await confirmPaymentCallBack(
                          data['transcationId'].toString());
                    },
                  ));
            } else if (selectedPaymentMethod.value == "Paystack") {
              final finalAmount =
                  (double.parse("${data['amount']}") * 100).toInt();
              log(finalAmount.toString());
              Charge charge = Charge()
                ..amount = finalAmount
                ..currency = 'ZAR'
                ..reference = data['transcationId'].toString()
                ..email =
                    addPaymentModel.value.invoiceInfo.studentInfo.user.email ??
                        "";
              log(charge.toString());
              CheckoutResponse response = await plugin.checkout(
                context,
                method: CheckoutMethod.card,
                charge: charge,
              );

              if (response.status == true) {
                print(response);
                print(response.reference);
                await confirmPaymentCallBack(data['transcationId'].toString());
              } else {
                isPaymentProcessing.value = false;
                CustomSnackBar().snackBarError(response.message.toString());
              }
            } else if (selectedPaymentMethod.value == "Khalti") {
              Get.to(() => KhaltiInvoicePayment(
                    method: "${data['description']}",
                    amount: "${data['amount']}",
                  ));
            } else if (selectedPaymentMethod.value == "Razorpay") {
              await callRazorPayService(data['amount'], data['transcationId']);
            }

            // await confirmPaymentCallBack(data['transcationId'].toString());
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

  Future confirmPaymentCallBack(String transactionId) async {
    try {
      var data;
      final response = await _dio.get(
          InfixApi.studentPaymentSuccessCallback + "/Fees/$transactionId",
          options: dio.Options(
            headers: Utils.setHeader(userController.token.value.toString()),
          ));

      // log("Callback response -> $data");

      if (response.statusCode == 200) {
        data = new Map<String, dynamic>.from(response.data);

        isPaymentProcessing(false);
        await fetchFeesRecord(userController.studentId.value,
            userController.studentRecord.value.records.first.id);
        Get.back();
        CustomSnackBar().snackBarSuccess(data['message']);
      } else {
        data = new Map<String, dynamic>.from(response.data);
        isPaymentProcessing(false);
        CustomSnackBar().snackBarSuccess(data.toString());
      }
    } catch (e) {
      isPaymentProcessing(false);
    }
  }

  Future callRazorPayService(String amount, trxId) async {
    await RazorpayServices().openRazorpay(
      razorpayKey: "$razorPayApiKey",
      contactNumber:
          addPaymentModel.value.invoiceInfo.studentInfo.user.phoneNumber ?? "",
      emailId: addPaymentModel.value.invoiceInfo.studentInfo.user.email ?? "",
      amount: double.parse(amount.toString()),
      userName: "",
      successListener: (PaymentResponse paymentResponse) async {
        if (paymentResponse.paymentStatus) {
          await confirmPaymentCallBack(trxId.toString());
        }
      },
      failureListener: (PaymentResponse paymentResponse) {
        if (!paymentResponse.paymentStatus) {
          isPaymentProcessing.value = false;
          CustomSnackBar().snackBarError(paymentResponse.message);
        }
      },
    );
  }

  Future<StudentAddPaymentModel> getFeesInvoice(invoiceId) async {
    try {
      isLoading(true);
      final response = await http.get(
          Uri.parse(InfixApi.studentFeesAddPayment(invoiceId)),
          headers: Utils.setHeader(userController.token.toString()));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        addPaymentModel.value = StudentAddPaymentModel.fromJson(jsonData);

        if (addPaymentModel.value.bankAccounts.length != 0) {
          selectedBank.value = addPaymentModel.value.bankAccounts.first;
        }

        addPaymentModel.value.paymentMethods.insert(
            0, FeesPaymentMethod(paymentMethod: "Select Payment Method".tr));

        addInWallet.value = 0.0;
        addWalletList.clear();
        amountList.clear();
        paidAmountList.clear();
        dueList.clear();
        noteList.clear();
        feeTypeList.clear();
        totalPaidAmount.value = 0.0;
        isPaymentProcessing.value = false;

        addPaymentModel.value.invoiceDetails.forEach((element) {
          addWalletList.add(0.0);

          feeTypeList.add(element.feesType);

          amountList.add(element.amount);

          dueList.add(element.dueAmount);

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
    return addPaymentModel.value;
  }

  Future<FeesRecordList> fetchFeesRecord(studentId, recordId) async {
    try {
      isFeesLoading(true);
      final response = await http.get(
          Uri.parse(InfixApi.feesRecordList + "/$studentId/$recordId"),
          headers: Utils.setHeader(userController.token.value.toString()));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        feesRecordList.value = FeesRecordList.fromJson(jsonData['records']);

        print(feesRecordList.value);
        isFeesLoading(false);
      } else {
        isFeesLoading(false);
        throw Exception('failed to load');
      }
    } catch (e) {
      print(e.toString());
    }
    return feesRecordList.value;
  }

  @override
  void onInit() {
    fetchFeesRecord(userController.studentId.value,
        userController.studentRecord.value.records.first.id);
    plugin.initialize(publicKey: payStackPublicKey);
    super.onInit();
  }
}
