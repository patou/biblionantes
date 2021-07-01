import 'package:auto_route/auto_route.dart';
import 'package:biblionantes/bloc/detail/detail_bloc.dart';
import 'package:biblionantes/models/book.dart';
import 'package:biblionantes/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';

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
                        BookCard(book: state.detail.book, useBoxShadow: false,),
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
                              Column(
                                children: [
                                  Text('Où trouver ce document ?'),
                                  BlocBuilder<DetailBloc, DetailState>(
                                      buildWhen: (last, next) => next is DetailSuccess,
                                      builder: (context, state) {
                                        print("builder ou ce trouve ce document ?");
                                          if (state is DetailSuccess) {
                                            print("list ${  state.detail.stock.length }");
                                            if (state.detail.stock.isEmpty)
                                              return Center(
                                                child: CircularProgressIndicator(),
                                              );

                                            return Column(
                                                children: [
                                                  for (var element in state.detail.stock)
                                                    Text("${element.branch} - ${element.subloca} - ${element.category} \n ${element.collection} - ${element.callnumber} - ${element.status}")
                                                ]);
                                          }
                                          return Center(
                                            child: Text("Une erreur est apparus"),
                                          );
                                      }
                                  /*GroupedListView<Stock, String>(
                                      elements: state.detail.stock,
                                      groupBy: (item) => "${item.branch} - ${item.subloca} - ${item.category}",
                                      groupSeparatorBuilder: (String value) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          value,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      itemBuilder: (c, element) {
                                        return Text("${element.collection} - ${element.callnumber} - ${element.status}");
                                      }
                                  ),*/
                                  )
                                ]),
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
            )
        )
    );
  }
}
