import 'dart:async';

import 'package:biblionantes/models/loansbook.dart';
import 'package:biblionantes/repositories/account_repository.dart';
import 'package:biblionantes/repositories/search.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'loans_event.dart';
part 'loans_state.dart';

class LoansBloc extends Bloc<LoansEvent, LoansState> {

  LoansBloc({required this.accountRepository}) : super(LoansInitial());

  final LibraryCardRepository accountRepository;

  @override
  Stream<LoansState> mapEventToState(
    LoansEvent event,
  ) async* {
    if (event is LoadLoansEvent) {
      try {
        yield LoansInProgress();
        // On récupère la liste des prêts
        var list = await accountRepository.loadLoansList();
        yield LoansList(list);
        // On complète pour récupérer les infos plus précises des documents.
        list = await accountRepository.resolveBook(list);
        yield LoansList(list);
      }
      catch (e, stack) {
        print(e);
        print(stack);
        yield LoansError(e.toString());
      }
    }
  }
}
