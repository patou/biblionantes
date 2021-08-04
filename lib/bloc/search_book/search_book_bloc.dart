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

  SearchBookBloc({required this.searchRepository}) : super(SearchBookWelcomeState());

  SearchBookState get initialState => SearchBookWelcomeState();

  bool _hasReachedMax(SearchBookState state) => state is SearchBookSucessState && state.hasReachedMax;

  @override
  Stream<SearchBookState> mapEventToState(SearchBookEvent event) async* {
    final currentState = state;
    if (event is SearchBookTextCleared) {
      yield SearchBookWelcomeState();
    } else if (event is SearchBookTextSearched && !this._hasReachedMax(currentState)) {
      print("search " + event.search);
      try {
        if (currentState is SearchBookWelcomeState) {
          yield SearchBookLoadingState();
          final books = await searchRepository.search(event.search);
          if (books.isEmpty) {
            yield SearchBookNotFoundState();
          }
          else {
            yield SearchBookSucessState(books: books, hasReachedMax: false, search: event.search, page: 1);
            final booksAvailable = await searchRepository.searchAvailability(books);
            yield SearchBookSucessState(books: booksAvailable, hasReachedMax: false, search: event.search, page: 1);
          }
          return;
        }
      } catch (e) {
        print(e.toString());
        yield SearchBookErrorState(error: e.toString());
      }
    } else if (event is SearchBookLoadNext && !this._hasReachedMax(currentState)) {
      print("load next");
      try {
        if (currentState is SearchBookSucessState) {
          final books = await searchRepository.search(currentState.search, page: currentState.page + 1);
          if (books.isEmpty) {
            yield currentState.copyWith(hasReachedMax: true);
          }
          else {
            yield currentState.copyWith(
              page: currentState.page + 1,
              books: currentState.books + books,
              hasReachedMax: false,
            );
            final booksAvailable = await searchRepository.searchAvailability(books);
            yield currentState.copyWith(
              page: currentState.page + 1,
              books: currentState.books + booksAvailable,
              hasReachedMax: false,
            );
          }
          return;
        }
      } catch (e, s) {
        print('Error get list item $e \n$s');
        yield SearchBookErrorState(error: e.toString());
      }
    }
  }

  @override
  Stream<Transition<SearchBookEvent, SearchBookState>> transformEvents(Stream<SearchBookEvent> events, transitionFn) {
    return super.transformEvents(events.debounceTime(const Duration(milliseconds: 500)), transitionFn);
  }
}
