class LibraryMember {
  dynamic id;
  String name;

  LibraryMember({this.id, this.name});

  factory LibraryMember.fromJson(Map<String, dynamic> json) {
    return LibraryMember(id: json['id'], name: json['name']);
  }
}

class LibraryMemberList {
  List<LibraryMember> members;

  LibraryMemberList(this.members);

  factory LibraryMemberList.fromJson(List<dynamic> json) {
    List<LibraryMember> memberList = [];

    memberList = json.map((i) => LibraryMember.fromJson(i)).toList();

    return LibraryMemberList(memberList);
  }
}
