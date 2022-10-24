// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:infixedu/utils/model/BookIssued.dart';

// ignore: must_be_immutable
class BookListRow extends StatefulWidget {

  BookIssued books;


  BookListRow(this.books);

  @override
  _BookListRowState createState() => _BookListRowState(books);
}

class _BookListRowState extends State<BookListRow> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation parentAnimation,childAnimation;
  BookIssued books;


  _BookListRowState(this.books);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(seconds: 2),vsync: this);
    parentAnimation = Tween(begin: -1.0,end: 0.0).animate(CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    childAnimation = Tween(begin: 1.0,end: 0.0).animate(CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedBuilder(
          animation: parentAnimation,
          builder: (context,child){
            return Container(
              transform: Matrix4.translationValues(parentAnimation.value * width, 0.0, 0.0),
              child: Text(
                books.title,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 15.0,fontWeight: FontWeight.w700),
                maxLines: 1,
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: parentAnimation,
          builder: (context,child){
            return Container(
              transform: Matrix4.translationValues(parentAnimation.value * width, 0.0, 0.0),
              child: Text(
                books.author,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(fontSize: ScreenUtil().setSp(14.0),fontWeight: FontWeight.w500),
                maxLines: 1,
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: parentAnimation,
          builder: (context,child){
            return Container(
              transform: Matrix4.translationValues(childAnimation.value * width, 0.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Issued Date',
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                           books.issuedDate,
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
                            'Return Date',
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            books.returnDate,
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
                            'Book No',
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                           books.bookNo,
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
                                .headline4
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          getStatus(context, books.status),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Container(
          height: 0.5,
          margin: EdgeInsets.only(top: 10.0,bottom: 10.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Colors.purple, Colors.deepPurple]),
          ),
        ),
      ],
    );
  }

  Widget getStatus(BuildContext context, String status) {
    if (status == 'I') {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.redAccent),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Issued',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
    else if (status == 'R') {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.green.shade400),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Returned',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }else{
      return Container();
    }
  }

}
