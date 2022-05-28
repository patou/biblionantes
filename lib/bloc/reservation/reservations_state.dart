// ignore_for_file: prefer_const_constructors_in_immutables

part of 'reservation_bloc.dart';

abstract class ReservationsState extends Equatable {
  const ReservationsState();
}

class ReservationsInitial extends ReservationsState {
  @override
  List<Object> get props => [];
}

class ReservationsInProgress extends ReservationsState {
  @override
  List<Object> get props => [];
}

class ReservationsList extends ReservationsState {
  final List<ReservationsBook> list;

  ReservationsList(this.list);

  @override
  List<Object> get props => [list];
}

class ResrvationsError extends ReservationsState {
  final String error;

  ResrvationsError(this.error);

  @override
  List<Object> get props => [error];
}
