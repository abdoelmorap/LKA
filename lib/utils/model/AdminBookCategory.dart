class Admincategory {
  String title;
  dynamic id;

  Admincategory({this.title, this.id});

  factory Admincategory.fromJson(Map<String, dynamic> json) {
    return Admincategory(
      title: json['category_name'],
      id: json['id'],
    );
  }
}

class AdminCategoryList {
  List<Admincategory> categories;

  AdminCategoryList(this.categories);

  factory AdminCategoryList.fromJson(List<dynamic> json) {
    List<Admincategory> subjects = [];

    subjects = json.map((i) => Admincategory.fromJson(i)).toList();

    return AdminCategoryList(subjects);
  }
}
