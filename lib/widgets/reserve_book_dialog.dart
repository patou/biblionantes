import 'package:biblionantes/models/summery_account.dart';
import 'package:biblionantes/models/reservation.dart';
import 'package:biblionantes/repositories/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReserveBookDialog extends StatefulWidget {
  final String bookId;

  const ReserveBookDialog({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  @override
  ReserveBookDialogState createState() => ReserveBookDialogState();
}

class ReserveBookDialogState extends State<ReserveBookDialog> {
  String? _account;
  String? _lieu;
  bool _loading = true;
  List<ReservationChoices> reservationChoices = [];

  @override
  void initState() {
    super.initState();
    loadReservationChoices();
  }

  Future<void> loadReservationChoices() async {
    var libraryCardRepository = context.read<LibraryCardRepository>();
    var accounts = libraryCardRepository.accounts;
    if (accounts.isNotEmpty) {
      setState(() {
        _account = accounts[0].login;
      });
    }
    var choices = await libraryCardRepository.reservationChoices(widget.bookId);
    setState(() {
      reservationChoices = choices;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var libraryCardRepository = context.read<LibraryCardRepository>();
    var accounts = libraryCardRepository.accounts;
    if (accounts.isEmpty) {
      return AlertDialog(
        title: Row(
          children: const [
            Text("Pas de carte"),
          ],
        ),
        content: const Text(
            "Vous devez ajouter une carte pour pouvoir effectuer une réservation"),
        actions: <Widget>[
          TextButton(
            child: const Text('Fermer'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
    final formKey = GlobalKey<FormState>();
    return AlertDialog(
      title: Row(
        children: const [
          Text("Reserver ce document"),
        ],
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Avec quel carte ? : ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              focusColor: Colors.white,
              value: _account,
              //elevation: 5,
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              items:
                  accounts.map<DropdownMenuItem<String>>((LibraryCard value) {
                return DropdownMenuItem<String>(
                  value: value.login,
                  child: Text(
                    value.name,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              hint: const Text(
                "Choisissez une carte",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              onChanged: (String? value) {
                setState(() {
                  _account = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Choisissez une carte';
                }
                return null;
              },
            ),
            const Text("Lieu de retrait : ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              focusColor: Colors.white,
              value: _lieu,
              //elevation: 5,
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              items: reservationChoices
                  .map<DropdownMenuItem<String>>((ReservationChoices value) {
                return DropdownMenuItem<String>(
                  value: value.code,
                  child: Text(
                    value.name,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              hint: const Text(
                "Choisissez le lieu de retrait",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              onChanged: (String? value) {
                setState(() {
                  _lieu = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Choisissez un lieu de retrait';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        _loading
            ? const CircularProgressIndicator()
            : TextButton(
                child: const Text('Réserver'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await doReserveBook(context);
                  }
                },
              ),
        TextButton(
          child: const Text('Annuler'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<void> doReserveBook(BuildContext context) async {
    try {
      setState(() {
        _loading = true;
      });
      bool reserved = await context
          .read<LibraryCardRepository>()
          .reserveBook(_account!, _lieu!, widget.bookId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: reserved ? Colors.lightGreen : Colors.redAccent,
        content: Text(reserved
            ? "Document reservé, vous recevrez un mail lors qu'il sera disponible."
            : "Il n'est pas possible de réserver ce document"),
      ));
      Navigator.of(context).pop(reserved);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content:
            Text("""Il n'est pas possible de réserver ce document : $error"""),
      ));
      Navigator.of(context).pop(false);
    }
  }
}
