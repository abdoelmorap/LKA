// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/Staff.dart';
import 'package:infixedu/utils/widget/Line.dart';

// ignore: must_be_immutable
class StaffDetailsScreen extends StatefulWidget {
  Staff staff;

  StaffDetailsScreen(this.staff);

  @override
  _StaffDetailsScreenState createState() => _StaffDetailsScreenState();
}

class _StaffDetailsScreenState extends State<StaffDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: widget.staff.title,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomPaint(
                painter: ShapesPainter(),
                child: Container(
                  height: height / 2,
                  width: width,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 52.0, left: 32.0),
                        child: Text(
                          widget.staff.name,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      Positioned(
                        top: height / 3.91,
                        left: width / 6,
                        child: ClipRRect(
                          child: CircleAvatar(
                            radius: 70.0,
                            backgroundImage: widget.staff.photo == null ||
                                    widget.staff.photo == ""
                                ? NetworkImage(InfixApi.root +
                                    "public/uploads/staff/demo/staff.jpg")
                                : NetworkImage(
                                    InfixApi.root + widget.staff.photo),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                      child: Text(
                        'Address : ${widget.staff.currentAddress}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 16.0, bottom: 8.0),
                      child: Text(
                        'Phone: ${widget.staff.phone}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                ),
              ),
              BottomLine(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                child: Text(
                  'Title : ${widget.staff.title}',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              BottomLine(),
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
                child: Text(
                  'Qualification: ${widget.staff.qualification}',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              BottomLine(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                child: Text(
                  'Merital Status : ${widget.staff.maritalStatus}',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              BottomLine(),
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
                child: Text(
                  'Joining Date: ${widget.staff.dateOfJoining}',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              BottomLine(),
            ],
          ),
        ),
      ),
    );
  }
}

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the paint color to be white
    paint.color = Colors.white10;
    // Create a rectangle with size and width same as the canvas
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // draw the rectangle using the paint
    canvas.drawRect(rect, paint);
    paint.color = Colors.deepPurpleAccent.withOpacity(0.6);
    // create a path
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width + 50, 0);
    // close the path to form a bounded shape
    path.close();
    canvas.drawPath(path, paint);

    paint.color = Colors.deepPurpleAccent.withOpacity(0.4);
    var path2 = Path();
    path2.lineTo(size.width + 50, 0);
    path2.lineTo(0, size.height / 1.5);
    path2.close();
    canvas.drawPath(path2, paint);

    paint.color = Colors.deepPurpleAccent.withOpacity(0.8);
    var path3 = Path();
    path3.lineTo(size.width + 50, 0);
    path3.lineTo(0, size.height / 2);
    path3.close();
    canvas.drawPath(path3, paint);

//    // set the color property of the paint
//    paint.color = Colors.grey;
//    // center of the canvas is (x,y) => (width/2, height/2)
//    var center = Offset(size.width / 3, size.height / 1.5);
//    // draw the circle with center having radius 75.0
//    canvas.drawCircle(center, 75.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
