// Package imports:
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:infixedu/screens/admin/Repository/StaffRepository.dart';
import 'package:infixedu/utils/model/LeaveAdmin.dart';

class StuffLeaveListBloc {
  String url;
  String endPoint;

  StuffLeaveListBloc(this.url, this.endPoint);

  final _repository = StaffRepository();

  final _subject = BehaviorSubject<LeaveAdminList>();

  getStaffLeaveList() async {
    LeaveAdminList list = await _repository.getStaffLeave(url, endPoint);
    _subject.sink.add(list);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<LeaveAdminList> get getStaffLeaveSubject => _subject;
}
