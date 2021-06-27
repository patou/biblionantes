part of 'library_card_bloc.dart';

@immutable
abstract class LibraryCardEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class LoadLibraryCardEvent extends LibraryCardEvent {}

class AddLibraryCardEvent extends LibraryCardEvent {
  String login;

  String name;

  String pass;

  AddLibraryCardEvent({required this.login, required this.name, required this.pass});
}

class RemoveLibraryCardEvent extends LibraryCardEvent {
  final LibraryCard libraryCard;

  RemoveLibraryCardEvent(this.libraryCard);
}

class LibraryCardChangedEvent extends LibraryCardEvent {
  final List<LibraryCard> libraryCards;

  LibraryCardChangedEvent(this.libraryCards);
}