import 'package:biblionantes/bloc/loans/loans_bloc.dart';
import 'package:biblionantes/models/loansbook.dart';
import 'package:biblionantes/router.gr.dart';
import 'package:biblionantes/widgets/book_card.dart';
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
    return BlocProvider.value(
      value: event,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mes livres empruntés'),
          centerTitle: true,
        ),
        body: BlocBuilder<LoansBloc, LoansState>(
          builder: (_, state) {
            if (state is LoansInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is LoansList) {
              List<LoansBook> list = state.list;
              if (list.length == 0) {
                return Center(
                  child: Text("Aucun emprunt en cours"),
                );
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
                          onTap: () => context.pushRoute(DetailRoute(
                                id: element.id,
                                action: element.renewable ? 'renew' : null,
                                account: element.renewable ? element.login : null,
                                documentNumber: element.documentNumber,
                              )),
                          child: BookCard(
                            book: element,
                            widget: LoansReturn(loansBook: element),
                          ));
                    }),
              );
            } else {
              return Center(
                child: Text('An error occurred'),
              );
            }
          },
        ),
      ),
    );
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
