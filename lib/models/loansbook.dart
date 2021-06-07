import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class LoansBook extends Equatable {
  String id;
  String title;
  String account;
  DateTime returnDate;

  LoansBook({
    required this.id,
    required this.title,
    required this.returnDate,
    required this.account,
  }): assert(id != null);

  factory LoansBook.fromJson(Map<String, dynamic> json, String account) {
    print(json['data']['title']);
    return LoansBook(
      id: json['data']['documentNumber'] as String,
      title: json['data']['title'] as String,
      returnDate: DateTime.parse(json['data']['returnDate']),
      account: account
    );
  }

  @override
  String toString() {
    return 'LoansBook{id: $id, title: $title}';
  }

  @override
  List<Object> get props => [id, title, account, returnDate];
}