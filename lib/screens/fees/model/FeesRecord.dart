class FeesRecord {
  int id;
  double amount;
  double weaver;
  double fine;
  double paidAmount;
  double subTotal;
  double balance;
  String student;
  String recordClass;
  String section;
  String status;
  String date;

  FeesRecord({
    this.id,
    this.amount,
    this.weaver,
    this.fine,
    this.paidAmount,
    this.subTotal,
    this.balance,
    this.student,
    this.recordClass,
    this.section,
    this.status,
    this.date,
  });

  factory FeesRecord.fromJson(Map<String, dynamic> json) {
    return FeesRecord(
      id: json["id"],
      amount: json["amount"].toDouble(),
      weaver: json["weaver"].toDouble(),
      fine: json["fine"].toDouble(),
      paidAmount: json["paid_amount"].toDouble(),
      subTotal: json["sub_total"].toDouble(),
      balance: json["balance"].toDouble(),
      student: json["student"],
      recordClass: json["class"],
      section: json["section"],
      status: json["status"],
      date: json["date"],
    );
  }
}

class FeesRecordList {
  List<FeesRecord> feesRecords;

  FeesRecordList({this.feesRecords});

  factory FeesRecordList.fromJson(List<dynamic> json) {
    List<FeesRecord> feesRecordList = [];

    feesRecordList = json.map((i) => FeesRecord.fromJson(i)).toList();

    return FeesRecordList(feesRecords : feesRecordList);
  }
}
