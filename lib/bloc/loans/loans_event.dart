part of 'loans_bloc.dart';

abstract class LoansEvent extends Equatable {
  const LoansEvent();

  @override
  List<Object?> get props => [];
}

class LoadLoansEvent extends LoansEvent {
}
