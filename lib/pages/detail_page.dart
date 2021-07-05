import 'package:auto_route/auto_route.dart';
import 'package:biblionantes/bloc/detail/detail_bloc.dart';
import 'package:biblionantes/models/book.dart';
import 'package:biblionantes/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

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
                              Icon(Icons.directions_transit),
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
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: null,
            child: const Text('Réserver'),
          ),
        ),
        Text('Exemplaires:', style: TextStyle(fontSize: 16),),
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
                        title: Text([element.collection, element.callnumber, "${element.status}${element.duedate != null ? " retour prévu le ${dateFormat.format(element.duedate!)}": ""}"].where((s) => s.isNotEmpty).join(" - ")),
                        subtitle: Text(
                          [element.branch, element.subloca, element.category].where((s) => s.isNotEmpty).join(" - "),
                        ),
                    ),

                ]);
              }
              return Center(
                child: Text("Une erreur est apparus"),
              );
            }
        )
      ],
    );
  }

  IconData stockIcon(String stat, bool isReserved) {
    if (isReserved)
      return Icons.close;
    switch(stat) {
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
}
