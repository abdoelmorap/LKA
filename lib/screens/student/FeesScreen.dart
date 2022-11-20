// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/screens/fees/model/Fee.dart';
import 'package:infixedu/screens/fees/services/FeesService.dart';
import 'package:infixedu/screens/fees/widgets/Fees_row_layout.dart';
import 'package:infixedu/utils/widget/ShimmerListWidget.dart';

// ignore: must_be_immutable
class FeeScreen extends StatefulWidget {
  String id;

  FeeScreen({this.id});

  @override
  _FeeScreenState createState() => _FeeScreenState();
}

class _FeeScreenState extends State<FeeScreen> {
  String _token;

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      _token = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBarWidget(title: 'Fees'),
      appBar: CustomAppBarWidget(
        title: 'Fees',
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Grand Total',
                    style: Theme.of(context).textTheme.headline5.copyWith(),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              child: FutureBuilder(
                future: Utils.getStringValue('id'),
                builder: (context, id) {
                  if (id.hasData) {
                    return Container(
                      child: FutureBuilder<List<double>>(
                          // stream: Stream.periodic(Duration(seconds: 10))
                          //     .asyncMap((i) => FeeService(int.parse(
                          //     widget.id != null ? widget.id : id.data),_token)
                          //     .fetchTotalFee()),
                          future: FeeService(
                                  int.parse(
                                      widget.id != null ? widget.id : id.data),
                                  _token)
                              .fetchTotalFee(),
                          builder: (context, totalSnapshot) {
                            if (totalSnapshot.hasData) {
                              return Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Amount',
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          totalSnapshot.data[0].toString(),
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Discount',
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          totalSnapshot.data[1].toString(),
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Fine',
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          totalSnapshot.data[2].toString(),
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Paid',
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          totalSnapshot.data[3].toString(),
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Balance',
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          totalSnapshot.data[4].toString(),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return ShimmerList(
                                height: 40,
                                itemCount: 1,
                              );
                            }
                          }),
                    );
                  } else {
                    return Container(
                      child: Text('...'),
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 15.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffd9c1f8).withOpacity(0.5), Colors.white]),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder(
                future: Utils.getStringValue('id'),
                builder: (context, snapId) {
                  if (snapId.hasData) {
                    return Container(
                      child: FutureBuilder<List<FeeElement>>(
                          // stream: Stream.periodic(Duration(seconds: 10))
                          //     .asyncMap((i) => FeeService(int.parse(
                          //     widget.id != null ? widget.id : snapId.data),_token)
                          //     .fetchFee()),
                          future: FeeService(
                                  int.parse(widget.id != null
                                      ? widget.id
                                      : snapId.data),
                                  _token)
                              .fetchFee(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return FeesRow(
                                        snapshot.data[index],
                                        widget.id != null
                                            ? widget.id
                                            : snapId.data);
                                  });
                            } else {
                              return ShimmerList(
                                height: 40,
                                itemCount: 1,
                              );
                            }
                          }),
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
