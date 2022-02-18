import 'dart:async';
import 'package:biblionantes/models/book.dart';
import 'package:biblionantes/repositories/search.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'search_book_event.dart';

part 'search_book_state.dart';

class SearchBookBloc extends Bloc<SearchBookEvent, SearchBookState> {
  final SearchRepository searchRepository;

  SearchBookBloc({required this.searchRepository}) : super(SearchBookWelcomeState()) {
    on<SearchBookTextCleared>(onSearchBookTextCleared);
    on<SearchBookTextSearched>(onSearchBookTextSearched, transformer: debounce(const Duration(milliseconds: 500)));
    on<SearchBookLoadNext>(onSearchBookLoadNext, transformer: debounce(const Duration(milliseconds: 500)));
  }

  SearchBookState get initialState => SearchBookWelcomeState();

  bool _hasReachedMax(SearchBookState state) => state is SearchBookSucessState && state.hasReachedMax;

  EventTransformer<MyEvent> debounce<MyEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  FutureOr<void> onSearchBookTextCleared(SearchBookTextCleared event, Emitter<SearchBookState> emit) async {
    emit(SearchBookWelcomeState());
  }

  FutureOr<void> onSearchBookTextSearched(SearchBookTextSearched event, Emitter<SearchBookState> emit) async {
    if (this._hasReachedMax(state)) {
      return;
    }
    print("search " + event.search);
    try {
      if (state is SearchBookWelcomeState) {
        emit(SearchBookLoadingState());
        final books = await searchRepository.search(event.search);
        if (books.isEmpty) {
          emit(SearchBookNotFoundState());
        }
        else {
          emit(SearchBookSucessState(books: books, hasReachedMax: false, search: event.search, page: 1));
          final booksAvailable = await searchRepository.searchAvailability(books);
          emit(SearchBookSucessState(books: booksAvailable, hasReachedMax: false, search: event.search, page: 1));
        }
        return;
      }
    } catch (e) {
      print(e.toString());
      emit(SearchBookErrorState(error: e.toString()));
    }
  }

  FutureOr<void> onSearchBookLoadNext(SearchBookLoadNext event, Emitter<SearchBookState> emit) async {
    var currentState = state;
    if (this._hasReachedMax(currentState)) {
      return;
    }
    print("load next");
    try {
      if (currentState is SearchBookSucessState) {
        final books = await searchRepository.search(currentState.search, page: currentState.page + 1);
        if (books.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        }
        else {
          emit(currentState.copyWith(
            page: currentState.page + 1,
            books: currentState.books + books,
            hasReachedMax: false,
          ));
          final booksAvailable = await searchRepository.searchAvailability(books);
          emit(currentState.copyWith(
            page: currentState.page + 1,
            books: currentState.books + booksAvailable,
            hasReachedMax: false,
          ));
        }
        return;
      }
    } catch (e, s) {
      print('Error get list item $e \n$s');
      emit(SearchBookErrorState(error: e.toString()));
    }
  }
}
