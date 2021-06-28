part of 'loans_bloc.dart';

abstract class LoansState extends Equatable {
  const LoansState();
}

class LoansInitial extends LoansState {
  @override
  List<Object> get props => [];
}

class LoansInProgress extends LoansState {
  @override
  List<Object> get props => [];
}

class LoansList extends LoansState {
  List<LoansBook> list;

  LoansList(this.list);

  @override
  List<Object> get props => [list];
}

class LoansError extends LoansState {
  String error;

  LoansError(this.error);

  @override
  List<Object> get props => [error];
}
