part of 'library_card_bloc.dart';

@immutable
abstract class AbstractLibraryCardState extends Equatable {
  @override
  List<Object?> get props => [];
}

abstract class LibraryCardState extends AbstractLibraryCardState {}

@immutable
class LibraryCardStateChange  extends LibraryCardState {
  final List<LibraryCard> libraryCards;

  LibraryCardStateChange(this.libraryCards);

  @override
  List<Object?> get props => ['libraryCards'];
}

@immutable
class InitialLibraryCardState  extends LibraryCardState {}

@immutable
class LibraryCardStateLoadError  extends LibraryCardState {
  final String error;

  LibraryCardStateLoadError(this.error);
  @override
  List<Object?> get props => ['error'];
}


abstract class AddLibraryCardState extends AbstractLibraryCardState {}

@immutable
class AddLibraryCardStateInProgress  extends AddLibraryCardState {}

@immutable
class AddLibraryCardStateSuccess  extends AddLibraryCardState {}

@immutable
class AddLibraryCardStateError  extends AddLibraryCardState {
  final String error;

  AddLibraryCardStateError(this.error);
  @override
  List<Object?> get props => ['error'];
}

abstract class RemoveLibraryCardState extends AbstractLibraryCardState {}
@immutable
class RemoveLibraryCardStateInProgress  extends RemoveLibraryCardState {}

@immutable
class RemoveLibraryCardStateSuccess  extends RemoveLibraryCardState {}

@immutable
class RemoveLibraryCardStateError  extends RemoveLibraryCardState {
  final String error;

  RemoveLibraryCardStateError(this.error);
  @override
  List<Object?> get props => ['error'];
}