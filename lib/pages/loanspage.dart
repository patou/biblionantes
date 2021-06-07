import 'package:biblionantes/models/loansbook.dart';
import 'package:biblionantes/repositories/account_repository.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoansPageStateful extends StatelessWidget {
  final AccountRepository accountRepository;
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  LoansPageStateful({required this.accountRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes livres empruntés'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<LoansBook>>(
        future: accountRepository.loadLoansList(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<LoansBook> list = snapshot.requireData;
          if (list.length == 0) {
            return Center(
              child: Text("Aucun emprunt en cours"),
            );
          }
          return GroupedListView<dynamic, String>(
            elements: list,
            groupBy: (element) => element.account,
            useStickyGroupSeparators: true,
            groupSeparatorBuilder: (String value) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ),
            itemBuilder: (c, element) {
              return Card(
                  elevation: 1.0,
                  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                    child: ListTile(
                      leading: Icon(Icons.book),
                      title: Text(element.title),
                      subtitle: Text(dateFormat.format(element.returnDate)),
                    )
                  )
              );
            }
          );
        },
      ),
    );
  }
}
