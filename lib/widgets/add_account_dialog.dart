import 'package:flutter/material.dart';

class AddAccountDialog extends StatelessWidget {
  AddAccountDialog({
    Key key, Future<bool> Function(String, String, String) this.onAddAccount,
  }) : super(key: key);
  Future<bool> Function(String, String, String) onAddAccount;
  TextFormField nameField = TextFormField(
      controller: TextEditingController(),
      obscureText: false,
      validator: (value) {
        if (value.isEmpty) {
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
        if (value.isEmpty) {
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
        if (value.isEmpty) {
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
    return Scaffold(
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
          new FlatButton(
            child: new Text("Ajouter"),
            color: Colors.blueAccent,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                try {
                  if (await onAddAccount(nameField.controller.value.text,
                      loginField.controller.value.text,
                      passwordField.controller.value.text)) {
                    Navigator.of(context).pop();
                  }
                }
                catch (e) {
                  _scaffoldAlertKey.currentState.showSnackBar(SnackBar(
                    content: Text("La carte n'existe pas, vérifier le numero de la carte et la date de naissance"),
                    backgroundColor: Colors.red[100],
                    elevation: 30,
                  ));
                }
              }
            },
          ),
          new FlatButton(
            child: new Text("Annuler"),
            textColor: Colors.black45,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );

  }
}