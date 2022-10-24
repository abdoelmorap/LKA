class Banks {
  dynamic id;
  String bankName;
  String accountName;
  String accountNumber;

  Banks({this.id, this.bankName, this.accountName,this.accountNumber});

  Banks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bankName = json['bank_name'];
    accountName = json['account_name'];
    accountNumber = json['account_number'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bank_name'] = this.bankName;
    data['account_name'] = this.accountName;
    data['account_number'] = this.accountNumber;
    return data;
  }
}

class BankList {
  List<Banks> banks;

  BankList(this.banks);

  factory BankList.fromJson(List<dynamic> json) {
    List<Banks> bankList = [];

    bankList = json.map((i) => Banks.fromJson(i)).toList();

    return BankList(bankList);
  }
}
