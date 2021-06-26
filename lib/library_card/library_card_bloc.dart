import 'dart:async';
import 'package:biblionantes/models/SummeryAccount.dart';
import 'package:biblionantes/repositories/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'library_card_event.dart';

part 'library_card_state.dart';

class LibraryCardBloc extends Bloc<LibraryCardEvent, AbstractLibraryCardState> {
  LibraryCardBloc({required LibraryCardRepository accountRepository}) : this.accountRepository = accountRepository, super(InitialLibraryCardState()) {
    _listLibraryCardsSubscription = accountRepository.getLibraryCards()
        .listen((list) => add(LibraryCardChangedEvent(list)));
  }

  final LibraryCardRepository accountRepository;
  late StreamSubscription<List<LibraryCard>> _listLibraryCardsSubscription;

  @override
  Stream<AbstractLibraryCardState> mapEventToState(LibraryCardEvent event) async* {
    if (event is LoadLibraryCardEvent) {
      print("load library card");
      accountRepository.loadLibraryCards();
    }
    else if (event is LibraryCardChangedEvent) {
      yield LibraryCardStateChange(event.libraryCards);
    } else if (event is AddLibraryCardEvent) {
      yield* addLibraryCard(event);
    } else if (event is RemoveLibraryCardEvent) {
      yield* removeLibraryCard(event);
    }
  }

  Stream<AbstractLibraryCardState> removeLibraryCard(RemoveLibraryCardEvent event) async* {
    try {
      yield RemoveLibraryCardStateInProgress();
      await accountRepository.removeLibraryCard(event.libraryCard);
      yield RemoveLibraryCardStateSuccess();
    }
    catch (e) {
      yield RemoveLibraryCardStateError(e.toString());
    }
  }

  Stream<AbstractLibraryCardState> addLibraryCard(AddLibraryCardEvent event) async* {
    try {
      yield AddLibraryCardStateInProgress();
      await accountRepository.addLibraryCards(event.name, event.login, event.pass);
      yield AddLibraryCardStateSuccess();
    }
    catch (e) {
      yield AddLibraryCardStateError(e.toString());
    }
  }

  @override
  Future<void> close() {
    _listLibraryCardsSubscription.cancel();
    accountRepository.dispose();
    return super.close();
  }
}
