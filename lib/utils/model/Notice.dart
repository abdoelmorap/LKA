class Notice {
  String title;
  String date;
  String destails;

  Notice({this.title, this.date, this.destails});

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
        title: json['notice_title'],
        date: json['notice_date'],
        destails: json['notice_message']);
  }
}

class NoticeList {

  List<Notice> notices;

  NoticeList(this.notices);

  factory NoticeList.fromJson(List<dynamic> json) {
    List<Notice> notices = [];

    notices = json.map((i) => Notice.fromJson(i)).toList();

    return NoticeList(notices);
  }
}
