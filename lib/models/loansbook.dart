import 'package:biblionantes/models/book.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class LoansBook extends Book {
  String seqNo;
  String account;
  DateTime returnDate;

  LoansBook({
    required this.seqNo,
    required String title,
    required this.returnDate,
    required this.account,
    String? id,
    String? localNumber,
    String? creators,
    String? type,
    String? imageURL,
  })  : super(
          id: id ?? toId(seqNo),
          title: title,
          creators: creators,
          localNumber: localNumber,
          type: type,
          imageURL: imageURL,
        );

  factory LoansBook.fromJson(Map<String, dynamic> json, String account) {
    print(json['data']['title']);
    return LoansBook(
        seqNo: json['data']['seqNo'] as String,
        title: json['data']['title'] as String,
        returnDate: DateTime.parse(json['data']['returnDate']),
        account: account);
  }

  LoansBook copyWith({
    String? id,
    String? seqNo,
    String? localNumber,
    String? title,
    DateTime? returnDate,
    String? account,
    String? type,
    String? imageURL,
    String? creators,
    bool? available,
  }) {
    return LoansBook(
      id: id ?? this.id,
      seqNo: seqNo ?? this.seqNo,
      localNumber: localNumber ?? this.localNumber,
      title: title ?? this.title,
      returnDate: returnDate ?? this.returnDate,
      account: account ?? this.account,
      type: type ?? this.type,
      imageURL: imageURL ?? this.imageURL,
      creators: creators ?? this.creators,
    );
  }

  LoansBook copyFromBook(Book book) {
    return copyWith(
      localNumber: book.localNumber,
      title: book.title,
      type: book.type,
      imageURL: book.imageURL,
      creators: book.creators,
    );
  }

  @override
  List<Object?> get props => [...super.props, account, returnDate];
}

/// On ne connais pas l'ID du document dans la liste des prêts et reservation seulement le seqNo.
/// L'id est composé de p::usmarcdef_ suivit du seqNo sur 10 chiffres.
toId(String seqNo) {
  return 'p::usmarcdef_' + seqNo.padLeft(10, '0');
}
