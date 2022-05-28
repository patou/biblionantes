import 'dart:async';
import 'dart:ffi';

import 'package:biblionantes/models/loansbook.dart';
import 'package:biblionantes/repositories/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'loans_event.dart';
part 'loans_state.dart';

class LoansBloc extends Bloc<LoansEvent, LoansState> {

  LoansBloc({required this.accountRepository}) : super(LoansInitial()) {
    on<LoadLoansEvent>(onLoadLoansEvent);
    on<SelectLoansEvent>(onSelectLoandEvent);
    on<EnterSelectLoansEvent>(onEnterSelectLoansEvent);
    on<ChangeGroupByLoansEvent>(onChangeGroupByLoansEvent);
  }

  final LibraryCardRepository accountRepository;

  FutureOr<void> onSelectLoandEvent(SelectLoansEvent event, Emitter<LoansState> emit) {
    var currentState = state;
    if (currentState is LoansList) {
      emit(currentState.selectDocument(event.documentId));
    }
  }

  FutureOr<void> onEnterSelectLoansEvent(EnterSelectLoansEvent event, Emitter<LoansState> emit) {
    var currentState = state;
    if (currentState is LoansList) {
      emit(currentState.copyWith(isSelectionMode: true));
    }
  }

  FutureOr<void> onLoadLoansEvent(LoadLoansEvent event, Emitter<LoansState> emit) async {
    try {
      emit(LoansInProgress());
      // On récupère la liste des prêts
      var list = await accountRepository.loadLoansList();
      emit(LoansList(list: list));
      // On complète pour récupérer les infos plus précises des documents.
      list = await accountRepository.resolveBook(list);
      emit(LoansList(list: list));
    }
    catch (e, stack) {
      print(e);
      print(stack);
      emit(LoansError(e.toString()));
    }
  }

  FutureOr<void> onChangeGroupByLoansEvent(ChangeGroupByLoansEvent event, Emitter<LoansState> emit) {
    var currentState = state;
    if (currentState is LoansList) {
      emit(currentState.copyWith(groupBy: event.groupBy));
    }
  }
}
