class FeesTranscation {
    FeesTranscation({
        this.date,
        this.paymentMethod,
        this.changeMethod,
        this.paidAmount,
        this.waiver,
        this.fine,
    });

    String date;
    String paymentMethod;
    String changeMethod;
    int paidAmount;
    int waiver;
    int fine;

    factory FeesTranscation.fromJson(Map<String, dynamic> json) => FeesTranscation(
        date: json["date"],
        paymentMethod: json["payment_method"],
        changeMethod: json["change_method"],
        paidAmount: json["paid_amount"],
        waiver: json["waiver"],
        fine: json["fine"],
    );

    Map<String, dynamic> toJson() => {
        "date": date,
        "payment_method": paymentMethod,
        "change_method": changeMethod,
        "paid_amount": paidAmount,
        "waiver": waiver,
        "fine": fine,
    };
}


class FeeTransactionsList {
  List<FeesTranscation> feeTransactions;

  FeeTransactionsList(this.feeTransactions);

  factory FeeTransactionsList.fromJson(List<dynamic> json) {
    List<FeesTranscation> feeTransactionList = [];

    feeTransactionList = json.map((i) => FeesTranscation.fromJson(i)).toList();

    return FeeTransactionsList(feeTransactionList);
  }
}