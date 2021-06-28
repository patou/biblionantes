import 'dart:async';

import 'package:biblionantes/models/book.dart';
import 'package:biblionantes/repositories/search.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final SearchRepository searchRepository;

  DetailBloc({required this.searchRepository}) : super(DetailInitial());

  @override
  Stream<DetailState> mapEventToState(
    DetailEvent event,
  ) async* {
    if (event is  LoadDetailEvent) {
      yield DetailInProgress();

      yield DetailSuccess(book: Book(id: event.id, title: "Titre"));
    }
  }
}
