import 'dart:async';

import 'package:biblionantes/models/reservationsbook.dart';
import 'package:biblionantes/repositories/account_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'reservations_event.dart';
part 'reservations_state.dart';

class ReservationsBloc extends Bloc<ReservationsEvent, ReservationsState> {
  ReservationsBloc({required this.accountRepository})
      : super(ReservationsInitial()) {
    on<LoadReservationsEvent>(onLoadReservationsEvent);
  }

  final LibraryCardRepository accountRepository;

  FutureOr<void> onLoadReservationsEvent(
      LoadReservationsEvent event, Emitter<ReservationsState> emit) async {
    try {
      emit(ReservationsInProgress());
      // On récupère la liste des prêts
      var list = await accountRepository.loadReservationsList();
      emit(ReservationsList(list));
      // On complète pour récupérer les infos plus précises des documents.
      list = await accountRepository.resolveReservableBook(list);
      emit(ReservationsList(list));
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      emit(ResrvationsError(error.toString()));
      await FirebaseCrashlytics.instance
          .recordError(error, stackTrace, reason: 'onLoadReservationsEvent');
    }
  }
}
