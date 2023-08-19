// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:infixedu/screens/fees/paymentGateway/FeePaymentMain.dart';
import 'package:infixedu/screens/fees/model/Fee.dart';
import 'package:infixedu/utils/widget/ScaleRoute.dart';

// ignore: must_be_immutable
class FeesRow extends StatefulWidget {
  FeeElement fee;
  String? id;

  FeesRow(this.fee, this.id);

  @override
  State<FeesRow> createState() => _FeesRowState();
}

class _FeesRowState extends State<FeesRow> {
  final TextEditingController amountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    amountController.text = widget.fee.balance.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          showAlertDialog(context);
        },
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.fee.feesName,
                    style: Theme.of(context).textTheme.headline5,
                    maxLines: 1,
                  ),
                ),
                Container(
                  width: 80.0,
                  child: GestureDetector(
                    onTap: () {
                      showAlertDialog(context);
                    },
                    child: Text(
                      'View',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Due Date',
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        widget.fee.dueDate == null
                            ? Text(
                                'N/A',
                                style: Theme.of(context).textTheme.headline4,
                              )
                            : Text(
                                widget.fee.dueDate.toLocal().toString(),
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
                          'Amount',
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          widget.fee.amount.toString(),
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
                          'Paid',
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          widget.fee.paid.toString(),
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
                          'Balance',
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          widget.fee.currencySymbol.toString() +
                              widget.fee.balance.toString(),
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
                          'Status',
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        getStatus(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 0.5,
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Color(0xFF90DCCE),
                      Color(0xFF93CFC4),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                widget.fee.feesName.toString(),
                                style: Theme.of(context).textTheme.headline5,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Amount',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      '${widget.fee.currencySymbol.toString()}' +
                                          widget.fee.amount.toString(),
                                      maxLines: 1,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Discount',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      widget.fee.discountAmount == null
                                          ? 'N/A'
                                          : '${widget.fee.currencySymbol.toString()}' +
                                              widget.fee.discountAmount
                                                  .toString(),
                                      maxLines: 1,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Fine',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      '${widget.fee.currencySymbol.toString()}' +
                                          widget.fee.fine.toString(),
                                      maxLines: 1,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Paid',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      '${widget.fee.currencySymbol.toString()}' +
                                          widget.fee.paid.toString(),
                                      maxLines: 1,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Balance',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      '${widget.fee.currencySymbol.toString()}' +
                                          widget.fee.balance.toString(),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: Container(
                            child: Material(
                              color: Colors.white,
                              child: TextFormField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: false, signed: false),
                                style: Theme.of(context).textTheme.headline6,
                                controller: amountController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (String? value) {
                                  RegExp regExp = new RegExp(r'^[0-9]*$');
                                  if (value!.isEmpty) {
                                    return 'Please enter a valid amount';
                                  }
                                  if (int.tryParse(value) == 0) {
                                    return 'Amount must be greater than 0';
                                  }
                                  if (!regExp.hasMatch(value)) {
                                    return 'Please enter a number';
                                  }
                                  if (int.tryParse(value)! >
                                      int.tryParse(
                                          widget.fee.balance.toString())!) {
                                    return 'Amount must not greater than balance';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Amount",
                                  labelText: "Amount",
                                  labelStyle:
                                      Theme.of(context).textTheme.headline4,
                                  errorStyle: TextStyle(
                                      color: Colors.pinkAccent, fontSize: 15.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        widget.fee.balance > 0
                            ? GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.push(
                                            context,
                                            ScaleRoute(
                                                page: FeePaymentMain(
                                                    widget.fee,
                                                    widget.id,
                                                    amountController.text)))
                                        .then((result) {
                                      Navigator.of(context).pop();
                                    });
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                        child: Text(
                                      'Continue',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 16.0),
                                    )),
                                  ),
                                ),
                              )
                            : Text(''),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getStatus(BuildContext context) {
    if (widget.fee.balance == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.greenAccent),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Paid',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if ((widget.fee.paid == 0
            ? widget.fee.paid
            : double.parse(widget.fee.paid.toString())) >
        0.0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.amberAccent),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Partial',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (widget.fee.paid == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.redAccent),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'unpaid',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
