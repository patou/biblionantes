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
  final LoansBookGroupBy groupBy;

  const LoansList(
      {required this.list,
      this.selectedFlag = const {},
      this.isSelectionMode = false,
      this.groupBy = LoansBookGroupBy.account});

  LoansList copyWith({
    List<LoansBook>? list,
    Map<String, bool>? selectedFlag,
    bool? isSelectionMode,
    LoansBookGroupBy? groupBy,
  }) {
    return LoansList(
      list: list ?? this.list,
      selectedFlag: selectedFlag ?? this.selectedFlag,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      groupBy: groupBy ?? this.groupBy,
    );
  }

  LoansList selectDocument(String documentId) {
    bool isSelected = selectedFlag[documentId] ?? false;
    var newSelectedFlag = Map<String, bool>.from(selectedFlag)
      ..addAll({documentId: !isSelected});
    var isSelectionMode = newSelectedFlag.containsValue(true);
    return copyWith(
        selectedFlag: newSelectedFlag, isSelectionMode: isSelectionMode);
  }

  bool isSelected(String documentId) {
    return selectedFlag[documentId] ?? false;
  }

  @override
  List<Object> get props => [list, selectedFlag, isSelectionMode, groupBy];

  @override
  String toString() {
    return "LoansList(list: ${list.length} items, isSelectionMode: $isSelectionMode, groupBy: $groupBy)";
  }
}

class LoansError extends LoansState {
  final String error;

  const LoansError(this.error);

  @override
  List<Object> get props => [error];
}
