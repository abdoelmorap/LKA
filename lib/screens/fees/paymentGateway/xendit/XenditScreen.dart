// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';

// Project imports:
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/screens/fees/paymentGateway/xendit/XenditPaymentScreen.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/Fee.dart';
import 'package:infixedu/utils/model/UserDetails.dart';
import 'package:infixedu/utils/model/XenditErrorResponse.dart';

class XenditScreen extends StatefulWidget {
  final String id;
  final String paidBy;
  final FeeElement fee;
  final String email;
  final String method;
  final String amount;
  final UserDetails userDetails;

  XenditScreen(
      {this.id,
      this.paidBy,
      this.fee,
      this.email,
      this.method,
      this.amount,
      this.userDetails});

  @override
  State<StatefulWidget> createState() {
    return XenditScreenState();
  }
}

class XenditScreenState extends State<XenditScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loading = false;
  var _token;

  var loadingText = "";

  var referenceId = "";

  Future<dynamic> paymentDataSave(String method) async {
    Map data = {
      'student_id': widget.id,
      'fees_type_id': widget.fee.feesTypeId,
      'amount': widget.amount,
      'method': method,
      'school_id': widget.userDetails.schoolId,
    };
    final response = await http.post(
      Uri.parse(InfixApi.paymentDataSave),
      body: jsonEncode(data),
      headers: {
        "Accept": "application/json",
        "Authorization": _token.toString(),
      },
    );
    print("paymentDataSave ${response.body}");
    print("paymentDataSave ${response.statusCode}");

    var jsonString = jsonDecode(response.body);

    return jsonString['payment_ref'];
  }

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    Utils.getStringValue('token').then((value) {
      _token = value;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBarWidget(
        title: widget.method,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              glassmorphismConfig:
                  useGlassMorphism ? Glassmorphism.defaultConfig() : null,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              cardBgColor: Colors.deepPurpleAccent,
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                      themeColor: Colors.blue,
                      textColor: Colors.white,
                      cardNumberDecoration: InputDecoration(
                        labelText: 'Number',
                        hintText: 'XXXX XXXX XXXX XXXX',
                        hintStyle: const TextStyle(color: Colors.white),
                        labelStyle: const TextStyle(color: Colors.white),
                        focusedBorder: border,
                        enabledBorder: border,
                      ),
                      expiryDateDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.white),
                        labelStyle: const TextStyle(color: Colors.white),
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'Expired Date',
                        hintText: 'XX/XX',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.white),
                        labelStyle: const TextStyle(color: Colors.white),
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'CVV',
                        hintText: 'XXX',
                      ),
                      cardHolderDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.white),
                        labelStyle: const TextStyle(color: Colors.white),
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'Card Holder',
                      ),
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    loading
                        ? Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '$loadingText',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              primary: const Color(0xff1b447b),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(12),
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                                var fullDate = expiryDate.split("/");

                                await paymentDataSave("Xendit")
                                    .then((value) async {
                                  setState(() {
                                    referenceId = value.toString();
                                  });
                                  await xenditCreditCardToken(fullDate);
                                  // await _testSingleUseToken(fullDate, value);
                                });
                              } else {
                                print('invalid!');
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future xenditCreditCardToken(fullDate) async {
    setState(() {
      loading = true;
      loadingText =
          "Processing Payment, Don\'t close this page. Please wait...";
    });
    try {
      Map data = {
        "is_single_use": true,
        "card_data": {
          "account_number": "${cardNumber.replaceAll(" ", "").toString()}",
          "exp_month": "${fullDate[0]}",
          "exp_year": "20${fullDate[1]}",
          "cvn": "${cvvCode.toString()}"
        },
        "should_authenticate": true,
        "amount": "${(int.parse(widget.amount) * 1000).toInt()}",
        "card_cvn": "${cvvCode.toString()}"
      };

      var jsonData = json.encode(data);
      print(jsonData);
      Uri url = Uri.parse('https://api.xendit.co/v2/credit_card_tokens');
      var client = BasicAuthClient("$xenditPublicKey", "");
      var response = await client.post(url, body: jsonData, headers: {
        'Content-Type': 'application/json',
      });
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          loadingText = "Credit Card IN REVIEW. Please wait... ";
        });
        final body = jsonDecode(response.body);

        if (body['status'] == "IN_REVIEW") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => XenditPaymentScreen(
                  fee: widget.fee,
                  amount: widget.amount,
                  redirectUrl: body['payer_authentication_url'],
                  authenticationId: body['authentication_id'],
                  onFinish: (onFinish) async {
                    await payWithXendit(
                        tokenId: body['id'],
                        authenticationId: body['authentication_id']);
                  },
                ),
              ));
        }
      } else {
        setState(() {
          loading = false;
        });
        final body = jsonDecode(response.body);

        if (body['error_code'] == "AMOUNT_BELOW_MINIMUM_LIMIT") {
          showDialog<void>(
            context: context,
            barrierDismissible: true, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Amount below minimum limit"),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          final xenditErrorResponse =
              xenditErrorResponseFromJson(response.body);

          showDialog<void>(
            context: context,
            barrierDismissible: true, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(xenditErrorResponse.message),
                content: Container(
                  height: MediaQuery.of(context).size.width * 0.5,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ListView.builder(
                    itemCount: xenditErrorResponse.errors.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(xenditErrorResponse.errors[index].message);
                    },
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      print("Error $e");
    }
  }

  Future payWithXendit({String tokenId, String authenticationId}) async {
    try {
      print('Token ID: $tokenId , Authentication ID: $authenticationId');

      Map data = {
        "token_id": "$tokenId",
        "authentication_id": "$authenticationId",
        "external_id":
            "${AppConfig.appName}_${DateTime.now().millisecondsSinceEpoch}",
        "amount": (int.parse(widget.amount.toString()) * 1000).toInt(),
        "card_cvn": "$cvvCode",
      };

      var jsonData = json.encode(data);
      print(jsonData);
      Uri url = Uri.parse('https://api.xendit.co/credit_card_charges');
      var client = BasicAuthClient("$xenditSecretKey", "");
      var response = await client.post(url,
          body: jsonData,
          headers: {'Content-Type': 'application/json', 'Accept': '*/*'});
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          loadingText = "Credit Card Charge confirmed. Please wait... ";
        });
        final body = jsonDecode(response.body);
        print("AFTER CHARGE => ${body.toString()}");

        await paymentCallBack(reference: referenceId, status: 'true');
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      Exception('${e.toString()}');
    }
  }

  // Future _testSingleUseToken(fullDate, referenceId) async {
  //   print(
  //       "XENDIT _testSingleUseToken $fullDate $referenceId ${(int.parse(widget.amount) * 1000).toInt()}");
  //   try {
  //     setState(() {
  //       loading = true;
  //       loadingText =
  //           "Processing Payment, Don\'t close this page. Please wait...";
  //     });
  //     bool isValid = CardValidator.isCardNumberValid(
  //             "${cardNumber.toString()}") &&
  //         CardValidator.isExpiryValid("${fullDate[0]}", "20${fullDate[1]}") &&
  //         CardValidator.isCvnValid("${cvvCode.toString()}");
  //
  //     print("isValid $isValid");
  //
  //     if (isValid) {
  //       XCard card = XCard(
  //         creditCardNumber: '${cardNumber.toString()}',
  //         creditCardCVN: '${cvvCode.toString()}',
  //         expirationMonth: '${fullDate[0]}',
  //         expirationYear: '20${fullDate[1]}',
  //       );
  //       TokenResult result = await xendit.createSingleUseToken(
  //         card,
  //         amount: (int.parse(widget.amount) * 1000).toInt(),
  //         shouldAuthenticate: true,
  //       );
  //       print('card $result');
  //       if (result.isSuccess) {
  //         tokenId = result.token.id;
  //         // await payWithXendit(tokenId: tokenId, referenceId: referenceId);
  //       } else {
  //         setState(() {
  //           loading = false;
  //           loadingText =
  //               "Error Processing payment. Please contact administrator ${result.errorCode} - ${result.errorMessage}";
  //         });
  //         print(
  //             'SingleUseToken Error: ${result.errorCode} - ${result.errorMessage}');
  //       }
  //     }
  //   } catch (e) {
  //     setState(() {
  //       loading = false;
  //       loadingText =
  //           "Error Processing payment. Please contact administrator ${e.toString()}";
  //     });
  //     throw Exception("${e.toString()}");
  //   }
  // }

  // Future _testAuthentication() async {
  //   if (tokenId.isNotEmpty) {
  //     AuthenticationResult result =
  //         await xendit.createAuthentication(tokenId, amount: (int.parse(widget.amount.toString()) * 100).toInt());
  //
  //     if (result.isSuccess) {
  //       print('success on _testAuthentication');
  //       print('Authentication ID: ${result.authentication.id}');
  //       await payWithXendit(
  //         tokenId: tokenId,
  //         authenticationId: result.authentication.id,
  //       );
  //     } else {
  //       print(
  //           'Authentication Error: ${result.errorCode} - ${result.errorMessage}');
  //     }
  //   }else{
  //     print('waiting for token');
  //   }
  // }

  Future paymentCallBack({dynamic reference, dynamic status}) async {
    final response = await http.post(
      Uri.parse(
          InfixApi.paymentSuccessCallback(status, reference, widget.amount)),
      headers: {
        "Accept": "application/json",
        "Authorization": _token.toString(),
      },
    );
    print("paymentCallBack ===> ${response.body}");
    print("paymentCallBack ===> ${response.statusCode}");
    await studentPayment();
  }

  Future studentPayment() async {
    try {
      setState(() {
        loading = true;
      });

      final response = await http.get(
          Uri.parse(InfixApi.studentFeePayment(
              widget.id.toString(),
              int.parse(widget.fee.feesTypeId.toString()),
              widget.amount,
              widget.paidBy,
              'Xendit')),
          headers: {
            "Accept": "application/json",
            "Authorization": _token.toString(),
          });
      print('Response Status => ${response.statusCode}');
      print('Response Body => ${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        print(response.body);
        var data = json.decode(response.body.toString());

        print(data['success']);

        print(data);
        if (data['success'] == true) {
          Utils.showToast('Payment Added');
          Navigator.of(context).pop();
        } else {
          Utils.showToast('Some error occurred');
        }
      } else {
        setState(() {
          loading = true;
        });
      }
    } catch (e) {
      Exception('${e.toString()}');
    }
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
