import 'dart:async';

import 'package:biblionantes/models/reservationsbook.dart';
import 'package:biblionantes/repositories/account_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'reservations_event.dart';
part 'reservations_state.dart';

class ReservationsBloc extends Bloc<ReservationsEvent, ReservationsState> {

  ReservationsBloc({required this.accountRepository}) : super(ReservationsInitial()) {
    on<LoadReservationsEvent>(onLoadLoansEvent);
  }

  final LibraryCardRepository accountRepository;

  FutureOr<void> onLoadLoansEvent(LoadReservationsEvent event, Emitter<ReservationsState> emit) async {
    try {
      emit(ReservationsInProgress());
      // On récupère la liste des prêts
      var list = await accountRepository.loadReservationsList();
      emit(ReservationsList(list));
      // On complète pour récupérer les infos plus précises des documents.
      list = await accountRepository.resolveReservableBook(list);
      emit(ReservationsList(list));
    }
    catch (e, stack) {
      print(e);
      print(stack);
      emit(ResrvationsError(e.toString()));
    }
  }
}
