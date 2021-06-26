import 'package:biblionantes/library_card/library_card_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AddAccountDialog extends StatelessWidget {
  AddAccountDialog({
    Key? key,
  }) : super(key: key);
  TextFormField nameField = TextFormField(
      controller: TextEditingController(),
      obscureText: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Entrez un nom de carte';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Nom de la carte",
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      )
  );
  TextFormField loginField = TextFormField(
      controller: TextEditingController(),
      obscureText: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Entrez le numéro de la carte';
        }
        if (value.length != 10) {
          return 'Le numéro de la carte est de 10 chiffre';
        }
        return null;
      },
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "0000000000",
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      )
  );
  TextFormField passwordField = TextFormField(
      controller: TextEditingController(),
      obscureText: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Entrez le mot de passe';
        }
        return null;
      },
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Défaut date (JJMMAAAA)",
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      )
  );
  final GlobalKey<ScaffoldState> _scaffoldAlertKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return BlocListener<LibraryCardBloc, AbstractLibraryCardState>(
      listener: (context, state) {
        if (state is AddLibraryCardStateSuccess) {
          print("Carte ajouté");
          Navigator.pop(context);
        }
        if (state is AddLibraryCardStateError) {
          print(state.error);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("La carte n'existe pas, vérifier le numero de la carte et la date de naissance"),
            backgroundColor: Colors.red[100],
            elevation: 30,
            ));
        }
      },
      child: Scaffold(
        key: _scaffoldAlertKey,
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          title: new Text("Ajouter une carte de bibliothèque"),
          content: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 5.0),
                  Text("Nom de la carte"),
                  nameField,
                  SizedBox(height: 5.0),
                  Text("Numero de la carte"),
                  loginField,
                  SizedBox(height: 5.0),
                  Text("Mot de passe"),
                  passwordField,
                ],
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            BlocBuilder<LibraryCardBloc, AbstractLibraryCardState>(
              buildWhen: (previous, current) => current is AddLibraryCardState,
              builder: (context, state) {
                if (state is AddLibraryCardStateInProgress)
                  return  CircularProgressIndicator();
                return new TextButton(
                  child: new Text("Ajouter"),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.blueAccent),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      context.read<LibraryCardBloc>().add(AddLibraryCardEvent(login: loginField.controller!.value.text, name: nameField.controller!
                          .value.text, pass: passwordField.controller!.value.text));
                    }
                  },
                );
              }
            ),
            new TextButton(
              child: new Text("Annuler"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black45),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );

  }
}