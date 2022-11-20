// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/config/app_config.dart';

// Project imports:
import 'package:infixedu/screens/main/DashboardScreen.dart';
import 'package:infixedu/utils/FunctinsData.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/Child.dart';

// ignore: must_be_immutable
class ChildRow extends StatefulWidget {
  Child child;
  String token;

  ChildRow(this.child, this.token);

  @override
  _ChildRowState createState() => _ChildRowState(child, token);
}

class _ChildRowState extends State<ChildRow> {
  Child child;
  String token;

  _ChildRowState(this.child, this.token);

  @override
  Widget build(BuildContext context) {
    String image = child.photo == null || child.photo == ""
        ? "${AppConfig.domainName}/public/uploads/staff/demo/staff.jpg"
        : InfixApi.root + child.photo;
    return InkWell(
      onTap: () {
        Get.to(() => DashboardScreen(
              AppFunction.students,
              AppFunction.studentIcons,
              "3",
              childUID: child.uid,
              image: image,
              token: token,
              childName: child.name,
              childId: child.id,
            ));
      },
      splashColor: Colors.purple.shade200,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(image),
              backgroundColor: Colors.grey,
            ),
            title: Text(
              child.name,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Color(0xff415094),
                  ),
            ),
            subtitle: Wrap(
              children: List.generate(
                  child.classSections.length,
                  (index) => Text('${child.classSections[index]}',
                      style: Theme.of(context).textTheme.headline4)),
            ),
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Colors.purple, Colors.deepPurple]),
            ),
          )
        ],
      ),
    );
  }
}
