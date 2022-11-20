// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/utils/model/StudentDetailsModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/screens/student/EditProfile.dart';
import 'package:infixedu/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:infixedu/utils/FunctinsData.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/server/ProfileService.dart';
import 'package:infixedu/utils/widget/ProfileListRow.dart';
import 'package:infixedu/utils/widget/ScaleRoute.dart';

// ignore: must_be_immutable
class DBStudentProfile extends StatefulWidget {
  String id;
  String image;

  DBStudentProfile({this.id, this.image});

  @override
  _DBStudentProfileState createState() =>
      _DBStudentProfileState(id: id, image: image);
}

class _DBStudentProfileState extends State<DBStudentProfile> {
  bool isPersonal = false;
  bool isParents = false;
  bool isTransport = false;
  bool isOthers = false;
  String section = 'personal';
  String id;
  String image;
  String schoolId;
  String _token;
  ProfileService profileService;
  var progress = "";
  var received;

  _DBStudentProfileState({this.id, this.image});

  static List<Tab> tabs = <Tab>[
    Tab(
      text: 'Personal'.tr,
    ),
    Tab(
      text: 'Parents'.tr,
    ),
    Tab(
      text: 'Transport'.tr,
    ),
    Tab(
      text: 'Others'.tr,
    ),
    Tab(
      text: 'Documents'.tr,
    ),
  ];

  Future profile;

  StudentDetailsModel _studentDetails = StudentDetailsModel();

  Future<StudentDetailsModel> getProfile(id) async {
    final response = await http.get(Uri.parse(InfixApi.getChildren(id)),
        headers: id == null ? null : Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      final studentDetails = studentDetailsFromJson(response.body);
      setState(() {
        _studentDetails = studentDetails;
      });
    } else {
      throw "error";
    }
    return _studentDetails;
  }

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      _token = value;
      setState(() {
        profile = getProfile(id);
      });
    });
    super.initState();
  }

  void updateData() {
    setState(() {
      profile = getProfile(id);
      print('updating');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            padding: EdgeInsets.only(top: 20.h),
            decoration: BoxDecoration(
              color: Color(0xFF93CFC4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 25.w,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      "Profile".tr,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      ScaleRoute(
                          page: EditProfile(
                        id: widget.id,
                        updateData: (index) {
                          updateData();
                        },
                      )),
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<StudentDetailsModel>(
          future: profile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              if (!snapshot.hasData) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              } else {
                return Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          left: 18, top: 30, right: 18, bottom: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFF93CFC4),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${InfixApi.root}/${_studentDetails.studentData.user.studentPhoto}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CupertinoActivityIndicator(),
                                errorWidget: (context, url, error) =>
                                    CachedNetworkImage(
                                  imageUrl:
                                      "${AppConfig.domainName}/public/uploads/staff/demo/staff.jpg",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      CupertinoActivityIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Image.network(
                                          '${AppConfig.domainName}/public/uploads/staff/demo/staff.jpg'),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Expanded(child: getProfileHeader()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PreferredSize(
                        preferredSize: Size.fromHeight(10),
                        child: DefaultTabController(
                          length: tabs.length,
                          initialIndex: 0,
                          child: Builder(
                            builder: (context) {
                              final TabController tabController =
                                  DefaultTabController.of(context);
                              tabController.addListener(() {
                                if (tabController.indexIsChanging) {
                                  print(tabController.index);
                                }
                              });
                              return Scaffold(
                                backgroundColor: Colors.white,
                                appBar: AppBar(
                                  automaticallyImplyLeading: false,
                                  backgroundColor: Colors.white,
                                  // shadowColor: Colors.purple,
                                  elevation: 0,
                                  title: TabBar(
                                    labelColor: Color(0xFF93CFC4),
                                    indicatorColor: Color(0xFF93CFC4),
                                    indicatorWeight: 3,
                                    tabs: tabs,
                                    isScrollable: true,
                                    physics: BouncingScrollPhysics(),
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                            color: Color(0xFF93CFC4),
                                            fontSize: ScreenUtil().setSp(11),
                                            fontWeight: FontWeight.bold),
                                    unselectedLabelStyle: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                            color: Color(0xFF93CFC4),
                                            fontSize: ScreenUtil().setSp(11),
                                            fontWeight: FontWeight.bold),
                                    unselectedLabelColor: Color(0xFF93CFC4),
                                  ),
                                ),
                                body: Column(
                                  children: [
                                    Container(
                                      height: 15.0,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFF93CFC4)
                                                  .withOpacity(0.5),
                                              Colors.white
                                            ]),
                                      ),
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        physics: NeverScrollableScrollPhysics(),
                                        children: [
                                          getProfileList(),
                                          getParentDetails(),
                                          getTransportList(),
                                          getOthersList(),
                                          getDocumentsList(),
                                          // getParentDetails(),
                                          // getProfileList(2),
                                          // getOtherDetails(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
          }),
    );
  }

  Widget getParentDetails() {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 30),
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Father".tr,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Color(0xff727fc8)),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircleAvatar(
                  radius: ScreenUtil().setSp(25),
                  child: CachedNetworkImage(
                    imageUrl: _studentDetails
                                    .studentData.user.parents.fathersPhoto ==
                                null ||
                            _studentDetails
                                    .studentData.user.parents.fathersPhoto ==
                                ''
                        ? "https://i.imgur.com/7PqjiH7.jpeg"
                        : "${InfixApi.root}/${_studentDetails.studentData.user.parents.fathersPhoto}",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                    placeholder: (context, url) => CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ParentsDetailsRow(
                      title: "Name".tr,
                      value:
                          _studentDetails.studentData.user.parents.fathersName,
                    ),
                    GestureDetector(
                      onTap: () async {
                        // ignore: deprecated_member_use
                        await canLaunch(
                                'tel:${_studentDetails.studentData.user.parents.fathersMobile}')
                            // ignore: deprecated_member_use
                            ? await launch(
                                'tel:${_studentDetails.studentData.user.parents.fathersMobile}')
                            : throw 'Could not launch ${_studentDetails.studentData.user.parents.fathersMobile}';
                      },
                      child: ParentsDetailsRow(
                        title: "Phone".tr,
                        value: _studentDetails
                            .studentData.user.parents.fathersMobile,
                      ),
                    ),
                    ParentsDetailsRow(
                      title: "Occupation".tr,
                      value: _studentDetails
                          .studentData.user.parents.fathersOccupation,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Mother".tr,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Color(0xff727fc8)),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircleAvatar(
                  radius: ScreenUtil().setSp(25),
                  child: CachedNetworkImage(
                    imageUrl: _studentDetails
                                    .studentData.user.parents.mothersPhoto ==
                                null ||
                            _studentDetails
                                    .studentData.user.parents.mothersPhoto ==
                                ''
                        ? "https://i.imgur.com/7PqjiH7.jpeg"
                        : "${InfixApi.root}/${_studentDetails.studentData.user.parents.mothersPhoto}",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                    placeholder: (context, url) => CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ParentsDetailsRow(
                      title: "Name".tr,
                      value:
                          _studentDetails.studentData.user.parents.mothersName,
                    ),
                    GestureDetector(
                      onTap: () async {
                        // ignore: deprecated_member_use
                        await canLaunch(
                                'tel:${_studentDetails.studentData.user.parents.mothersMobile}')
                            // ignore: deprecated_member_use
                            ? await launch(
                                'tel:${_studentDetails.studentData.user.parents.mothersMobile}')
                            : throw 'Could not launch ${_studentDetails.studentData.user.parents.mothersMobile}';
                      },
                      child: ParentsDetailsRow(
                        title: "Phone".tr,
                        value: _studentDetails
                            .studentData.user.parents.mothersMobile,
                      ),
                    ),
                    ParentsDetailsRow(
                      title: "Occupation".tr,
                      value: _studentDetails
                          .studentData.user.parents.mothersOccupation,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Guardian".tr,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Color(0xff727fc8)),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircleAvatar(
                  radius: ScreenUtil().setSp(25),
                  child: CachedNetworkImage(
                    imageUrl: buildGuardianPhoto(
                        _studentDetails.studentData.user.parents),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                    placeholder: (context, url) => CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ParentsDetailsRow(
                      title: "Name".tr,
                      value: _studentDetails
                          .studentData.user.parents.guardiansName,
                    ),
                    GestureDetector(
                      onTap: () async {
                        // ignore: deprecated_member_use
                        await canLaunch(
                                'mailto:${_studentDetails.studentData.user.parents.guardiansEmail}')
                            // ignore: deprecated_member_use
                            ? await launch(
                                'mailto:${_studentDetails.studentData.user.parents.guardiansEmail}')
                            : throw 'Could not launch ${_studentDetails.studentData.user.parents.guardiansEmail}';
                      },
                      child: ParentsDetailsRow(
                        title: "Email".tr,
                        value: _studentDetails
                            .studentData.user.parents.guardiansEmail,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        // ignore: deprecated_member_use
                        await canLaunch(
                                'tel:${_studentDetails.studentData.user.parents.guardiansMobile}')
                            // ignore: deprecated_member_use
                            ? await launch(
                                'tel:${_studentDetails.studentData.user.parents.guardiansMobile}')
                            : throw 'Could not launch ${_studentDetails.studentData.user.parents.guardiansMobile}';
                      },
                      child: ParentsDetailsRow(
                        title: "Phone".tr,
                        value: _studentDetails
                            .studentData.user.parents.guardiansMobile,
                      ),
                    ),
                    ParentsDetailsRow(
                      title: "Occupation".tr,
                      value: _studentDetails
                          .studentData.user.parents.guardiansOccupation,
                    ),
                    ParentsDetailsRow(
                      title: "Relation".tr,
                      value: _studentDetails
                          .studentData.user.parents.guardiansRelation,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  String buildGuardianPhoto(Parents parents) {
    if (parents.relation == 'Father') {
      if (parents.fathersPhoto == null || parents.fathersPhoto == '') {
        return InfixApi.root + 'public/uploads/staff/demo/staff.jpg';
      } else {
        return "${InfixApi.root}/${parents.fathersPhoto}";
      }
    } else if (parents.relation == 'Mother') {
      if (parents.mothersPhoto == null || parents.mothersPhoto == '') {
        return InfixApi.root + 'public/uploads/staff/demo/staff.jpg';
      } else {
        return "${InfixApi.root}/${parents.mothersPhoto}";
      }
    } else {
      if (parents.guardiansPhoto == null || parents.guardiansPhoto == '') {
        return InfixApi.root + 'public/uploads/staff/demo/staff.jpg';
      } else {
        return "${InfixApi.root}/${parents.guardiansPhoto}";
      }
    }
  }

  Widget getProfileList() {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.symmetric(horizontal: 22),
      color: Colors.white,
      child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 30),
          children: [
            ProfileRowList(
              "Date of birth".tr,
              _studentDetails.studentData.user.dateOfBirth.toString(),
            ),
            ProfileRowList(
              "Age".tr,
              _studentDetails.studentData.user.age.toString(),
            ),
            _studentDetails.studentData.religion != null
                ? ProfileRowList(
                    "Religion".tr,
                    _studentDetails.studentData.religion.name.toString(),
                  )
                : SizedBox.shrink(),
            ProfileRowList(
              "Phone number".tr,
              _studentDetails.studentData.userDetails.phoneNumber.toString(),
            ),
            ProfileRowList(
              "Email address".tr,
              _studentDetails.studentData.user.email.toString(),
            ),
            ProfileRowList(
              "Present address".tr,
              _studentDetails.studentData.user.currentAddress.toString(),
            ),
            ProfileRowList(
              "Permanent address".tr,
              _studentDetails.studentData.user.permanentAddress.toString(),
            ),
            _studentDetails.studentData.bloodGroup != null
                ? ProfileRowList(
                    "Blood group".tr,
                    _studentDetails.studentData.bloodGroup.name.toString(),
                  )
                : SizedBox.shrink(),
          ]),
    );
  }

  Widget getTransportList() {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.symmetric(horizontal: 22),
      color: Colors.white,
      child: _studentDetails.studentData.transport != null
          ? ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 30),
              children: [
                  ProfileRowList(
                    "Drivers name".tr,
                    _studentDetails.studentData.transport.driverName.toString(),
                  ),
                  ProfileRowList(
                    "Car no".tr,
                    _studentDetails.studentData.transport.vehicleNo.toString(),
                  ),
                  ProfileRowList(
                    "Car model".tr,
                    _studentDetails.studentData.transport.vehicleModel
                        .toString(),
                  ),
                  ProfileRowList(
                    "Car info".tr,
                    _studentDetails.studentData.transport.note.toString(),
                  ),
                ])
          : SizedBox.shrink(),
    );
  }

  Widget getOthersList() {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.symmetric(horizontal: 22),
      color: Colors.white,
      child: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 30),
        children: [
          ProfileRowList(
            "Height".tr,
            _studentDetails.studentData.user.height.toString(),
          ),
          ProfileRowList(
            "Weight".tr,
            _studentDetails.studentData.user.weight.toString(),
          ),
          ProfileRowList(
            "National ID Number".tr,
            _studentDetails.studentData.user.nationalIdNo.toString(),
          ),
          ProfileRowList(
            "Local ID Number".tr,
            _studentDetails.studentData.user.localIdNo.toString(),
          ),
          ProfileRowList(
            "Bank Name".tr,
            _studentDetails.studentData.user.bankName.toString(),
          ),
          ProfileRowList(
            "Bank Account Number".tr,
            _studentDetails.studentData.user.bankAccountNo.toString(),
          ),
        ],
      ),
    );
  }

  Widget getDocumentsList() {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.symmetric(horizontal: 22),
      color: Colors.white,
      child: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 30),
        children: [
          _studentDetails.studentData.user.documentFile1 == null ||
                  _studentDetails.studentData.user.documentFile1 == ""
              ? SizedBox.shrink()
              : GestureDetector(
                  onTap: () {
                    showDownloadAlertDialog(
                      context,
                      _studentDetails.studentData.user.documentTitle1,
                      _studentDetails.studentData.user.documentFile1,
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.file_present,
                        size: 20,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        isNullOrEmpty(
                                _studentDetails.studentData.user.documentTitle1)
                            ? ""
                            : _studentDetails.studentData.user.documentTitle1,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: Color(0xff727fc8),
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 15,
          ),
          _studentDetails.studentData.user.documentFile2 == null ||
                  _studentDetails.studentData.user.documentFile2 == ""
              ? SizedBox.shrink()
              : GestureDetector(
                  onTap: () {
                    showDownloadAlertDialog(
                      context,
                      _studentDetails.studentData.user.documentTitle2,
                      _studentDetails.studentData.user.documentFile2,
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.file_present,
                        size: 20,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        isNullOrEmpty(
                                _studentDetails.studentData.user.documentTitle2)
                            ? ""
                            : _studentDetails.studentData.user.documentTitle2,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: Color(0xff727fc8),
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 15,
          ),
          _studentDetails.studentData.user.documentFile3 == null ||
                  _studentDetails.studentData.user.documentFile3 == ""
              ? SizedBox.shrink()
              : GestureDetector(
                  onTap: () {
                    showDownloadAlertDialog(
                      context,
                      _studentDetails.studentData.user.documentTitle3,
                      _studentDetails.studentData.user.documentFile3,
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.file_present,
                        size: 20,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        isNullOrEmpty(
                                _studentDetails.studentData.user.documentTitle3)
                            ? ""
                            : _studentDetails.studentData.user.documentTitle3,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: Color(0xff727fc8),
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 15,
          ),
          _studentDetails.studentData.user.documentFile4 == null ||
                  _studentDetails.studentData.user.documentFile4 == ""
              ? SizedBox.shrink()
              : GestureDetector(
                  onTap: () {
                    showDownloadAlertDialog(
                      context,
                      _studentDetails.studentData.user.documentTitle4,
                      _studentDetails.studentData.user.documentFile4,
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.file_present,
                        size: 20,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        isNullOrEmpty(
                                _studentDetails.studentData.user.documentTitle4)
                            ? ""
                            : _studentDetails.studentData.user.documentTitle4,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: Color(0xFFF39EAA),
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget getProfileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _studentDetails.studentData.userDetails.fullName,
          style: Theme.of(context).textTheme.headline5.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(14),
              ),
        ),
        SizedBox(
          height: 5,
        ),
        Wrap(
          children: List.generate(
            _studentDetails.studentData.userDetails.classSection.length,
            (index) => Text(
              _studentDetails.studentData.userDetails.classSection[index]
                  .toString()
                  .replaceAll(',', ''),
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Color(0xFF93CFC4),
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Admission'.tr +
              ' : ' +
              _studentDetails.studentData.userDetails.admissionNo.toString(),
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Color(0xFFF39EAA),
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
        ),
      ],
    );
  }

  void navigateToPreviousPage(BuildContext context) {
    Navigator.pop(context);
  }

  showDownloadAlertDialog(BuildContext context, String title, String fileUrl) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No".tr),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget yesButton = TextButton(
      child: Text("Download".tr),
      onPressed: () {
        downloadFile(fileUrl, context, title);
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Download".tr,
        style: Theme.of(context).textTheme.headline5,
      ),
      content: Text("Would you like to download the file?".tr),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> downloadFile(
      String url, BuildContext context, String title) async {
    Dio dio = Dio();

    String dirloc = "";
    if (Platform.isAndroid) {
      dirloc = "/sdcard/download/";
    } else {
      dirloc = (await getApplicationSupportDirectory()).path;
    }
    Utils.showToast(dirloc);

    try {
      FileUtils.mkdir([dirloc]);
      Utils.showToast("Downloading...");

      await dio.download(
          InfixApi.root + url, dirloc + AppFunction.getExtention(url),
          options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}),
          onReceiveProgress: (receivedBytes, totalBytes) async {
        received = ((receivedBytes / totalBytes) * 100);
        progress =
            ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
        if (received == 100.0) {
          if (url.contains('.pdf')) {
            Utils.showToast(
                "Download Completed. File is also available in your download folder."
                    .tr);
            Navigator.push(
                context,
                ScaleRoute(
                    page: DownloadViewer(
                        title: title, filePath: InfixApi.root + url)));
          } else {
            // ignore: deprecated_member_use
            await canLaunch(InfixApi.root + url)
                // ignore: deprecated_member_use
                ? await launch(InfixApi.root + url)
                : throw 'Could not launch ${InfixApi.root + url}';
          }
          Utils.showToast(
              "Download Completed. File is also available in your download folder."
                  .tr);
        }
      });
    } catch (e) {
      print(e);
    }
    progress =
        "Download Completed.Go to the download folder to find the file".tr;
  }
}

class ParentsDetailsRow extends StatelessWidget {
  final String title;
  final String value;

  ParentsDetailsRow({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: Color(0xFFF39EAA),
                        fontWeight: FontWeight.normal,
                        fontSize: ScreenUtil().setSp(12),
                      ),
                ),
                SizedBox(
                  height: 12.0.h,
                ),
                Container(
                  height: 0.2.h,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFF39EAA),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNullOrEmpty(value) ? "" : value,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: Color(0xFFF39EAA),
                        fontWeight: FontWeight.normal,
                        fontSize: ScreenUtil().setSp(12),
                      ),
                ),
                SizedBox(
                  height: 12.0.h,
                ),
                Container(
                  height: 0.2.h,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF828BB2),
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

bool isNullOrEmpty(Object o) => o == null || o == "";
