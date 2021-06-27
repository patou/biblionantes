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
  DateTime? subscriptionDate;
  String sex;
  String telephone;
  String emailAddress;
  String street;
  String city;
  String postalCode;
  DateTime? expiryDate;
  bool hasTrapLevel;

  SummeryAccount({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.loanCount,
    required this.maxLoans,
    required this.resvCount,
    required this.overdueLoans,
    this.subscriptionDate,
    required this.sex,
    required this.telephone,
    required this.emailAddress,
    required this.street,
    required this.city,
    required this.postalCode,
    this.expiryDate,
    required this.hasTrapLevel,
  });

  factory SummeryAccount.fromJson(Map<String, dynamic> json) {
    return SummeryAccount(
      id: json['subscriberId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      loanCount: int.tryParse(json['loanCount']) ?? 0,
      resvCount: int.tryParse(json['resvCount']) ?? 0,
      maxLoans: int.tryParse(json['maxLoans']) ?? 0,
      overdueLoans: int.tryParse(json['overdueLoans']) ?? 0,
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

  AuthentInfo({required this.token, required this.login, required this.userId});

  factory AuthentInfo.fromJson(Map<String, dynamic> json) {
    return AuthentInfo(
      login: json['login'] as String,
      token: json['token'] as String,
      userId: json['userid'] as String,
    );
  }
}

@immutable
class LibraryCard {
  static String SEPARATOR = "\x29";
  String login;
  String password;
  String userId;
  String name;

  LibraryCard({required this.login, required this.password, required this.userId, required this.name});

  factory LibraryCard.fromSharedPref(String str) {
    var parts = str.split(SEPARATOR);
    return LibraryCard(
      login: parts[0],
      password: parts[1],
      userId: parts[2],
      name: parts[3],
    );
  }

  String toSharedPref() {
    return [login, password, userId, name].join(SEPARATOR);
  }
}
