part of 'detail_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object?> get props => [];
}

class DetailInitial extends DetailState {
}

class DetailInProgress extends DetailState {
}

class DetailSuccess extends DetailState {
  Book book;

  DetailSuccess({required this.book});

  DetailSuccess copyWith({Book? book}) => DetailSuccess(book: book ?? this.book);
}

class DetailError extends DetailState {
  final String error;

  DetailError(this.error);

  @override
  List<Object?> get props => [error];
}
