import 'package:biblionantes/models/summery_account.dart';
import 'package:biblionantes/repositories/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SummaryAccountCard extends StatelessWidget {
  final LibraryCard account;
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  final void Function(LibraryCard) onDeleteAccount;

  SummaryAccountCard({
    Key? key,
    required this.account,
    required this.onDeleteAccount,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Text(account.name, textAlign: TextAlign.center, textScaleFactor: 1.5),
          FutureBuilder<SummeryAccount>(
              future: context.read<LibraryCardRepository>().loadSummaryAccount(account),
              builder: (_, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(
                    child: Text('Une erreur est apparue'),
                  );
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                SummeryAccount summary = snapshot.requireData;
                var expirationDays = summary.expiryDate!.difference(DateTime.now()).inDays;
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.supervised_user_circle),
                      title: Text("${summary.firstName} ${summary.lastName}"),
                      subtitle: Text("Numéro : ${account.login}"),
                    ),
                    if (summary.hasTrapLevel)
                        const ListTile(
                            leading: Icon(Icons.warning, color: Colors.red),
                            title: Text(
                                "Votre carte est bloqué, rapprochez vous de votre bibliothèque"),
                        ),
                    if (summary.expiryDate != null && expirationDays < 30)
                      const ListTile(
                        leading: Icon(Icons.warning, color: Colors.amber),
                        title: Text(
                            "Votre abonnement sera bientôt à renouveler."),
                      ),
                    if (summary.expiryDate != null && summary.subscriptionDate != null)
                        ListTile(
                          leading: const Icon(Icons.date_range),
                          title: Text(
                                "Expire le ${dateFormat.format(summary.expiryDate!)}${expirationDays < 30 ? ' (dans $expirationDays jours)':''}"),
                          subtitle: Text(
                              "Depuis le ${dateFormat.format(summary.subscriptionDate!)}"),
                        ),
                    ListTile(
                      leading: const Icon(Icons.import_contacts),
                      title: Text(
                          "Emprunts en cours : ${summary.loanCount}/${summary.maxLoans}"),
                    ),
                    (summary.overdueLoans > 0)
                        ? ListTile(
                            leading: const Icon(Icons.watch_later, color: Colors.red),
                            title: Text(
                                "Emprunts en retards : ${summary.overdueLoans}"),
                          )
                        : const SizedBox.shrink(),
                    ListTile(
                      leading: const Icon(Icons.my_library_books),
                      title: Text("Réservations : ${summary.resvCount}"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(summary.emailAddress),
                      subtitle: const Text("Courriel"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(summary.telephone),
                      subtitle: const Text("Téléphone"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_pin),
                      title: Text([
                        summary.street,
                        summary.postalCode,
                        summary.city
                      ].join(" ")),
                      subtitle: const Text("Adresse"),
                    ),
                  ],
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Supprimer'),
                onPressed: () {
                  onDeleteAccount(account);
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
