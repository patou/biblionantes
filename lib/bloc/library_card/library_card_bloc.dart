// ignore_for_file: unnecessary_this

import 'dart:async';
import 'package:biblionantes/models/summery_account.dart';
import 'package:biblionantes/repositories/account_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'library_card_event.dart';

part 'library_card_state.dart';

class LibraryCardBloc extends Bloc<LibraryCardEvent, AbstractLibraryCardState> {
  LibraryCardBloc({required this.accountRepository}) : super(InitialLibraryCardState()) {
    on<LoadLibraryCardEvent>(onLoadLibraryCardEvent);
    on<LibraryCardChangedEvent>(onLibraryCardChangedEvent);
    on<AddLibraryCardEvent>(onAddLibraryCardEvent);
    on<RemoveLibraryCardEvent>(onRemoveLibraryCardEvent);
    _listLibraryCardsSubscription = accountRepository.getLibraryCards()
        .listen((list) => add(LibraryCardChangedEvent(list)));
  }

  final LibraryCardRepository accountRepository;
  late StreamSubscription<List<LibraryCard>> _listLibraryCardsSubscription;

  @override
  Future<void> close() {
    _listLibraryCardsSubscription.cancel();
    accountRepository.dispose();
    return super.close();
  }

  Future<FutureOr<void>> onLoadLibraryCardEvent(LoadLibraryCardEvent event, Emitter<AbstractLibraryCardState> emit) async {
    await accountRepository.loadLibraryCards();
  }

  FutureOr<void> onLibraryCardChangedEvent(LibraryCardChangedEvent event, Emitter<AbstractLibraryCardState> emit) {
    emit(LibraryCardStateChange(event.libraryCards));
  }

  Future<FutureOr<void>> onAddLibraryCardEvent(AddLibraryCardEvent event, Emitter<AbstractLibraryCardState> emit) async {
    try {
      emit(AddLibraryCardStateInProgress());
      await accountRepository.addLibraryCards(event.name, event.login, event.pass);
      emit(AddLibraryCardStateSuccess());
    }
    catch (e, stack) {
      print(e);
      print(stack);
      emit(AddLibraryCardStateError(e.toString()));
    }
  }


  Future<FutureOr<void>> onRemoveLibraryCardEvent(RemoveLibraryCardEvent event, Emitter<AbstractLibraryCardState> emit) async {
    try {
      emit(RemoveLibraryCardStateInProgress());
      await accountRepository.removeLibraryCard(event.libraryCard);
      emit(RemoveLibraryCardStateSuccess());
    }
    catch (e) {
      emit(RemoveLibraryCardStateError(e.toString()));
    }
  }
}

