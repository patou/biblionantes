part of 'loans_bloc.dart';

abstract class LoansState extends Equatable {
  const LoansState();
}

class LoansInitial extends LoansState {
  @override
  List<Object> get props => [];
}

class LoansInProgress extends LoansState {
  @override
  List<Object> get props => [];
}

class LoansList extends LoansState {
  final List<LoansBook> list;
  final Map<String, bool> selectedFlag;
  final bool isSelectionMode;

  LoansList({ required this.list, this.selectedFlag = const {}, this.isSelectionMode = false });

  LoansList selectDocument(String documentId) {
    bool isSelected = selectedFlag[documentId] ?? false;
    var newSelectedFlag = new Map<String, bool>.from(selectedFlag)
      ..addAll({documentId : !isSelected });
    var isSelectionMode = newSelectedFlag.containsValue(true);
    return LoansList(
      list: this.list,
      selectedFlag: newSelectedFlag,
      isSelectionMode: isSelectionMode
    );
  }

  bool isSelected(String documentId) {
    return this.selectedFlag[documentId] ?? false;
  }

  @override
  List<Object> get props => [list, selectedFlag, isSelectionMode];
}

class LoansError extends LoansState {
  final String error;

  LoansError(this.error);

  @override
  List<Object> get props => [error];
}
