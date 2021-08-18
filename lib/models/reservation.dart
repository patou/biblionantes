import 'package:equatable/equatable.dart';

class ReservationChoices extends Equatable {
  final String code;
  final String name;

  ReservationChoices({required this.code, required this.name});

  factory ReservationChoices.fromJson(Map<String, dynamic> json) {
    return ReservationChoices(
      code: json['branchCode'] as String,
      name: json['branchDesc_fre'] as String,
    );
  }

  @override
  List<Object?> get props => [code, name];
}