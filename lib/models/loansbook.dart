import 'package:biblionantes/models/book.dart';
import 'package:meta/meta.dart';

@immutable
class LoansBook extends Book {
  final String seqNo;
  final String account;
  final String login;
  final DateTime returnDate;
  final bool renewable;
  final String documentNumber;

  LoansBook({
    required this.seqNo,
    required String title,
    required this.returnDate,
    required this.account,
    required this.login,
    required this.renewable,
    required this.documentNumber,
    String? id,
    String? localNumber,
    String? creators,
    String? type,
    String? imageURL,
    String? ark,
  })  : super(
          id: id ?? toId(seqNo),
          title: title,
          creators: creators,
          localNumber: localNumber,
          ark: ark,
          type: type,
          imageURL: imageURL,
        );

  factory LoansBook.fromJson(Map<String, dynamic> json, String account, String login) {
    return LoansBook(
        seqNo: json['data']['seqNo'] as String,
        documentNumber: json['data']['documentNumber'],
        title: json['data']['title'] as String,
        returnDate: DateTime.parse(json['data']['returnDate']),
        renewable: json['data']['isRenewable'] as bool,
        account: account,
        login: login,
    );
  }

  @override
  LoansBook copyWith({
    String? id,
    String? seqNo,
    String? localNumber,
    String? documentNumber,
    String? title,
    DateTime? returnDate,
    bool? renewable,
    String? account,
    String? login,
    String? type,
    String? imageURL,
    String? creators,
    String? ark,
    bool? available,
  }) {
    return LoansBook(
      id: id ?? this.id,
      seqNo: seqNo ?? this.seqNo,
      localNumber: localNumber ?? this.localNumber,
      documentNumber: documentNumber ?? this.documentNumber,
      title: title ?? this.title,
      returnDate: returnDate ?? this.returnDate,
      renewable: renewable ?? this.renewable,
      account: account ?? this.account,
      login: login ?? this.login,
      type: type ?? this.type,
      imageURL: imageURL ?? this.imageURL,
      creators: creators ?? this.creators,
      ark: ark ?? this.ark,
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
  List<Object?> get props => [...super.props, account, returnDate, login, renewable];
}

/// On ne connais pas l'ID du document dans la liste des prêts et reservation seulement le seqNo.
/// L'id est composé de p::usmarcdef_ suivit du seqNo sur 10 chiffres.
toId(String seqNo) {
  return 'p::usmarcdef_${seqNo.padLeft(10, '0')}';
}

enum LoansBookGroupBy {
  account,
  returnDate
}