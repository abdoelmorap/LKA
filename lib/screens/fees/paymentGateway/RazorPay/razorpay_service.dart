import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayServices {
  /// RazorPay object declaration
  Razorpay _razorpay = Razorpay();

  /// Registers event listeners for payment success events
  onSuccess(PaymentSuccessResponse response, successListener) {
    successListener(
      PaymentResponse(
        "successful response",
        true,
        response.paymentId.toString(),
      ),
    );
  }

  /// Registers event listeners for payment failures events
  onFailure(PaymentFailureResponse response, failureLitener) {
    failureLitener(PaymentResponse(response.message, false, response.message));
  }

  /// Method for open razorpay and listening payment events
  openRazorpay({
    String contactNumber,
    String emailId,
    String razorpayKey,
    double amount,
    String userName,
    Function(PaymentResponse) successListener,
    Function(PaymentResponse) failureListener,
  }) {
    Map<String, Object> options = {
      'key': razorpayKey,
      'amount': amount * 100,
      'name': userName,
      'prefill': {'contact': contactNumber, 'email': emailId},
    };
    try {
      /// initialize razrorpay
      _razorpay.open(options);

      /// event listeners for successs payment
      _razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS,
        (res) {
          onSuccess(res, successListener);
        },
      );

      /// event listeners for failure payment
      _razorpay.on(
        Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse res) {
          log(res.message);
          onFailure(res, failureListener);
        },
      );
    } catch (e) {
      /// return if something went wrong
      debugPrint(
        failureListener(
          PaymentResponse(
            e.toString(),
            false,
            "Something went wrong!",
          ),
        ),
      );
    }
  }
}

class PaymentResponse {
  String message;
  bool paymentStatus;
  String paymentId;

  PaymentResponse(
    this.message,
    this.paymentStatus,
    this.paymentId,
  );
}
