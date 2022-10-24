// Project imports:
import 'package:infixedu/screens/admin/ApiProvider/StaffApiProvider.dart';
import 'package:infixedu/utils/model/LeaveAdmin.dart';
import 'package:infixedu/utils/model/LibraryCategoryMember.dart';
import 'package:infixedu/utils/model/Staff.dart';

class StaffRepository {
  StaffApiProvider _provider = StaffApiProvider();

  Future<LibraryMemberList> getStaff() {
    return _provider.getAllCategory();
  }

  Future<StaffList> getStaffList(int id) {
    return _provider.getAllStaff(id);
  }

  Future<LeaveAdminList> getStaffLeave(String url, String endPoint) {
    return _provider.getAllLeave(url, endPoint);
  }
}
