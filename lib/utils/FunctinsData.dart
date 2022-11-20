// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:

import 'package:infixedu/screens/AboutScreen.dart';
import 'package:infixedu/screens/Home.dart';
import 'package:infixedu/screens/SettingsScreen.dart';
import 'package:infixedu/screens/admin/AdminAttendanceScreen.dart';
import 'package:infixedu/screens/admin/dormitoryAndRoom/AdminAddDormitory.dart';
import 'package:infixedu/screens/admin/dormitoryAndRoom/AdminAddRoom.dart';
import 'package:infixedu/screens/admin/dormitoryAndRoom/AdminDormitoryScreen.dart';
import 'package:infixedu/screens/admin/leave/AdminLeaveHomeScreen.dart';
import 'package:infixedu/screens/admin/library/AddLibraryBook.dart';
import 'package:infixedu/screens/admin/library/AdminAddMember.dart';
import 'package:infixedu/screens/admin/library/AdminLibraryScreen.dart';
import 'package:infixedu/screens/admin/notice/StaffNoticeScreen.dart';
import 'package:infixedu/screens/admin/staff/AdminStaffList.dart';
import 'package:infixedu/screens/admin/transport/AddRouteScreen.dart';
import 'package:infixedu/screens/admin/transport/AdminAddVehicle.dart';
import 'package:infixedu/screens/admin/transport/AdminTransportScreen.dart';
import 'package:infixedu/screens/admin/transport/AssignVehicle.dart';
import 'package:infixedu/screens/fees/fees_admin/AddFeeType.dart';
import 'package:infixedu/screens/fees/fees_admin/AdminFeeList.dart';
import 'package:infixedu/screens/fees/fees_admin/AdminFeesHome.dart';
import 'package:infixedu/screens/fees/fees_admin/fees_admin_new/bank_payment.dart';
import 'package:infixedu/screens/fees/fees_admin/fees_admin_new/fee_group.dart';
import 'package:infixedu/screens/fees/fees_admin/fees_admin_new/fee_invoice.dart';
import 'package:infixedu/screens/fees/fees_admin/fees_admin_new/fee_type.dart';
import 'package:infixedu/screens/fees/fees_admin/reports/fees_balance_report.dart';
import 'package:infixedu/screens/fees/fees_admin/reports/fees_dues_report.dart';
import 'package:infixedu/screens/fees/fees_admin/reports/fees_fine_report.dart';
import 'package:infixedu/screens/fees/fees_admin/reports/fees_payment_report.dart';
import 'package:infixedu/screens/fees/fees_admin/reports/fees_waiver_report.dart';
import 'package:infixedu/screens/fees/fees_admin/reports/report_main.dart';
import 'package:infixedu/screens/lessonPlan/student/views/StudentLessonsView.dart';
import 'package:infixedu/screens/main/DashboardScreen.dart';
import 'package:infixedu/screens/parent/ChildListScreen.dart';
import 'package:infixedu/screens/student/DailyReport.dart';
import 'package:infixedu/screens/student/Dormitory.dart';
import 'package:infixedu/screens/student/Profile.dart';
import 'package:infixedu/screens/student/Routine.dart';
import 'package:infixedu/screens/student/StudentAttendance.dart';
import 'package:infixedu/screens/student/StudentGallery.dart';
import 'package:infixedu/screens/student/StudentTeacher.dart';
import 'package:infixedu/screens/student/SubjectScreen.dart';
import 'package:infixedu/screens/student/TimeLineScreen.dart';
import 'package:infixedu/screens/student/TransportScreen.dart';
import 'package:infixedu/screens/student/examination/ClassExamResult.dart';
import 'package:infixedu/screens/student/examination/ExaminationScreen.dart';
import 'package:infixedu/screens/student/examination/ScheduleScreen.dart';
import 'package:infixedu/screens/student/homework/StudentHomework.dart';
import 'package:infixedu/screens/student/leave/LeaveListStudent.dart';
import 'package:infixedu/screens/student/leave/LeaveStudentApply.dart';
import 'package:infixedu/screens/student/leave/LeaveStudentHome.dart';
import 'package:infixedu/screens/student/library/BookIssuedScreen.dart';
import 'package:infixedu/screens/student/library/BookListScreen.dart';
import 'package:infixedu/screens/student/library/LibraryScreen.dart';
import 'package:infixedu/screens/student/notice/NoticeScreen.dart';
import 'package:infixedu/screens/student/onlineExam/ActiveOnlineExamScreen.dart';
import 'package:infixedu/screens/student/onlineExam/OnlineExamResultScreen.dart';
import 'package:infixedu/screens/student/onlineExam/OnlineExamScreen.dart';
import 'package:infixedu/screens/student/onlineExam/module/view/ActiveOnlineExamsModule.dart';
import 'package:infixedu/screens/student/onlineExam/module/view/OnlineExamResultsModule.dart';
import 'package:infixedu/screens/student/studyMaterials/StudyMaterialScreen.dart';
import 'package:infixedu/screens/student/studyMaterials/StydyMaterialMain.dart';
import 'package:infixedu/screens/teacher/ClassAttendanceHome.dart';
import 'package:infixedu/screens/teacher/TeacherMyAttendance.dart';
import 'package:infixedu/screens/teacher/academic/AcademicsScreen.dart';
import 'package:infixedu/screens/teacher/academic/MySubjectScreen.dart';
import 'package:infixedu/screens/teacher/academic/SearchClassRoutine.dart';
import 'package:infixedu/screens/teacher/academic/TeacherRoutineScreen.dart';
import 'package:infixedu/screens/teacher/attendance/AttendanceScreen.dart';
import 'package:infixedu/screens/teacher/content/AddContentScreen.dart';
import 'package:infixedu/screens/teacher/content/ContentListScreen.dart';
import 'package:infixedu/screens/teacher/content/ContentScreen.dart';
import 'package:infixedu/screens/teacher/homework/AddHomeworkScreen.dart';
import 'package:infixedu/screens/teacher/homework/HomeworkScreen.dart';
import 'package:infixedu/screens/teacher/homework/TeacherHomeworkListScreen.dart';
import 'package:infixedu/screens/teacher/leave/ApplyLeaveScreen.dart';
import 'package:infixedu/screens/teacher/leave/LeaveListScreen.dart';
import 'package:infixedu/screens/teacher/leave/LeaveScreen.dart';
import 'package:infixedu/screens/teacher/students/StudentSearch.dart';
import 'package:infixedu/screens/wallet/student/views/StudentWalletTransactions.dart';
import 'package:infixedu/screens/zoom/virtual_class.dart';
import 'package:infixedu/utils/model/SystemSettings.dart';

import 'package:infixedu/utils/widget/ScaleRoute.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class AppFunction {
  static var students = [
    'DailyReport',

    'Notice',
    // 'Homework',
    // 'Study Materials',
    // 'Timeline',
    'Attendance',
    // 'Wallet',
    // 'Examination',
    // 'Online Exam',
    // 'Lesson',
    'Leave',
    // 'Subjects',
    'Teacher',
    'StudentGallery',

    // 'Library',
    // 'Transport',
    // 'Dormitory',
    'Settings',
  ];
  static var studentIcons = [
    'assets/images/examination.png',
    'assets/images/notice.png',
    // 'assets/images/homework.png',
    // 'assets/images/downloads.png',
    // 'assets/images/timeline.png',
    'assets/images/attendance.png',
    // 'assets/images/fees_icon.png',
    // 'assets/images/examination.png',
    // 'assets/images/onlineexam.png',
    // 'assets/images/routine.png',
    'assets/images/leave.png',
    // 'assets/images/subjects.png',
    'assets/images/teacher.png',
    // 'assets/images/library.png',
    // 'assets/images/transport.png',
    // 'assets/images/dormitory.png',
    'assets/images/downloads.png',

    'assets/images/addhw.png',
  ];

  static var teachers = [
    'Students',
    // 'Academic',
    'Attendance',
    'Leave',
    // 'Contents',
    'Notice',
    'Library',
    // 'Homework',
    // 'About',
    'Settings',
  ];

  static var teachersIcons = [
    'assets/images/students.png',
    // 'assets/images/academics.png',
    'assets/images/attendance.png',
    'assets/images/leave.png',
    // 'assets/images/contents.png',
    'assets/images/notice.png',
    'assets/images/library.png',
    // 'assets/images/homework.png',
    // 'assets/images/about.png',
    'assets/images/addhw.png',
  ];

  static var admins = [
    'Students',
    'Leave',
    'Staff',
    'Dormitory',
    'Attendance',
    'Fees',
    'Contents',
    'Notice',
    'Library',
    'Transport',
    'Settings',
  ];
  static var adminIcons = [
    'assets/images/students.png',
    'assets/images/leave.png',
    'assets/images/staff.png',
    'assets/images/dormitory.png',
    'assets/images/attendance.png',
    'assets/images/fees_icon.png',
    'assets/images/contents.png',
    'assets/images/notice.png',
    'assets/images/library.png',
    'assets/images/transport.png',
    'assets/images/addhw.png',
  ];

  static var parent = [
    'Child',
    'About',
    'Settings',
  ];
  static var parentIcons = [
    'assets/images/mychild.png',
    'assets/images/about.png',
    'assets/images/addhw.png',
  ];

  static var parent2 = [
    'Child',
    'About',
    'Settings',
  ];

  static var parentIcons2 = [
    'assets/images/mychild.png',
    'assets/images/about.png',
    'assets/images/addhw.png',
  ];

  static var adminTransport = [
    'Route',
    'Vehicle',
    'Assign Vehicle',
    'Transport',
  ];
  static var adminTransportIcons = [
    'assets/images/transport.png',
    'assets/images/transport.png',
    'assets/images/addhw.png',
    'assets/images/transport.png',
  ];

  static var adminDormitory = [
    'Add Dormitory',
    'Add Room',
    'Room List',
  ];
  static var adminDormitoryIcons = [
    'assets/images/addhw.png',
    'assets/images/addhw.png',
    'assets/images/dormitory.png',
  ];

  static var librarys = [
    'Book List',
    'Books Issued',
  ];
  static var libraryIcons = [
    'assets/images/library.png',
    'assets/images/library.png',
  ];
  static var examinations = [
    'Schedule',
    'Result',
  ];
  static var examinationIcons = [
    'assets/images/examination.png',
    'assets/images/examination.png',
  ];

  static var onlineExaminations = [
    'Active Exam',
    'Exam Result',
  ];
  static var onlineExaminationIcons = [
    'assets/images/onlineexam.png',
    'assets/images/onlineexam.png',
  ];

  static var homework = [
    'Add HW',
    'HW List',
  ];
  static var homeworkIcons = [
    'assets/images/addhw.png',
    'assets/images/hwlist.png',
  ];

  static var zoomMeeting = [
    'Virtual Class',
    'meeting',
  ];
  static var zoomMeetingIcons = [
    'assets/images/addhw.png',
    'assets/images/hwlist.png',
  ];

  static var contents = [
    'Add Content',
    'Content List',
  ];
  static var contentsIcons = [
    'assets/images/addhw.png',
    'assets/images/hwlist.png',
  ];

  static var leaves = [
    'Apply Leave',
    'Leave List',
  ];
  static var leavesIcons = [
    'assets/images/hwlist.png',
    'assets/images/addhw.png',
  ];

  static var adminLibrary = [
    'Add Book',
    'Book List',
    'Add Member',
  ];
  static var adminLibraryIcons = [
    'assets/images/addhw.png',
    'assets/images/hwlist.png',
    'assets/images/addhw.png',
  ];

  static var academics = [
    'My Routine',
    'Class Routine',
    'Subjects',
  ];
  static var academicsIcons = [
    'assets/images/myroutine.png',
    'assets/images/classroutine.png',
    'assets/images/subjects.png',
  ];

  static var attendance = [
    'Class Atten',
    'Search Atten',
  ];
  static var attendanceIcons = [
    'assets/images/classattendance.png',
    'assets/images/searchattendance.png',
  ];

  static var downloadLists = [
    'Assignment',
    'Syllabus',
    'Other Downloads',
  ];
  static var downloadListIcons = [
    'assets/images/downloads.png',
    'assets/images/downloads.png',
    'assets/images/downloads.png',
  ];

  static var studentLeaves = [
    'Apply Leave',
    'Leave List',
  ];

  static var studentLeavesIcons = [
    'assets/images/hwlist.png',
    'assets/images/addhw.png',
  ];

  static var studentLessonPlan = [
    'Lesson Plan',
    'Overview',
  ];

  static var studentLessonPlanIcons = [
    'assets/images/routine.png',
    'assets/images/routine.png',
  ];

  static var adminFees = [
    'Add Fee',
    'Fee List',
  ];
  static var adminFeeIcons = [
    'assets/images/fees_icon.png',
    'assets/images/addhw.png',
  ];
  static var adminFeesNew = [
    'Fee Group',
    'Fee Type',
    'Fee Invoice',
    'Bank Payment',
    'Reports',
  ];
  static var adminFeeIconsNew = [
    'assets/images/fees_icon.png',
    'assets/images/fees_icon.png',
    'assets/images/fees_icon.png',
    'assets/images/fees_icon.png',
    'assets/images/fees_icon.png',
  ];

  static var adminFeesReport = [
    'Due Report',
    'Fine Report',
    'Payment Report',
    'Balance Report',
    'Waiver Report',
  ];

  static var driver = [
    'Transport',
    'About',
    'Settings',
  ];
  static var driverIcons = [
    'assets/images/transport.png',
    'assets/images/about.png',
    'assets/images/addhw.png',
  ];

  static void getFunctions(BuildContext context, String rule, String zoom) {
    Route route;

    switch (rule) {
      case '1':
        route = ScaleRoute(page: Home(admins, adminIcons, rule));
        Navigator.of(context, rootNavigator: true)
            .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
        break;

      case '2':
        route = ScaleRoute(page: DashboardScreen(students, studentIcons, rule));
        Navigator.of(context, rootNavigator: true)
            .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
        break;
      case '3':
        route = ScaleRoute(page: Home(parent, parentIcons, rule));
        Navigator.of(context, rootNavigator: true)
            .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
        break;
      case '4':
        route =
            ScaleRoute(page: DashboardScreen(teachers, teachersIcons, rule));
        Navigator.of(context, rootNavigator: true)
            .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
        break;
      case '5':
        route = ScaleRoute(page: Home(admins, adminIcons, rule));
        Navigator.of(context, rootNavigator: true)
            .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
        break;
      case '9':
        route = ScaleRoute(page: Home(driver, driverIcons, rule));
        Navigator.of(context, rootNavigator: true)
            .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
        break;
    }
  }

  static void getDashboardPage(BuildContext context, String title,
      {var id, String image, int zoom, String token}) {
    switch (title) {
      case 'Profile':
        Navigator.push(
            context,
            ScaleRoute(
                page: Profile(
              id: id,
              image: image,
            )));
        break;
      case 'Wallet':
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: StudentWalletTransactions(),
          withNavBar: false,
        );
        break;
      case 'Routine':
        Navigator.push(context, ScaleRoute(page: Routine(id: id)));
        break;
      case 'Homework':
        Navigator.push(context, ScaleRoute(page: StudentHomework(id: id)));
        break;
      case 'Study Materials':
        Navigator.push(
            context,
            ScaleRoute(
                page: DownloadsHome(downloadLists, downloadListIcons, id: id)));
        break;
      case 'Leave':
        Navigator.push(
            context,
            ScaleRoute(
                page: LeaveStudentHome(studentLeaves, studentLeavesIcons,
                    id: id)));
        break;
      case 'Dormitory':
        Navigator.push(context, ScaleRoute(page: DormitoryScreen()));
        break;
      case 'Transport':
        Navigator.push(context, ScaleRoute(page: TransportScreen()));
        break;
      case 'Subjects':
        Navigator.push(
            context,
            ScaleRoute(
                page: SubjectScreen(
              id: id,
            )));
        break;
      case 'Teacher':
        Navigator.push(
            context,
            ScaleRoute(
                page: StudentTeacher(
              id: id,
              token: token,
            )));
        break;
      case 'Library':
        Navigator.push(
            context,
            ScaleRoute(
                page: LibraryHome(
              librarys,
              libraryIcons,
              id: id,
            )));
        break;
      case 'Zoom':
        Navigator.push(
            context,
            ScaleRoute(
                page: VirtualClassScreen(
              uid: id,
            )));
        break;
      case 'Notice':
        Navigator.push(context, ScaleRoute(page: NoticeScreen()));
        break;
      case 'Timeline':
        Navigator.push(context, ScaleRoute(page: TimelineScreen(id: id)));
        break;
      case 'Examination':
        Navigator.push(
            context,
            ScaleRoute(
                page: ExaminationHome(
              examinations,
              examinationIcons,
              id: id,
            )));
        break;
      case 'Online Exam':
        Navigator.push(
            context,
            ScaleRoute(
                page: OnlineExaminationHome(
              onlineExaminations,
              onlineExaminationIcons,
              id: id,
            )));
        break;
      case 'Attendance':
        Navigator.push(context,
            ScaleRoute(page: StudentAttendanceScreen(id: id, token: token)));
        break;
      case 'Settings':
        Navigator.push(context, ScaleRoute(page: SettingScreen()));
        break;
      case 'StudentGallery':
        Navigator.push(context, ScaleRoute(page: StudentGallery()));
        break;
      case 'DailyReport':
        Navigator.push(context, ScaleRoute(page: DailyReportScreen()));
        break;
      case 'Lesson':
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: StudentLessonsView(id),
          withNavBar: false,
        );
        break;
    }
  }

  static void getAdminDashboardPage(BuildContext context, String title,
      String uid, SystemSettings systemSettings) {
    switch (title) {
      case 'Students':
        Navigator.push(context, ScaleRoute(page: StudentSearch()));
        break;
      case 'Fees':
        if (systemSettings.data.feesStatus == 0) {
          Navigator.push(context,
              ScaleRoute(page: AdminFeesHome(adminFees, adminFeeIcons)));
        } else {
          Navigator.push(context,
              ScaleRoute(page: AdminFeesHome(adminFeesNew, adminFeeIconsNew)));
        }
        break;
      case 'Library':
        Navigator.push(
            context,
            ScaleRoute(
                page: AdminLibraryHome(adminLibrary, adminLibraryIcons)));
        break;
      case 'Attendance':
        Navigator.push(
            context,
            ScaleRoute(
                page: AdminAttendanceHomeScreen(attendance, attendanceIcons)));
        break;
      case 'Transport':
        Navigator.push(
            context,
            ScaleRoute(
                page: AdminTransportHome(adminTransport, adminTransportIcons)));
        break;
      case 'Staff':
        Navigator.push(context, ScaleRoute(page: AdminStaffList()));
        break;
      case 'Contents':
        Navigator.push(context,
            ScaleRoute(page: ContentHomeScreen(contents, contentsIcons)));
        break;
      case 'Notice':
        Navigator.push(context, ScaleRoute(page: StaffNoticeScreen()));
        break;
      case 'Dormitory':
        Navigator.push(
            context,
            ScaleRoute(
                page: AdminDormitoryHome(adminDormitory, adminDormitoryIcons)));
        break;
      case 'Leave':
        Navigator.push(context, ScaleRoute(page: LeaveAdminHomeScreen()));
        break;
      case 'Settings':
        Navigator.push(context, ScaleRoute(page: SettingScreen()));
        break;
    }
  }

  static void getSaasAdminDashboardPage(BuildContext context, String title,
      String uid, SystemSettings systemSettings) {
    switch (title) {
      case 'Students':
        Navigator.push(context, ScaleRoute(page: StudentSearch()));
        break;
      case 'Fees':
        if (systemSettings.data.feesStatus == 0) {
          Navigator.push(context,
              ScaleRoute(page: AdminFeesHome(adminFees, adminFeeIcons)));
        } else {
          Navigator.push(context,
              ScaleRoute(page: AdminFeesHome(adminFeesNew, adminFeeIconsNew)));
        }
        break;
      case 'Library':
        Navigator.push(
            context,
            ScaleRoute(
                page: AdminLibraryHome(adminLibrary, adminLibraryIcons)));
        break;
      case 'Attendance':
        Navigator.push(
            context,
            ScaleRoute(
                page: AttendanceHomeScreen(attendance, attendanceIcons)));
        break;
      case 'Contents':
        Navigator.push(context,
            ScaleRoute(page: ContentHomeScreen(contents, contentsIcons)));
        break;
      case 'Transport':
        Navigator.push(
            context,
            ScaleRoute(
                page: AdminTransportHome(adminTransport, adminTransportIcons)));
        break;
      case 'Staff':
        Navigator.push(context, ScaleRoute(page: AdminStaffList()));
        break;
      case 'Dormitory':
        Navigator.push(
            context,
            ScaleRoute(
                page: AdminDormitoryHome(adminDormitory, adminDormitoryIcons)));
        break;
      case 'Notice':
        Navigator.push(context, ScaleRoute(page: StaffNoticeScreen()));
        break;
      case 'Leave':
        Navigator.push(context, ScaleRoute(page: LeaveAdminHomeScreen()));
        break;
      case 'Settings':
        Navigator.push(context, ScaleRoute(page: SettingScreen()));
        break;
    }
  }

  static void getAdminFeePage(BuildContext context, String title) {
    switch (title) {
      case 'Add Fee':
        Navigator.push(context, ScaleRoute(page: AddFeeType()));
        break;
      case 'Fee List':
        Navigator.push(context, ScaleRoute(page: AdminFeeListView()));
        break;
    }
  }

  static void getAdminFeePageNew(BuildContext context, String title) {
    switch (title) {
      case 'Fee Group':
        Navigator.push(context, ScaleRoute(page: FeesGroupScreen()));
        break;
      case 'Fee Type':
        Navigator.push(context, ScaleRoute(page: FeesTypeScreen()));
        break;
      case 'Fee Invoice':
        Navigator.push(context, ScaleRoute(page: FeesInvoiceScreen()));
        break;
      case 'Bank Payment':
        Navigator.push(context, ScaleRoute(page: FeeBankPaymentSearch()));
        break;
      case 'Reports':
        Navigator.push(
            context,
            ScaleRoute(
                page: AdminFeesReportMain(adminFeesReport, adminFeeIconsNew)));
        break;
    }
  }

  static void getAdminFeesReportPage(BuildContext context, String title) {
    switch (title) {
      case 'Due Report':
        Navigator.push(context, ScaleRoute(page: AdminFeesDueReport()));
        break;
      case 'Fine Report':
        Navigator.push(context, ScaleRoute(page: AdminFeesFineReport()));
        break;
      case 'Payment Report':
        Navigator.push(context, ScaleRoute(page: AdminFeesPaymentReport()));
        break;
      case 'Balance Report':
        Navigator.push(context, ScaleRoute(page: AdminFeesBalanceReport()));
        break;
      case 'Waiver Report':
        Navigator.push(context, ScaleRoute(page: AdminFeesWaiverReport()));
        break;
    }
  }

  static void getAdminLibraryPage(BuildContext context, String title) {
    switch (title) {
      case 'Add Book':
        Navigator.push(context, ScaleRoute(page: AddAdminBook()));
        break;
      case 'Add Member':
        Navigator.push(context, ScaleRoute(page: AddMember()));
        break;
      case 'Book List':
        Navigator.push(context, ScaleRoute(page: BookListScreen()));
        break;
    }
  }

  static void getAdminDormitoryPage(BuildContext context, String title) {
    switch (title) {
      case 'Room List':
        Navigator.push(context, ScaleRoute(page: DormitoryScreen()));
        break;
      case 'Add Room':
        Navigator.push(context, ScaleRoute(page: AddRoom()));
        break;
      case 'Add Dormitory':
        Navigator.push(context, ScaleRoute(page: AddDormitory()));
        break;
    }
  }

  static void getAdminTransportPage(BuildContext context, String title) {
    switch (title) {
      case 'Route':
        Navigator.push(context, ScaleRoute(page: AddRoute()));
        break;
      case 'Vehicle':
        Navigator.push(context, ScaleRoute(page: AddVehicle()));
        break;
      case 'Assign Vehicle':
        Navigator.push(context, ScaleRoute(page: AssignVehicle()));
        break;
      case 'Transport':
        Navigator.push(context, ScaleRoute(page: TransportScreen()));
        break;
    }
  }

  static void getTeacherDashboardPage(
      BuildContext context, String title, String uid) {
    switch (title) {
      case 'Students':
        Navigator.push(context, ScaleRoute(page: StudentSearch()));
        break;
      case 'Academic':
        Navigator.push(context,
            ScaleRoute(page: AcademicHomeScreen(academics, academicsIcons)));
        break;
      case 'Attendance':
        Navigator.push(
            context,
            ScaleRoute(
                page: AttendanceHomeScreen(attendance, attendanceIcons)));
        break;
      case 'Homework':
        Navigator.push(context,
            ScaleRoute(page: HomeworkHomeScreen(homework, homeworkIcons)));
        break;
      case 'Contents':
        Navigator.push(context,
            ScaleRoute(page: ContentHomeScreen(contents, contentsIcons)));
        break;
      case 'Leave':
        Navigator.push(
            context, ScaleRoute(page: LeaveHomeScreen(leaves, leavesIcons)));
        break;
      case 'Library':
        Navigator.push(context, ScaleRoute(page: BookListScreen()));
        break;
      case 'Notice':
        Navigator.push(context, ScaleRoute(page: StaffNoticeScreen()));
        break;
      case 'About':
        Navigator.push(context, ScaleRoute(page: AboutScreen()));
        break;
      case 'Settings':
        Navigator.push(context, ScaleRoute(page: SettingScreen()));
        break;
      // case 'Zoom':
      //   Navigator.push(
      //       context,
      //       ScaleRoute(
      //           page: VirtualMeetingScreen(
      //             uid: uid,
      //           )));
      //   break;
    }
  }

  static void getParentDashboardPage(
      BuildContext context, String title, String uid) {
    switch (title) {
      case 'Child':
        Navigator.push(context, ScaleRoute(page: ChildListScreen()));
        break;
      case 'About':
        Navigator.push(context, ScaleRoute(page: AboutScreen()));
        break;
      case 'Settings':
        Navigator.push(context, ScaleRoute(page: SettingScreen()));
        break;
      // case 'Zoom':
      //   Navigator.push(
      //       context,
      //       ScaleRoute(
      //           page: VirtualMeetingScreen(
      //             uid: uid,
      //           )));
      //   break;
    }
  }

  static void getAttendanceDashboardPage(BuildContext context, String title) {
    switch (title) {
      case 'Class Atten':
        Navigator.push(context, ScaleRoute(page: StudentAttendanceHome()));
        break;
      case 'Search Atten':
        Navigator.push(
            context,
            ScaleRoute(
                page: StudentSearch(
              status: 'attendance',
            )));
        break;
      case 'My Atten':
        Navigator.push(context, ScaleRoute(page: TeacherAttendanceScreen()));
        break;
    }
  }

  static void getAdminAttendanceDashboardPage(
      BuildContext context, String title) {
    switch (title) {
      case 'Class Atten':
        Navigator.push(context, ScaleRoute(page: StudentAttendanceHome()));
        break;
      case 'Search Atten':
        Navigator.push(
            context,
            ScaleRoute(
                page: StudentSearch(
              status: 'attendance',
            )));
        break;
    }
  }

  static void getAcademicDashboardPage(BuildContext context, String title) {
    switch (title) {
      case 'Subjects':
        Navigator.push(context, ScaleRoute(page: MySubjectScreen()));
        break;
      case 'Class Routine':
        Navigator.push(context, ScaleRoute(page: SearchRoutineScreen()));
        break;
      case 'My Routine':
        Navigator.push(context, ScaleRoute(page: TeacherMyRoutineScreen()));
        break;
    }
  }

  static void getLibraryDashboardPage(BuildContext context, String title,
      {var id}) {
    switch (title) {
      case 'Book List':
        Navigator.push(context, ScaleRoute(page: BookListScreen()));
        break;
      case 'Books Issued':
        Navigator.push(
            context,
            ScaleRoute(
                page: BookIssuedScreen(
              id: id,
            )));
        break;
    }
  }

  static void getHomeworkDashboardPage(BuildContext context, String title) {
    switch (title) {
      case 'HW List':
        Navigator.push(context, ScaleRoute(page: TeacherHomework()));
        break;
      case 'Add HW':
        Navigator.push(context, ScaleRoute(page: AddHomeworkScrren()));
        break;
    }
  }

  static void getContentDashboardPage(BuildContext context, String title) {
    switch (title) {
      case 'Content List':
        Navigator.push(context, ScaleRoute(page: ContentListScreen()));
        break;
      case 'Add Content':
        Navigator.push(context, ScaleRoute(page: AddContentScreeen()));
        break;
    }
  }

  static void getLeaveDashboardPage(BuildContext context, String title) {
    switch (title) {
      case 'Leave List':
        Navigator.push(context, ScaleRoute(page: LeaveListScreen()));
        break;
      case 'Apply Leave':
        Navigator.push(context, ScaleRoute(page: ApplyLeaveScreen()));
        break;
    }
  }

  static void getExaminationDashboardPage(BuildContext context, String title,
      {var id}) {
    switch (title) {
      case 'Schedule':
        Navigator.push(
            context,
            ScaleRoute(
                page: ScheduleScreen(
              id: id,
            )));
        break;
      case 'Result':
        Navigator.push(
            context,
            ScaleRoute(
                page: ClassExamResultScreen(
              id: id,
            )));
        break;
    }
  }

  static void getDownloadsDashboardPage(BuildContext context, String title,
      {var id}) {
    switch (title) {
      case 'Assignment':
        Navigator.push(
            context,
            ScaleRoute(
                page: StudentStudyMaterialMain(
              id: id,
              type: 'as',
            )));
        break;
      case 'Syllabus':
        Navigator.push(context,
            ScaleRoute(page: StudentStudyMaterialMain(id: id, type: 'sy')));
        break;
      case 'Other Downloads':
        Navigator.push(context,
            ScaleRoute(page: StudentStudyMaterialMain(id: id, type: 'ot')));
        break;
    }
  }

  static void getStudentLeaveDashboardPage(BuildContext context, String title,
      {var id}) {
    switch (title) {
      case 'Apply Leave':
        Navigator.push(context, ScaleRoute(page: LeaveStudentApply(id)));
        break;
      case 'Leave List':
        Navigator.push(
            context,
            ScaleRoute(
                page: LeaveListStudent(
              id: id,
            )));
        break;
    }
  }

  static void getOnlineExaminationDashboardPage(
      BuildContext context, String title,
      {var id}) {
    switch (title) {
      case 'Active Exam':
        Navigator.push(
            context,
            ScaleRoute(
                page: ActiveOnlineExamScreen(
              id: id,
            )));
        break;
      case 'Exam Result':
        Navigator.push(
            context,
            ScaleRoute(
                page: OnlineExamResultScreen(
              id: id,
            )));
        break;
    }
  }

  static void getOnlineExaminationModuleDashboardPage(
      BuildContext context, String title,
      {var id}) {
    switch (title) {
      case 'Active Exam':
        Navigator.push(
            context,
            ScaleRoute(
                page: ActiveOnlineExams(
              id: id,
            )));
        break;
      case 'Exam Result':
        Navigator.push(
            context,
            ScaleRoute(
                page: OnlineExamResults(
              id: id,
            )));
        break;
    }
  }

  static void getDriverDashboard(BuildContext context, String title, String uid,
      SystemSettings systemSettings) {
    switch (title) {
      case 'Transport':
        Navigator.push(
            context,
            ScaleRoute(
                page: AdminTransportHome(adminTransport, adminTransportIcons)));
        break;
      case 'About':
        Navigator.push(context, ScaleRoute(page: AboutScreen()));
        break;
      case 'Settings':
        Navigator.push(context, ScaleRoute(page: SettingScreen()));
        break;
    }
  }

  static String getContentType(String ctype) {
    String type = '';
    switch (ctype) {
      case 'as':
        type = 'assignment';
        break;
      case 'st':
        type = 'study material';
        break;
      case 'sy':
        type = 'syllabus';
        break;
      case 'ot':
        type = 'others download';
        break;
    }
    return type;
  }

  static var weeks = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  static void getStudentLessonPlanDashboard(BuildContext context, String title,
      {var id}) {
    switch (title) {
      case 'Lesson Plan':
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: StudentLessonsView(id),
          withNavBar: false,
        );
        break;
      case 'Overview':
        Navigator.push(context, ScaleRoute(page: StudentLessonsView(id)));
        break;
    }
  }

  //formet time
  static String getAmPm(String time) {
    var parts = time.split(":");
    String part1 = parts[0];
    String part2 = parts[1];

    int hr = int.parse(part1);
    int min = int.parse(part2);

    if (hr <= 12) {
      if (hr == 10 || hr == 11 || hr == 12) {
        return "$hr:$min" + "am";
      }
      return "0$hr:$min" + "am";
    } else {
      hr = hr - 12;
      return "0$hr:$min" + "pm";
    }
  }

  static String getExtention(String url) {
    var parts = url.split("/");
    return parts[parts.length - 1];
  }

  //return day of month
  static String getDay(String date) {
    var parts = date.split("-");
    return parts[parts.length - 1];
  }
}
