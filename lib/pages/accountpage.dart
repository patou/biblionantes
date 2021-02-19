import 'package:biblionantes/models/SummeryAccount.dart';
import 'package:biblionantes/repositories/account_repository.dart';
import 'package:biblionantes/widgets/account_card.dart';
import 'package:biblionantes/widgets/add_account_dialog.dart';
import 'package:biblionantes/widgets/summary_account.dart';
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
          child: SummaryAccountCard(account: _accounts[index], accountRepository: widget.accountRepository),
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