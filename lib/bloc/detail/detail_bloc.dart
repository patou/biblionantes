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
      BookDetail detail = await this.searchRepository.detail(event.id);
      yield DetailSuccess(detail: detail);
      print('before stock');
      var stock = await this.searchRepository.stock(event.id);
      print('after stock');
      print(stock);
      detail = detail.copyWith(stock: stock);
      yield DetailSuccess(detail: detail);
      if (detail.book.ark != null) {
        var details = await this.searchRepository.info(detail.book.ark!);
        print('after info');
        yield DetailSuccess(detail: detail.copyWith(details: details));
      }
    }
  }
}
