import 'package:meta/meta.dart';

@immutable
class SummeryAccount {
  String id;
  String name;
  int loanCount;
  int maxLoans;
  int overdueLoans;
  String subscriptionDate;
  String sex;
  String expiryDate;

  SummeryAccount({this.id, this.name, this.loanCount, this.maxLoans, this.overdueLoans,
      this.subscriptionDate, this.sex, this.expiryDate});

  factory SummeryAccount.fromJson(Map<String, dynamic> json) {
    return SummeryAccount(
      id: json['subscriberId'] as String,
      name: json['name'] as String,
      loanCount: json['loanCount'] as int,
      maxLoans: json['maxLoans'] as int,
      overdueLoans: json['overdueLoans'] as int,
      subscriptionDate: json['subscriptionDate'] as String,
      sex: json['sex'] as String,
      expiryDate: json['expiryDate'] as String,
    );
  }
}

@immutable
class AuthentInfo {
  String token;
  String login;
  String userId;

  AuthentInfo({this.token, this.login, this.userId});

  factory AuthentInfo.fromJson(Map<String, dynamic> json) {
    return AuthentInfo(
      login: json['login'] as String,
      token: json['token'] as String,
      userId: json['userId'] as String,
    );
  }
}

@immutable
class Account {
  String login;
  String password;
  String userId;
  String name;

  Account({this.login, this.password, this.userId, this.name});
}
