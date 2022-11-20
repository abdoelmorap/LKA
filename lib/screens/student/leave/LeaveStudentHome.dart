// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:infixedu/utils/CardItem.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/FunctinsData.dart';

// ignore: must_be_immutable
class LeaveStudentHome extends StatefulWidget {
  var _titles;
  var _images;
  var id;

  LeaveStudentHome(this._titles, this._images, {this.id});

  @override
  _LeaveStudentHomeState createState() =>
      _LeaveStudentHomeState(_titles, _images, sId: id);
}

class _LeaveStudentHomeState extends State<LeaveStudentHome> {
  bool isTapped;
  int currentSelectedIndex;
  var _titles;
  var _images;
  var sId;

  _LeaveStudentHomeState(this._titles, this._images, {this.sId});

  @override
  void initState() {
    super.initState();
    isTapped = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Leave'),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GridView.builder(
          itemCount: _titles.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            return CustomWidget(
              index: index,
              isSelected: currentSelectedIndex == index,
              onSelect: () {
                setState(() {
                  currentSelectedIndex = index;
                  AppFunction.getStudentLeaveDashboardPage(
                      context, _titles[index],
                      id: sId);
                });
              },
              headline: _titles[index],
              icon: _images[index],
            );
          },
        ),
      ),
    );
  }
}
