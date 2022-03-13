part of 'reservation_bloc.dart';

abstract class ReservationsEvent extends Equatable {
  const ReservationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadReservationsEvent extends ReservationsEvent {
}
