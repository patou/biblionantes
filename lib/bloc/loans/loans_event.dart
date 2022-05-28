part of 'loans_bloc.dart';

abstract class LoansEvent extends Equatable {
  const LoansEvent();

  @override
  List<Object?> get props => [];
}

class LoadLoansEvent extends LoansEvent {
}

class EnterSelectionModeLoansEvent extends LoansEvent {}

class QuitSelectionModeLoansEvent extends LoansEvent {}

class SelectLoansEvent extends LoansEvent {
  final String documentId;

  SelectLoansEvent({ required this.documentId });

  @override
  List<Object?> get props => [documentId];
}

class ChangeGroupByLoansEvent extends LoansEvent {
  final LoansBookGroupBy groupBy;

  ChangeGroupByLoansEvent({ required this.groupBy });

  @override
  List<Object?> get props => [groupBy];
}