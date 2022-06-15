import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class SummeryAccount {
  final String id;
  final String firstName;
  final String lastName;
  final int loanCount;
  final int resvCount;
  final int overdueLoans;
  final int maxLoans;
  final DateTime? subscriptionDate;
  final String sex;
  final String telephone;
  final String emailAddress;
  final String street;
  final String city;
  final String postalCode;
  final DateTime? expiryDate;
  final bool hasTrapLevel;

  const SummeryAccount({
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
        hasTrapLevel: json['trapLevel'] == 'Error');
  }
}

@immutable
class AuthentInfo {
  final String token;
  final String login;
  final String userId;

  const AuthentInfo(
      {required this.token, required this.login, required this.userId});

  factory AuthentInfo.fromJson(Map<String, dynamic> json) {
    return AuthentInfo(
      login: json['login'] as String,
      token: json['token'] as String,
      userId: json['userid'] as String,
    );
  }
}

class LibraryCard extends Equatable {
  static const String SEPARATOR = "\x29";
  final String login;
  final String password;
  final String userId;
  final String name;

  const LibraryCard(
      {required this.login,
      required this.password,
      required this.userId,
      required this.name});

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

  @override
  List<Object?> get props => [login, password, userId, name];
}
