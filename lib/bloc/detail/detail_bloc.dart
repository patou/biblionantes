import 'dart:async';

import 'package:biblionantes/models/book.dart';
import 'package:biblionantes/repositories/search.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final SearchRepository searchRepository;

  DetailBloc({required this.searchRepository}) : super(DetailInitial()) {
    on<LoadDetailEvent>(onLoadDetailEvent);
  }

  FutureOr<void> onLoadDetailEvent(LoadDetailEvent event, Emitter<DetailState> emit) async {
    emit(DetailInProgress());
    BookDetail detail = await this.searchRepository.detail(event.id);
    emit(DetailSuccess(detail: detail));
    var stock = await this.searchRepository.stock(event.id);
    detail = detail.copyWith(stock: stock);
    emit(DetailSuccess(detail: detail));
    if (detail.book.ark != null) {
      var details = await this.searchRepository.info(detail.book.ark!);
      emit(DetailSuccess(detail: detail.copyWith(details: details)));
    }
  }
}
