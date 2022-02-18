import 'dart:async';

import 'package:biblionantes/models/loansbook.dart';
import 'package:biblionantes/repositories/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'loans_event.dart';
part 'loans_state.dart';

class LoansBloc extends Bloc<LoansEvent, LoansState> {

  LoansBloc({required this.accountRepository}) : super(LoansInitial()) {
    on<LoadLoansEvent>(onLoadLoansEvent);
  }

  final LibraryCardRepository accountRepository;

  FutureOr<void> onLoadLoansEvent(LoadLoansEvent event, Emitter<LoansState> emit) async {
    try {
      emit(LoansInProgress());
      // On récupère la liste des prêts
      var list = await accountRepository.loadLoansList();
      emit(LoansList(list));
      // On complète pour récupérer les infos plus précises des documents.
      list = await accountRepository.resolveBook(list);
      emit(LoansList(list));
    }
    catch (e, stack) {
      print(e);
      print(stack);
      emit(LoansError(e.toString()));
    }
  }
}
