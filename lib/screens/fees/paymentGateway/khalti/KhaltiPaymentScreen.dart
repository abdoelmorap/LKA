// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/screens/fees/paymentGateway/khalti/KhaltiPayment.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/Fee.dart';
import 'package:infixedu/utils/model/UserDetails.dart';
import 'package:infixedu/utils/widget/ScaleRoute.dart';
import 'core/khalti_core.dart';
import 'sdk/khalti.dart';

class KhaltiPaymentScreen extends StatelessWidget {
  final String id;
  final String paidBy;
  final FeeElement fee;
  final String email;
  final String method;
  final String amount;
  final UserDetails userDetails;

  KhaltiPaymentScreen(
      {this.id,
      this.paidBy,
      this.fee,
      this.email,
      this.method,
      this.amount,
      this.userDetails});

  @override
  Widget build(BuildContext context) {
    List<Widget> _tabs = [
      Tab(text: 'Wallet Payment'),
      Tab(text: 'EBanking'),
      Tab(text: 'MBanking'),
    ];

    return SafeArea(
      child: DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Color(0xFF93CFC4),
              ),
            ),
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      height: 70.h,
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
                        "Khalti Payment",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontSize: ScreenUtil().setSp(20),
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              labelPadding: EdgeInsets.zero,
              tabs: _tabs,
            ),
          ),
          body: TabBarView(
            children: [
              WalletPayment(
                id: id,
                paidBy: paidBy,
                fee: fee,
                email: email,
                method: 'Khalti Payment',
                userDetails: userDetails,
                amount: amount,
              ),
              Banking(
                  id: id,
                  paidBy: paidBy,
                  fee: fee,
                  email: email,
                  method: 'Khalti Payment',
                  userDetails: userDetails,
                  amount: amount,
                  paymentType: BankPaymentType.eBanking),
              Banking(
                  id: id,
                  paidBy: paidBy,
                  fee: fee,
                  email: email,
                  method: 'Khalti Payment',
                  userDetails: userDetails,
                  amount: amount,
                  paymentType: BankPaymentType.mobileCheckout),
            ],
          ),
        ),
      ),
    );
  }
}

class WalletPayment extends StatefulWidget {
  final String id;
  final String paidBy;
  final FeeElement fee;
  final String email;
  final String method;
  final String amount;
  final UserDetails userDetails;

  WalletPayment(
      {this.id,
      this.paidBy,
      this.fee,
      this.email,
      this.method,
      this.amount,
      this.userDetails});

  @override
  State<WalletPayment> createState() => _WalletPaymentState();
}

class _WalletPaymentState extends State<WalletPayment> {
  TextEditingController _mobileController, _pinController;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController();
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            validator: (v) => (v?.isEmpty ?? true) ? 'Required ' : null,
            decoration: InputDecoration(
              label: Text('Mobile Number'),
            ),
            controller: _mobileController,
          ),
          TextFormField(
            validator: (v) => (v?.isEmpty ?? true) ? 'Required ' : null,
            decoration: InputDecoration(
              label: Text('Khalti MPIN'),
            ),
            controller: _pinController,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(vertical: 10),
                textStyle:
                    TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            onPressed: () async {
              if (!(_formKey.currentState?.validate() ?? false)) return;

              try {
                final khaltiPaymentService = KhaltiPaymentService(
                    widget.id,
                    widget.fee,
                    widget.email,
                    widget.method,
                    widget.amount,
                    widget.userDetails,
                    widget.paidBy,
                    context);

                await khaltiPaymentService
                    .paymentDataSave()
                    .then((value) async {
                  print(value);

                  final initiationModel = await Khalti.service.initiatePayment(
                    request: PaymentInitiationRequestModel(
                      amount: int.parse(widget.amount) * 100,
                      mobile: _mobileController.text,
                      productIdentity: '${widget.fee.feesName}',
                      productName: '${widget.fee.feesName}',
                      transactionPin: _pinController.text,
                      productUrl: '',
                    ),
                  );

                  final otpCode = await showDialog<String>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      String _otp;
                      return AlertDialog(
                        title: Text('OTP Sent!'),
                        content: TextField(
                          decoration: InputDecoration(
                            label: Text('OTP Code'),
                          ),
                          onChanged: (v) => _otp = v,
                        ),
                        actions: [
                          SimpleDialogOption(
                            child: Text('OK'),
                            onPressed: () => Navigator.pop(context, _otp),
                          )
                        ],
                      );
                    },
                  );

                  print("OTP CODE $otpCode");
                  if (otpCode != null) {
                    final model = await Khalti.service.confirmPayment(
                      request: PaymentConfirmationRequestModel(
                        confirmationCode: otpCode,
                        token: initiationModel.token,
                        transactionPin: _pinController.text,
                      ),
                    );
                    print(model);

                    Map params = {"token": model.token, "amount": model.amount};

                    var response = await http.post(
                      Uri.parse(
                        "https://khalti.com/api/v2/payment/status/",
                      ),
                      headers: {
                        "Authorization": "Key $khaltiPublicKey",
                      },
                      body: jsonEncode(params),
                    );
                    Utils.showToast(response.body.toString());
                    Utils.showToast(response.statusCode.toString());
                    var jsonString = jsonDecode(response.body);
                    Utils.showToast(jsonString.toString());
                    if (response.statusCode == 200) {
                      if (jsonString['state'] == "Complete") {
                        Utils.showToast(
                            "Payment state: ${jsonString['state']}");
                        await khaltiPaymentService.paymentCallBack(
                            reference: value, status: true);
                      }
                    } else {
                      Utils.showToast(
                          'Unable to pay ${response.body.toString()}');
                    }
                  }
                });
              } catch (e) {
                ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: Text('PAY Rs. ${widget.amount}'),
          ),
        ],
      ),
    );
  }
}

class Banking extends StatefulWidget {
  final String id;
  final String paidBy;
  final FeeElement fee;
  final String email;
  final String method;
  final String amount;
  final UserDetails userDetails;
  final BankPaymentType paymentType;

  Banking(
      {this.id,
      this.paidBy,
      this.fee,
      this.email,
      this.method,
      this.amount,
      this.userDetails,
      @required this.paymentType});

  @override
  State<Banking> createState() => _BankingState();
}

class _BankingState extends State<Banking> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<BankListModel>(
      future: Khalti.service.getBanks(paymentType: widget.paymentType),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final banks = snapshot.data.banks;
          return ListView.builder(
            itemCount: banks.length,
            itemBuilder: (context, index) {
              final bank = banks[index];
              return ListTile(
                leading: SizedBox.square(
                  dimension: 40,
                  child: Image.network(bank.logo),
                ),
                title: Text(bank.name),
                subtitle: Text(
                  bank.shortName,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                onTap: () async {
                  final mobile = await showDialog<String>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      String _mobile;
                      return AlertDialog(
                        title: Text('Enter Mobile Number'),
                        content: TextField(
                          decoration: InputDecoration(
                            label: Text('Mobile Number'),
                          ),
                          onChanged: (v) => _mobile = v,
                        ),
                        actions: [
                          SimpleDialogOption(
                            child: Text('OK'),
                            onPressed: () => Navigator.pop(context, _mobile),
                          )
                        ],
                      );
                    },
                  );

                  if (mobile != null) {
                    final url = Khalti.service.buildBankUrl(
                      bankId: bank.idx,
                      amount: int.parse(widget.amount) * 100,
                      mobile: mobile,
                      productIdentity: '${widget.fee.feesName}',
                      productName: '${widget.fee.feesName}',
                      paymentType: widget.paymentType,
                      returnUrl: '${AppConfig.domainName}',
                    );

                    final khaltiPaymentService = KhaltiPaymentService(
                        widget.id,
                        widget.fee,
                        widget.email,
                        widget.method,
                        widget.amount,
                        widget.userDetails,
                        widget.paidBy,
                        context);

                    await khaltiPaymentService.paymentDataSave().then((value) {
                      print(value);
                      print(url);
                      Navigator.push(
                          context,
                          ScaleRoute(
                              page: KhaltiPayment(
                            checkoutUrl: url,
                            onFinish: (onFinish) async {
                              await khaltiPaymentService.paymentCallBack(
                                  reference: value, status: onFinish['status']);
                            },
                          )));
                    });
                  }
                },
              );
            },
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class KhaltiPaymentService {
  final String id;
  final FeeElement fee;
  final String email;
  final String method;
  final String amount;
  final String paidBy;
  final UserDetails userDetails;
  final BuildContext context;

  KhaltiPaymentService(this.id, this.fee, this.email, this.method, this.amount,
      this.userDetails, this.paidBy, this.context);

  String token;

  Future<dynamic> paymentDataSave() async {
    await Utils.getStringValue('token').then((value) {
      token = value;
    });

    Map data = {
      'student_id': id,
      'fees_type_id': fee.feesTypeId,
      'amount': amount,
      'method': method,
      'school_id': userDetails.schoolId,
    };
    final response = await http.post(
      Uri.parse(InfixApi.paymentDataSave),
      body: jsonEncode(data),
      headers: {
        "Accept": "application/json",
        "Authorization": token.toString(),
      },
    );
    print("paymentDataSave ${response.body}");
    print("paymentDataSave ${response.statusCode}");

    var jsonString = jsonDecode(response.body);

    return jsonString['payment_ref'];
  }

  Future paymentCallBack({dynamic reference, dynamic status}) async {
    await Utils.getStringValue('token').then((value) {
      token = value;
    });
    final response = await http.post(
      Uri.parse(InfixApi.paymentSuccessCallback(status, reference, amount)),
      headers: {
        "Accept": "application/json",
        "Authorization": token.toString(),
      },
    );
    print("paymentCallBack ===> ${response.body}");
    print("paymentCallBack ===> ${response.statusCode}");
    await studentPayment();
  }

  Future studentPayment() async {
    await Utils.getStringValue('token').then((value) {
      token = value;
    });
    try {
      final response = await http.get(
          Uri.parse(InfixApi.studentFeePayment(id.toString(),
              int.parse(fee.feesTypeId.toString()), amount, paidBy, 'Khalti')),
          headers: {
            "Accept": "application/json",
            "Authorization": token.toString(),
          });
      print('Response Status => ${response.statusCode}');
      print('Response Body => ${response.body}');
      if (response.statusCode == 200) {
        print(response.body);
        var data = json.decode(response.body.toString());

        print(data['success']);

        print(data);
        if (data['success'] == true) {
          Utils.showToast('Payment Added');

          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          // Route route = MaterialPageRoute(
          //     builder: (context) => FeeScreen(), fullscreenDialog: true);
          // Navigator.of(context, rootNavigator: true).push(route);
        } else {
          Utils.showToast('Some error occurred');
          Navigator.of(context).pop();
        }
      } else {}
    } catch (e) {
      Exception('${e.toString()}');
    }
  }
}
