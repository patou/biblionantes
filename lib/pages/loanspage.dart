import 'package:biblionantes/bloc/loans/loans_bloc.dart';
import 'package:biblionantes/models/loansbook.dart';
import 'package:biblionantes/router.gr.dart';
import 'package:biblionantes/widgets/book_card.dart';
import 'package:biblionantes/widgets/no_result_widget.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

class LoansPage extends StatelessWidget {
  LoansPage();

  @override
  Widget build(BuildContext context) {
    print("build loanspage");
    final event = LoansBloc(accountRepository: context.read())
      ..add(LoadLoansEvent());
    return BlocBuilder<LoansBloc, LoansState>(
      bloc: event,
      builder: (_, state) {
        return Scaffold(
            appBar: buildAppBar(state),
            floatingActionButton: buildFloatingActionButton(state, event),
            body: buildBody(state, event, context));
      },
    );
  }

  AppBar buildAppBar(LoansState state) {
    if (state is LoansList) {
      return AppBar(
        title: Text('Mes livres empruntés'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.sort))
        ],
      );
    }
    return AppBar(
            title: Text('Mes livres empruntés'),
            centerTitle: true,
          );
  }

  Widget buildBody(LoansState state, LoansBloc event, BuildContext context) {
    if (state is LoansInProgress) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is LoansList) {
      List<LoansBook> list = state.list;
      if (list.length == 0) {
        return NoResultWidget(
            noResultText: 'Aucun emprunt en cours',
            retryButtonText: 'Rafraichir',
            onRetry: () async {
              event.add(LoadLoansEvent());
            });
      }
      return RefreshIndicator(
        onRefresh: () async {
          event.add(LoadLoansEvent());
        },
        child: GroupedListView<LoansBook, String>(
            elements: list,
            groupBy: (element) => element.account,
            useStickyGroupSeparators: true,
            physics: const AlwaysScrollableScrollPhysics(),
            groupSeparatorBuilder: (String value) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
            itemBuilder: (c, element) {
              return GestureDetector(
                  onLongPress: () {
                    event.add(SelectLoansEvent(documentId: element.id));
                  },
                  onTap: () {
                    if (state.isSelectionMode) {
                      event.add(SelectLoansEvent(documentId: element.id));
                    } else {
                      context.pushRoute(DetailRoute(
                        id: element.id,
                        action: element.renewable ? 'renew' : null,
                        account: element.renewable ? element.login : null,
                        documentNumber: element.documentNumber,
                      ));
                    }
                  },
                  child: BookCard(
                    book: element,
                    widget: LoansReturn(loansBook: element),
                    isSelected: state.isSelected(element.id),
                    isSelectedMode: state.isSelectionMode,
                  ));
            }),
      );
    } else {
      return NoResultWidget(
          noResultText: 'Une erreur est apparue',
          retryButtonText: 'Ré-essayer',
          onRetry: () async {
            event.add(LoadLoansEvent());
          });
    }
  }

  buildFloatingActionButton(LoansState state, LoansBloc event) {
    if (state is LoansList) {
      if (state.isSelectionMode) {
        return FloatingActionButton(onPressed: () {

        }, child: Text(state.selectedFlag.values.where((element) => element).length.toString())
        );
      }
      else {
        return FloatingActionButton(onPressed: () {
          event.add(EnterSelectLoansEvent());
        }, child: Icon(Icons.library_add_check_outlined)
        );
      }
    }
    return null;
  }
}

class LoansReturn extends StatelessWidget {
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  LoansReturn({
    Key? key,
    required this.loansBook,
  }) : super(key: key);

  final LoansBook loansBook;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
      visualDensity: VisualDensity(horizontal: 0, vertical: -4.0),
      minVerticalPadding: 0,
      horizontalTitleGap: 0,
      leading: Icon(Icons.date_range),
      title: Text(dateFormat.format(loansBook.returnDate)),
      subtitle: Text("Date de retour"),
    );
  }
}
