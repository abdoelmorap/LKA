// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:infixedu/screens/fees/model/Fee.dart';

// ignore: must_be_immutable
class FeePaymentRow extends StatelessWidget {

  FeeElement fee;
  FeePaymentRow(this.fee);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  fee.feesName,
                  style: Theme.of(context).textTheme.headline5,
                  maxLines: 1,
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
                        style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10.0,),
                      Text(
                        fee.dueDate.toString(),
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
                        style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10.0,),
                      Text(
                        '\$'+fee.amount.toString(),
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
                        'Paid',
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10.0,),
                      Text(
                        '\$'+fee.paid.toString(),
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
                        style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10.0,),
                      Text(
                        '\$'+fee.balance.toString(),
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline4,
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
  }

}
