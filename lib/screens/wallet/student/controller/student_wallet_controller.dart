import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/controller/user_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:infixedu/screens/fees/paymentGateway/RazorPay/razorpay_service.dart';
import 'package:infixedu/screens/fees/paymentGateway/khaltiPayment/khalti_payment_screen.dart';
import 'package:infixedu/screens/fees/paymentGateway/paypal/paypal_payment.dart';
import 'package:infixedu/screens/fees/paymentGateway/stripe/stripe_payment.dart';
import 'package:infixedu/screens/wallet/student/model/Wallet.dart';
import 'package:infixedu/utils/CustomSnackBars.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:http/http.dart' as http;

class StudentWalletController extends GetxController {
  RxBool isWalletLoading = false.obs;

  final UserController userController = Get.put(UserController());

  Rx<Wallet> wallet = Wallet().obs;

  Rx<String> selectedPaymentMethod = "Select Payment Method".tr.obs;

  Rx<BankAccount> selectedBank = BankAccount().obs;

  Rx<bool> isCheque = false.obs;

  Rx<bool> isBank = false.obs;

  Rx<bool> isPaymentProcessing = false.obs;

  dio.Dio _dio = dio.Dio();

  final plugin = PaystackPlugin();

  TextEditingController paymentNoteController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  Rx<File> file = File("").obs;

  Future pickDocument() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null) {
      file.value = File(result.files.single.path);
    } else {
      Utils.showToast('Cancelled');
    }
  }

  Future<Wallet> getMyWallet() async {
    isWalletLoading(true);
    try {
      final response = await http.get(
        Uri.parse(InfixApi.studentWallet),
        headers: Utils.setHeader(
          userController.token.value.toString(),
        ),
      );
      if (response.statusCode == 200) {
        var data = walletFromJson(response.body);

        isWalletLoading(false);
        wallet.value = data;

        if (wallet.value.bankAccounts.length != 0) {
          selectedBank.value = wallet.value.bankAccounts.first;
        }

        wallet.value.paymentMethods
            .insert(0, PaymentMethod(method: "Select Payment Method".tr));

        selectedPaymentMethod.value = wallet.value.paymentMethods.first.method;
      } else {
        throw Exception('Failed to load post');
      }
      return wallet.value;
    } catch (e) {
      isWalletLoading(false);
      throw Exception(e.toString());
    }
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

  Future submitPayment({File file, BuildContext context}) async {
    if (selectedPaymentMethod.value == "Select Payment Method".tr) {
      CustomSnackBar().snackBarWarning("Select a Payment method first!".tr);
    } else {
      if (selectedPaymentMethod.value == "Cheque") {
        final paymentData = dio.FormData.fromMap({
          "amount": amountController.value.text,
          "payment_method": "Cheque",
          "file": await dio.MultipartFile.fromFile(file.path),
          "note": paymentNoteController.value.text,
        });
        await processPayment(paymentData);
      } else if (selectedPaymentMethod.value == "Bank") {
        final paymentData = dio.FormData.fromMap({
          "amount": amountController.value.text,
          "payment_method": "Cheque",
          "file": await dio.MultipartFile.fromFile(file.path),
          "note": paymentNoteController.value.text,
        });
        await processPayment(paymentData);
      } else {
        final paymentData = dio.FormData.fromMap({
          "amount": amountController.value.text,
          "payment_method": selectedPaymentMethod.value,
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
          .post(InfixApi.addToWallet,
              data: formData,
              options: dio.Options(
                headers: Utils.setHeader(userController.token.value.toString()),
              ))
          .then((value) async {
        log(value.toString());
        if (value.statusCode == 200) {
          isPaymentProcessing(false);
          if (selectedPaymentMethod.value == "Cheque" ||
              selectedPaymentMethod.value == "Bank") {
            isPaymentProcessing(false);

            await getMyWallet();
            CustomSnackBar().snackBarSuccess("Payment Added".tr);
            Future.delayed(Duration(seconds: 4), () {
              Get.back();
            });
          } else {
            data = new Map<String, dynamic>.from(value.data);

            log("DATA=> $data");
            Get.back();
            if (selectedPaymentMethod.value == "PayPal") {
              Get.to(() => PaypalPayment(
                    fee: "${data['description']}",
                    amount: "${data['amount']}",
                    onFinish: (onFinish) async {
                      await confirmWalletPayment(
                          id: data['id'].toString(),
                          amount: double.parse(data['amount'].toString())
                              .toPrecision(2));
                    },
                  ));
            } else if (selectedPaymentMethod.value == "Stripe") {
              Get.to(() => StripePaymentScreen(
                    id: userController.studentId.value.toString(),
                    paidBy: _id.value.toString(),
                    email: _email.value.toString(),
                    method: 'Stripe Payment',
                    amount:
                        double.parse("${data['amount']}").toStringAsFixed(2),
                    onFinish: (onFinish) async {
                      await confirmWalletPayment(
                          id: data['id'].toString(),
                          amount: double.parse(data['amount'].toString())
                              .toPrecision(2));
                    },
                  ));
            } else if (selectedPaymentMethod.value == "Paystack") {
              final finalAmount =
                  (double.parse("${data['amount']}") * 100).toInt();
              log(finalAmount.toString());
              Charge charge = Charge()
                ..amount = finalAmount
                ..currency = 'ZAR'
                ..reference = data['transactionId'].toString()
                ..email = _email ?? "";
              log(charge.toString());
              CheckoutResponse response = await plugin.checkout(
                context,
                method: CheckoutMethod.card,
                charge: charge,
              );

              if (response.status == true) {
                print(response);
                print(response.reference);
                await confirmWalletPayment(
                    id: data['id'].toString(),
                    amount:
                        double.parse(data['amount'].toString()).toPrecision(2));
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
              await callRazorPayService(
                  double.parse(data['amount'].toString()).toPrecision(2),
                  data['id'].toString());
            }
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

  Future confirmWalletPayment({String id, dynamic amount}) async {
    Get.back();
    final formData = dio.FormData.fromMap({
      "id": id,
      "amount": amount,
    });

    try {
      isPaymentProcessing(true);
      await _dio
          .post(InfixApi.confirmWalletPayment,
              data: formData,
              options: dio.Options(
                headers: Utils.setHeader(userController.token.value.toString()),
              ))
          .then((value) async {
        log(value.toString());
        log(value.statusCode.toString());
        await getMyWallet();

        isPaymentProcessing(false);
      }).catchError((error) {
        isPaymentProcessing(false);
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

  Future callRazorPayService(double amount, trxId) async {
    await RazorpayServices().openRazorpay(
      razorpayKey: "$razorPayApiKey",
      contactNumber: _phone.value ?? "",
      emailId: _email.value ?? "",
      amount: double.parse(amount.toString()),
      userName: "",
      successListener: (PaymentResponse paymentResponse) async {
        if (paymentResponse.paymentStatus) {
          await confirmWalletPayment(
              id: trxId.toString(),
              amount: double.parse(amount.toString()).toPrecision(2));
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

  Rx<String> _email = "".obs;
  Rx<String> get email => this._email;

  Rx<String> _id = "".obs;
  Rx<String> get id => this._id;

  Rx<String> _phone = "".obs;
  Rx<String> get phone => this._phone;

  Future getUserData() async {
    await Utils.getStringValue('email').then((emailValue) {
      _email.value = emailValue;
    });
    await Utils.getStringValue('id').then((idValue) {
      _id.value = idValue;
    });
    await Utils.getStringValue('phone').then((phoneValue) {
      _phone.value = phoneValue;
    });
  }

  @override
  void onInit() {
    getUserData();
    getMyWallet();
    plugin.initialize(publicKey: payStackPublicKey);
    super.onInit();
  }
}
