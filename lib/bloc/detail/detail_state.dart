// ignore_for_file: prefer_const_constructors_in_immutables

part of 'detail_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object?> get props => [];
}

class DetailInitial extends DetailState {
}

class DetailInProgress extends DetailState {
}

class DetailSuccess extends DetailState {
  final BookDetail detail;

  DetailSuccess({required this.detail});

  DetailSuccess copyWith({BookDetail? detail}) => DetailSuccess(detail: detail ?? this.detail);

  @override
  List<Object?> get props => [detail];
}

class DetailError extends DetailState {
  final String error;

  DetailError(this.error);

  @override
  List<Object?> get props => [error];
}
