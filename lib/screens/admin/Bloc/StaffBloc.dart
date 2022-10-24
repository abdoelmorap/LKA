// Package imports:
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:infixedu/screens/admin/Repository/StaffRepository.dart';
import 'package:infixedu/utils/model/LibraryCategoryMember.dart';

class StaffBloc {
  final _repository = StaffRepository();

  final _subject = BehaviorSubject<LibraryMemberList>();

  getStaff() async {
    LibraryMemberList members = await _repository.getStaff();
    _subject.sink.add(members);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<LibraryMemberList> get subject => _subject;
}

final bloc = StaffBloc();
