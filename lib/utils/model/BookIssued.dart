class BookIssued {
  String title;
  String author;
  String issuedDate;
  String returnDate;
  String bookNo;
  String status;

  BookIssued(
      {this.title,
      this.author,
      this.issuedDate,
      this.returnDate,
      this.bookNo,
      this.status});

  factory BookIssued.fromJson(Map<String, dynamic> json) {
    return BookIssued(
      title: json['book_title'],
      author: json['author_name'],
      issuedDate: json['given_date'],
      returnDate: json['due_date'],
      bookNo: json['book_number'],
      status: json['issue_status'],
    );
  }
}

class BookIssuedList {
  List<BookIssued> bookIssues;

  BookIssuedList(this.bookIssues);

  factory BookIssuedList.fromJson(List<dynamic> json) {
    List<BookIssued> bookIssuedList = [];

    bookIssuedList = json.map((i) => BookIssued.fromJson(i)).toList();

    return BookIssuedList(bookIssuedList);
  }
}
