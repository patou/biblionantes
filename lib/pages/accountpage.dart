import 'package:biblionantes/models/SummeryAccount.dart';
import 'package:biblionantes/repositories/account_repository.dart';
import 'package:biblionantes/widgets/account_card.dart';
import 'package:flutter/material.dart';

class AccountPageStateful extends StatefulWidget {
  final AccountRepository accountRepository;

  AccountPageStateful({@required this.accountRepository})
      : assert(accountRepository != null);

  @override
  _AccountPageStatefulState createState() => _AccountPageStatefulState();
}

class _AccountPageStatefulState extends State<AccountPageStateful> {
  List<Account> _accounts;
  bool _isError = false;
  bool _isLoading = true;

  Widget _displayBody() {
    if (_isError) {
      return Center(
        child: Text('An error occurred'),
      );
    }

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_accounts.isEmpty) {
      return Center(
        child: Text('Ajouter une nouvelle carte avec le bouton ci-dessous'),
      );
    }

    return ListView.builder(
      itemCount: _accounts.length,
      itemBuilder: (_, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: AccountCard(account: _accounts[index]),
        );
      },
    );
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Mes cartes de bibliothèque'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        label: Text("Ajouter une carte"),
        onPressed: () {
          _showDialog();
        },
      ),
      body: _displayBody(),
    );
  }

  void _loadAccount() async {
    try {
      final accounts = await widget.accountRepository.getAccounts();
      setState(() {
        _isError = false;
        _isLoading = false;
        _accounts = accounts;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
        _accounts = null;
      });
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AddAccountDialog(onAddAccount: (name, login, password) async {
          try {
            await widget.accountRepository.addAccount(name, login, password);
            _loadAccount();
            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("La carte $name a bien été ajouté"),));
            print("Carte ajouté " + name);
            return true;
          }
          catch (e) {
            print(e.toString());
            return Future.error(e);
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAccount();
  }
}

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
          return 'Entrez la date de naissance';
        }
        if (value.length != 8) {
          return 'La date de naissance est sur 8 chiffre (JJMMAAAA)';
        }
        return null;
      },
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "JJMMAAAA",
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
                Text("Date de naissance"),
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