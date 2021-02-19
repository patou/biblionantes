import 'package:meta/meta.dart';

@immutable
class SummeryAccount {
  String id;
  String firstName;
  String lastName;
  int loanCount;
  int resvCount;
  int maxLoans;
  int overdueLoans;
  DateTime subscriptionDate;
  String sex;
  String telephone;
  String emailAddress;
  String street;
  String city;
  String postalCode;
  DateTime expiryDate;
  bool hasTrapLevel;

  SummeryAccount({
    this.id,
    this.firstName,
    this.lastName,
    this.loanCount,
    this.maxLoans,
    this.resvCount,
    this.overdueLoans,
    this.subscriptionDate,
    this.sex,
    this.telephone,
    this.emailAddress,
    this.street,
    this.city,
    this.postalCode,
    this.expiryDate,
    this.hasTrapLevel,
  });

  factory SummeryAccount.fromJson(Map<String, dynamic> json) {
    return SummeryAccount(
      id: json['subscriberId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      loanCount: int.tryParse(json['loanCount']),
      resvCount: int.tryParse(json['resvCount']),
      maxLoans: int.tryParse(json['maxLoans']),
      overdueLoans: int.tryParse(json['overdueLoans']),
      subscriptionDate: DateTime.tryParse(json['subscriptionDate']),
      sex: json['sex'] as String,
      telephone: json['telephone'] as String,
      emailAddress: json['emailAddress'] as String,
      street: json['address1'] as String,
      city: json['address2'] as String,
      postalCode: json['postalCode'] as String,
      expiryDate: DateTime.tryParse(json['expiryDate']),
      hasTrapLevel: json['trapLevel'] == 'Error'
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
