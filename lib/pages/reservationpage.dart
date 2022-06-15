// ignore_for_file: unnecessary_const

import 'package:biblionantes/bloc/reservation/reservation_bloc.dart';
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
  const ReservationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = ReservationsBloc(accountRepository: context.read())
      ..add(LoadReservationsEvent());
    return BlocProvider.value(
      value: event,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mes reservations'),
          centerTitle: true,
        ),
        body: BlocBuilder<ReservationsBloc, ReservationsState>(
          builder: (_, state) {
            if (state is ReservationsInProgress) {
              return const Center(
                child: const CircularProgressIndicator(),
              );
            } else if (state is ReservationsList) {
              List<ReservationsBook> list = state.list;
              if (list.isEmpty) {
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
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                              omnidexId: element.omnidexId,
                              branchCode: element.branchCode)),
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4.0),
          minVerticalPadding: 0,
          horizontalTitleGap: 0,
          leading: const Icon(Icons.check, color: Colors.green),
          title: Text(
              """Votre réservation est disponible à ${reservationsBook.branchName}"""),
          subtitle: Text(
              """A récupérer avant ${dateFormat.format(reservationsBook.expiryDate!)}"""),
        );
      case ReservationsStatus.notAvailable:
        return ListTile(
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4.0),
          minVerticalPadding: 0,
          horizontalTitleGap: 0,
          leading: const Icon(Icons.hourglass_full, color: Colors.red),
          title: const Text("Votre réservation n'est pas encore disponible"),
          subtitle: Text(
              """Rang ${reservationsBook.rank} depuis ${dateFormat.format(reservationsBook.resvDate)}"""),
        );
      case ReservationsStatus.soonAvailable:
        return ListTile(
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4.0),
          minVerticalPadding: 0,
          horizontalTitleGap: 0,
          leading: const Icon(Icons.hourglass_bottom, color: Colors.amber),
          title: const Text("Votre réservation est bientôt disponible"),
          subtitle: Text(
              """Rang ${reservationsBook.rank} depuis ${dateFormat.format(reservationsBook.resvDate)}"""),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
