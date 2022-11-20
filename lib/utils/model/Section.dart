class Section {
  String name;
  int id;

  Section({this.name, this.id});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      name: json['section_name'],
      id: json['section_id'] is int
          ? json['section_id']
          : int.parse(
              json['section_id'],
            ),
    );
  }
}

class SectionList {
  List<Section> sections = [];

  SectionList(this.sections);

  factory SectionList.fromJson(List<dynamic> json) {
    List<Section> sectionList;

    sectionList = json.map((i) => Section.fromJson(i)).toList();

    return SectionList(sectionList);
  }
}
