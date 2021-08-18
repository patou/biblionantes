import 'package:biblionantes/models/SummeryAccount.dart';
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
  _ReserveBookDialogState createState() => _ReserveBookDialogState();
}

class _ReserveBookDialogState extends State<ReserveBookDialog> {
  String? _account;
  String? _lieu;
  List<ReservationChoices> reservationChoices = [];

  @override
  void initState() {
    super.initState();
    loadReservationChoices();
  }

  Future<void> loadReservationChoices() async {
    var libraryCardRepository = context.read<LibraryCardRepository>();
    var accounts = libraryCardRepository.accounts;
    if (accounts.isNotEmpty)
      setState(() {
        _account = accounts[0].login;
      });
    var choices = await libraryCardRepository.reservationChoices(widget.bookId);
    setState(() {
      reservationChoices = choices;
    });
  }

  @override
  Widget build(BuildContext context) {
    var libraryCardRepository = context.read<LibraryCardRepository>();
    var accounts = libraryCardRepository.accounts;
    print(accounts);
    if (accounts.isEmpty)
      return AlertDialog(
        title: Row(
          children: [
            Text("Pas de carte"),
          ],
        ),

        content: Text("Vous devez ajouter une carte pour pouvoir effectuer une réservation"),
        actions: <Widget>[
          TextButton(
            child: const Text('Fermer'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    return AlertDialog(
      title: Row(
        children: [
          Text("Reserver ce document"),
        ],
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Avec quel carte ? : ", style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            focusColor:Colors.white,
            value: _account,
            //elevation: 5,
            style: TextStyle(color: Colors.white),
            iconEnabledColor:Colors.black,
            items: accounts.map<DropdownMenuItem<String>>((LibraryCard value) {
              return DropdownMenuItem<String>(
                value: value.login,
                child: Text(value.name,style:TextStyle(color:Colors.black),),
              );
            }).toList(),
            hint:Text(
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
          ),
          Text("Lieu de retrait : ", style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            focusColor:Colors.white,
            value: _lieu,
            //elevation: 5,
            style: TextStyle(color: Colors.white),
            iconEnabledColor:Colors.black,
            items: reservationChoices.map<DropdownMenuItem<String>>((ReservationChoices value) {
              return DropdownMenuItem<String>(
                value: value.code,
                child: Text(value.name, style:TextStyle(color:Colors.black),),
              );
            }).toList(),
            hint:Text(
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
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Réserver'),
          onPressed: () {
            Navigator.of(context).pop(true);
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
}
