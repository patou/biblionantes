part of 'search_book_bloc.dart';

@immutable
abstract class SearchBookEvent extends Equatable {}

class SearchBookTextSearched extends SearchBookEvent {
  final String search;

  SearchBookTextSearched({required this.search});

  @override
  List<Object?> get props => [search];
}

class SearchBookLoadNext extends SearchBookEvent {
  @override
  List<Object?> get props => [];
}

class SearchBookTextCleared extends SearchBookEvent {
  @override
  List<Object?> get props => [];
}
