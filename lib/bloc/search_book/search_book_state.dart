part of 'search_book_bloc.dart';

@immutable
abstract class SearchBookState extends Equatable {
  const SearchBookState();
}

class SearchBookInitialState extends SearchBookState {
  @override
  List<Object?> get props => [];
}

class SearchBookWelcomeState extends SearchBookState {
  @override
  List<Object?> get props => [];
}

class SearchBookNotFoundState extends SearchBookState {
  @override
  List<Object?> get props => [];
}

class SearchBookLoadingState extends SearchBookState {
  @override
  List<Object?> get props => [];
}

class SearchBookSucessState extends SearchBookState {
  final List<Book> books;
  final bool hasReachedMax;
  final String search;
  final int page;

  const SearchBookSucessState({
    required this.books,
    required this.hasReachedMax,
    required this.search,
    required this.page,
  });

  SearchBookSucessState copyWith({
    List<Book>? books,
    bool? hasReachedMax,
    String? search,
    int? page,
  }) {
    return SearchBookSucessState(
      books: books ?? this.books,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      search: search ?? this.search,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [books, hasReachedMax, page, search];
}

class SearchBookErrorState extends SearchBookState {
  final String error;

  const SearchBookErrorState({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
