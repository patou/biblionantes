import 'package:auto_route/auto_route.dart';
import 'package:biblionantes/bloc/detail/detail_bloc.dart';
import 'package:biblionantes/models/book.dart';
import 'package:biblionantes/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:auto_route/auto_route.dart';

class DetailPage extends StatelessWidget {
  DetailPage({@PathParam('id') required this.id});

  String id;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DetailBloc(searchRepository: context.read())..add(LoadDetailEvent(this.id)),
        child: Scaffold(
            appBar: AppBar(
              title: Text('Détail'),
              centerTitle: true,
            ),
            body: BlocBuilder<DetailBloc, DetailState>(
              buildWhen: (last, next) => !(last is DetailSuccess),
              builder: (context, state) {
                if (state is DetailInProgress) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is DetailSuccess) {
                  return DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        BookCard(
                          book: state.detail.book,
                          useBoxShadow: false,
                        ),
                        Container(
                          child: TabBar(
                            labelColor: Colors.blue,
                            tabs: [
                              Tab(
                                icon: Icon(Icons.map),
                                text: "Où le trouver ?",
                              ),
                              Tab(
                                icon: Icon(Icons.more),
                                text: "En savoir plus",
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: TabBarView(
                            children: [
                              StockList(),
                              DetailMoreList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: Text('An error occurred'),
                );
              },
            )));
  }
}

class StockList extends StatelessWidget {
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  StockList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isLoans = context.routeData.parent?.path == 'loans';
    return ListView(
      children: [
        if (!isLoans)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: null,
              child: const Text('Réserver'),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: null,
              child: const Text('Prolonger'),
            ),
          ),
        Text(
          'Exemplaires:',
          style: TextStyle(fontSize: 16),
        ),
        BlocBuilder<DetailBloc, DetailState>(
            buildWhen: (last, next) => next is DetailSuccess && next.detail.stock.isNotEmpty,
            builder: (context, state) {
              print("builder ou ce trouve ce document ?");
              if (state is DetailSuccess) {
                print("list ${state.detail.stock.length}");
                if (state.detail.stock.isEmpty)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                return Column(children: [
                  for (var element in state.detail.stock)
                    ListTile(
                      leading: Icon(stockIcon(element.stat, element.isReserved)),
                      title: Text(element.branch),
                      subtitle: Text(
                        formatStatut(element),
                      ),
                      trailing: InkWell(
                        onTap: () => openModal(element, context),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Icon(Icons.place),
                        ),
                      ),
                    ),
                ]);
              }
              return Center(
                child: Text("Une erreur est apparus"),
              );
            })
      ],
    );
  }

  String formatStatut(Stock element) =>
      "${element.status}${element.duedate != null ? " retour prévu le ${dateFormat.format(element.duedate!)}" : ""}";

  IconData stockIcon(String stat, bool isReserved) {
    if (isReserved) return Icons.close;
    switch (stat) {
      case "ER": // En rayon
        return Icons.check;
      case "EP": // En prêt
        return Icons.exit_to_app;
      case "RF": // A consulter sur place
        return Icons.place;
      case "TT": // En transit
        return Icons.directions_car;
    }
    return Icons.outbox;
  }

  openModal(Stock element, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Row(
            children: [
              Icon(stockIcon(element.stat, element.isReserved)),
              Text("Où trouver ce document ?"),
            ],
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Bibliothèque : ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(element.branch),
              Text("Section : ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(element.subloca),
              Text("Categorie : ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(element.category),
              Text("Collection : ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(element.collection),
              Text("Code du livre : ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(element.callnumber),
              SizedBox(
                height: 15,
              ),
              Text(formatStatut(element), style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class DetailMoreList extends StatelessWidget {
  DetailMoreList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailBloc, DetailState>(
        buildWhen: (last, next) => next is DetailSuccess && next.detail.details.isNotEmpty,
        builder: (context, state) {
          print("builder ou ce trouve ce document ?");
          if (state is DetailSuccess) {
            print("list ${state.detail.details.length}");
            if (state.detail.details.isEmpty)
              return Center(
                child: CircularProgressIndicator(),
              );

            return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.detail.details.length,
                itemBuilder: (BuildContext context, int index) {
                  var detail = state.detail.details[index];
                  return ListTile(
                    title: Text(detail.value),
                    subtitle: Text(detail.display),
                    leading: Icon(detail.icon),
                  );
                }
            );
          }
          return Center(
            child: Text("Une erreur est apparus"),
          );
        });
  }
}
