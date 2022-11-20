// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:infixedu/screens/admin/Bloc/StaffListBloc.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/Staff.dart';
import 'package:infixedu/utils/widget/Line.dart';
import 'package:infixedu/utils/widget/ScaleRoute.dart';
import 'AdminStaffDetails.dart';

// ignore: must_be_immutable
class StaffListScreen extends StatefulWidget {
  dynamic id;

  StaffListScreen(this.id);

  @override
  _StaffListScreenState createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  StaffListBloc listBloc;

  @override
  void initState() {
    super.initState();
    //blocStuff.getStaffList();
    listBloc = StaffListBloc(id: widget.id);
    listBloc.getStaffList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Staff List',
      ),
      body: StreamBuilder<StaffList>(
        stream: listBloc.getStaffSubject.stream,
        builder: (context, snap) {
          if (snap.hasData) {
            if (snap.error != null) {
              return _buildErrorWidget(snap.error.toString());
            }
            return _buildStaffListWidget(snap.data);
          } else if (snap.hasError) {
            return _buildErrorWidget(snap.error);
          } else {
            return _buildLoadingWidget();
          }
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  Widget _buildStaffListWidget(StaffList data) {
    return ListView.builder(
      itemCount: data.staffs.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    ScaleRoute(page: StaffDetailsScreen(data.staffs[index])));
              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: data.staffs[index].photo == null ||
                          data.staffs[index].photo == ""
                      ? NetworkImage(
                          InfixApi.root + "public/uploads/staff/demo/staff.jpg")
                      : NetworkImage(InfixApi.root + data.staffs[index].photo),
                  backgroundColor: Colors.transparent,
                ),
                title: Text(
                  data.staffs[index].name,
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone' + ' : ${data.staffs[index].phone}',
                        style: Theme.of(context).textTheme.headline4),
                    Text('Address' + ' : ${data.staffs[index].currentAddress}',
                        style: Theme.of(context).textTheme.headline4),
                  ],
                ),
                isThreeLine: true,
              ),
            ),
            BottomLine(),
          ],
        );
      },
    );
  }
}
