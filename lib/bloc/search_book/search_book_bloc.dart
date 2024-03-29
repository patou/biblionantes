// ignore_for_file: unnecessary_this

import 'dart:async';
import 'package:biblionantes/models/book.dart';
import 'package:biblionantes/repositories/search.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'search_book_event.dart';

part 'search_book_state.dart';

class SearchBookBloc extends Bloc<SearchBookEvent, SearchBookState> {
  final SearchRepository searchRepository;

  SearchBookBloc({required this.searchRepository})
      : super(SearchBookWelcomeState()) {
    on<SearchBookTextCleared>(onSearchBookTextCleared);
    on<SearchBookTextSearched>(onSearchBookTextSearched,
        transformer: debounce(const Duration(milliseconds: 500)));
    on<SearchBookLoadNext>(onSearchBookLoadNext,
        transformer: debounce(const Duration(milliseconds: 500)));
  }

  SearchBookState get initialState => SearchBookWelcomeState();

  bool _hasReachedMax(SearchBookState state) =>
      state is SearchBookSucessState && state.hasReachedMax;

  EventTransformer<MyEvent> debounce<MyEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  FutureOr<void> onSearchBookTextCleared(
      SearchBookTextCleared event, Emitter<SearchBookState> emit) async {
    emit(SearchBookWelcomeState());
  }

  FutureOr<void> onSearchBookTextSearched(
      SearchBookTextSearched event, Emitter<SearchBookState> emit) async {
    print("search ${event.search}");
    try {
      emit(SearchBookLoadingState());
      final books = await searchRepository.search(event.search);
      if (books.isEmpty) {
        emit(SearchBookNotFoundState());
      } else {
        emit(SearchBookSucessState(
            books: books, hasReachedMax: false, search: event.search, page: 1));
        final booksAvailable = await searchRepository.searchAvailability(books);
        emit(SearchBookSucessState(
            books: booksAvailable,
            hasReachedMax: false,
            search: event.search,
            page: 1));
      }
      return;
    } catch (error, stackTrace) {
      print(error.toString());
      emit(SearchBookErrorState(error: error.toString()));
      await FirebaseCrashlytics.instance
          .recordError(error, stackTrace, reason: 'onLoadLoansEvent');
    }
  }

  FutureOr<void> onSearchBookLoadNext(
      SearchBookLoadNext event, Emitter<SearchBookState> emit) async {
    var currentState = state;
    if (this._hasReachedMax(currentState)) {
      return;
    }
    try {
      if (currentState is SearchBookSucessState) {
        final books = await searchRepository.search(currentState.search,
            page: currentState.page + 1);
        if (books.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(currentState.copyWith(
            page: currentState.page + 1,
            books: currentState.books + books,
            hasReachedMax: false,
          ));
          final booksAvailable =
              await searchRepository.searchAvailability(books);
          emit(currentState.copyWith(
            page: currentState.page + 1,
            books: currentState.books + booksAvailable,
            hasReachedMax: false,
          ));
        }
        return;
      }
    } catch (error, stackTrace) {
      print('Error get list item $error \n$stackTrace');
      emit(SearchBookErrorState(error: error.toString()));
      await FirebaseCrashlytics.instance
          .recordError(error, stackTrace, reason: 'onLoadLoansEvent');
    }
  }
}
