part of 'detail_bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();
}

class LoadDetailEvent extends DetailEvent {
  final String id;

  LoadDetailEvent(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
