import 'dart:convert';

CreditModal creditModalFromJson(String str) => CreditModal.fromJson(json.decode(str));

String creditModalToJson(CreditModal data) => json.encode(data.toJson());

class CreditModal {
    CreditModal({
        this.credit,
    });

    String credit;

    factory CreditModal.fromJson(Map<String, dynamic> json) => CreditModal(
        credit: json["credit"],
    );

    Map<String, dynamic> toJson() => {
        "credit": credit,
    };
}
