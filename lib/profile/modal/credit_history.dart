import 'dart:convert';

CreditHistory creditHistoryFromJson(String str) =>
    CreditHistory.fromJson(json.decode(str));

String creditHistoryToJson(CreditHistory data) => json.encode(data.toJson());

class CreditHistory {
  CreditHistory({
    this.item,
    this.amount,
    this.balance,
  });

  String item;
  String amount;
  int balance;

  factory CreditHistory.fromJson(Map<String, dynamic> json) => CreditHistory(
        item: json["item"],
        amount: json["amount"],
        balance: json["balance"],
      );

  Map<String, dynamic> toJson() => {
        "item": item,
        "amount": amount,
        "balance": balance,
      };
}
