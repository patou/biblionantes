import 'package:biblionantes/bloc/loans/loans_bloc.dart';
import 'package:biblionantes/bloc/reservation/reservation_bloc.dart';
import 'package:biblionantes/models/loansbook.dart';
import 'package:biblionantes/models/reservationsbook.dart';
import 'package:biblionantes/router.gr.dart';
import 'package:biblionantes/widgets/book_card.dart';
import 'package:biblionantes/widgets/no_result_widget.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

class ReservationPage extends StatelessWidget {
  ReservationPage();

  @override
  Widget build(BuildContext context) {
    print("build reservationPage");
    final event = ReservationsBloc(accountRepository: context.read())
      ..add(LoadReservationsEvent());
    return BlocProvider.value(
      value: event,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mes reservations'),
          centerTitle: true,
        ),
        body: BlocBuilder<ReservationsBloc, ReservationsState>(
          builder: (_, state) {
            if (state is ReservationsInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ReservationsList) {
              List<ReservationsBook> list = state.list;
              if (list.length == 0) {
                return NoResultWidget(
                    noResultText: 'Aucune reservations en cours',
                    retryButtonText: 'Rafraichir',
                    onRetry: () async {
                      event.add(LoadReservationsEvent());
                    });
              }
              return RefreshIndicator(
                onRefresh: () async {
                  event.add(LoadReservationsEvent());
                },
                child: GroupedListView<ReservationsBook, String>(
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
                                action: 'cancel',
                                account: element.login,
                                documentNumber: element.documentNumber,
                                seqNo: element.seqNo,
                              )),
                          child: BookCard(
                            book: element,
                            widget: ReservationInfo(reservationsBook: element),
                          ));
                    }),
              );
            } else {
              return NoResultWidget(
                  noResultText: 'Une erreur est apparue',
                  retryButtonText: 'Ré-essayer',
                  onRetry: () async {
                    event.add(LoadReservationsEvent());
                  });
            }
          },
        ),
      ),
    );
  }
}

class ReservationInfo extends StatelessWidget {
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  ReservationInfo({
    Key? key,
    required this.reservationsBook,
  }) : super(key: key);

  final ReservationsBook reservationsBook;

  @override
  Widget build(BuildContext context) {
    switch (reservationsBook.status) {
      case ReservationsStatus.available:
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
          visualDensity: VisualDensity(horizontal: 0, vertical: -4.0),
          minVerticalPadding: 0,
          horizontalTitleGap: 0,
          leading: Icon(Icons.check, color: Colors.green),
          title: Text("""Votre réservation est disponible à ${reservationsBook.branchName}"""),
          subtitle: Text("""A récupérer avant ${dateFormat.format(reservationsBook.expiryDate!)}"""),
        );
        break;
      case ReservationsStatus.notAvailable:
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
          visualDensity: VisualDensity(horizontal: 0, vertical: -4.0),
          minVerticalPadding: 0,
          horizontalTitleGap: 0,
          leading: Icon(Icons.hourglass_full, color: Colors.red),
          title: Text("Votre réservation n'est pas encore disponible"),
          subtitle: Text("""Rang ${reservationsBook.rank} depuis ${dateFormat.format(reservationsBook.resvDate)}"""),
        );
        break;
      case ReservationsStatus.soonAvailable:
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
          visualDensity: VisualDensity(horizontal: 0, vertical: -4.0),
          minVerticalPadding: 0,
          horizontalTitleGap: 0,
          leading: Icon(Icons.hourglass_bottom, color: Colors.amber),
          title: Text("Votre réservation est bientôt disponible"),
          subtitle: Text("""Rang ${reservationsBook.rank} depuis ${dateFormat.format(reservationsBook.resvDate)}"""),
        );
        break;
      default:
        return SizedBox.shrink();
    }

  }
}
