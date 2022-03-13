import 'package:biblionantes/models/book.dart';
import 'package:meta/meta.dart';

enum ReservationsStatus {
  none,
  available,
  notAvailable,
  soonAvailable,
}

@immutable
class ReservationsBook extends Book {
  final String seqNo;
  final String account;
  final String login;
  final DateTime resvDate;
  final DateTime? expiryDate;
  final ReservationsStatus status;
  final String branchName;
  final int rank;
  final String documentNumber;

  ReservationsBook({
    required this.seqNo,
    required String title,
    required this.resvDate,
    required this.account,
    required this.login,
    required this.rank,
    required this.status,
    required this.branchName,
    required this.documentNumber,
    DateTime? this.expiryDate,
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

  factory ReservationsBook.fromJson(Map<String, dynamic> json, String account, String login) {
    print(json['data']['title']);
    return ReservationsBook(
        seqNo: json['data']['seqNo'] as String,
        documentNumber: json['data']['document'] ?? '',
        title: json['data']['title'] as String,
        resvDate: DateTime.parse(json['data']['resvDate']),
        expiryDate: DateTime.tryParse(json['data']['expiryDate']),
        rank: int.parse(json['data']['rank']),
        branchName: json['data']['branch']['desc'],
        status: parseReservationsStatus(json['data']['statusCode']),
        account: account,
        login: login,
    );
  }

  static ReservationsStatus parseReservationsStatus(String statusCode) {
    ReservationsStatus status = ReservationsStatus.none;
    switch(statusCode) {
      case "ReservationCard.RESV_NOT_AVAILABLE":
        status = ReservationsStatus.notAvailable;
        break;
      case "ReservationCard.RESV_SOON_AVAILABLE":
        status = ReservationsStatus.soonAvailable;
        break;
      case "ReservationCard.RESV_AVAILABLE":
        status = ReservationsStatus.available;
        break;
      default:
        status = ReservationsStatus.none;
    }
    return status;
  }

  ReservationsBook copyWith({
    String? id,
    String? seqNo,
    String? localNumber,
    String? documentNumber,
    String? title,
    String? branchName,
    DateTime? resvDate,
    DateTime? expiryDate,
    ReservationsStatus? status,
    int? rank,
    String? account,
    String? login,
    String? type,
    String? imageURL,
    String? creators,
    String? ark,
    bool? available,
  }) {
    return ReservationsBook(
      id: id ?? this.id,
      seqNo: seqNo ?? this.seqNo,
      localNumber: localNumber ?? this.localNumber,
      documentNumber: documentNumber ?? this.documentNumber,
      title: title ?? this.title,
      resvDate: resvDate ?? this.resvDate,
      rank: rank ?? this.rank,
      branchName: branchName ?? this.branchName,
      status: status ?? this.status,
      expiryDate: expiryDate ?? this.expiryDate,
      account: account ?? this.account,
      login: login ?? this.login,
      type: type ?? this.type,
      imageURL: imageURL ?? this.imageURL,
      creators: creators ?? this.creators,
      ark: ark ?? this.ark,
    );
  }

  @override
  ReservationsBook copyFromBook(Book book) {
    return copyWith(
      localNumber: book.localNumber,
      title: book.title,
      type: book.type,
      imageURL: book.imageURL,
      creators: book.creators,
    );
  }

  @override
  List<Object?> get props => [...super.props, account, resvDate, expiryDate, rank, branchName, status, login];
}

/// On ne connais pas l'ID du document dans la liste des prêts et reservation seulement le seqNo.
/// L'id est composé de p::usmarcdef_ suivit du seqNo sur 10 chiffres.
toId(String seqNo) {
  return 'p::usmarcdef_' + seqNo.padLeft(10, '0');
}
