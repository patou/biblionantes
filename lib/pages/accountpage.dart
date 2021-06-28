import 'package:biblionantes/bloc/library_card/library_card_bloc.dart';
import 'package:biblionantes/models/SummeryAccount.dart';
import 'package:biblionantes/widgets/add_account_dialog.dart';
import 'package:biblionantes/widgets/summary_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatelessWidget {
  Widget _displayBody(BuildContext context, AbstractLibraryCardState state) {
    if (state is InitialLibraryCardState) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is LibraryCardStateChange) {
      if (state.libraryCards.isEmpty) {
        return Center(
          child: Text('Ajouter une nouvelle carte avec le bouton ci-dessous'),
        );
      }

      return ListView.builder(
        itemCount: state.libraryCards.length,
        itemBuilder: (_, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            child: SummaryAccountCard(account: state.libraryCards[index], onDeleteAccount: (account) {
              _showConfirmDelete(account, context, context.read());
            }),
          );
        },
      );
    }
    else {
      return Center(
          child: Text('An error occurred'),
        );

    }
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
        onPressed: () => _showDialog(context, context.read()),
      ),
      body: BlocBuilder<LibraryCardBloc, AbstractLibraryCardState>(
        buildWhen: (prev, next) => next is LibraryCardState,
        builder: _displayBody,
      )
    );
  }


  Future<void> _showConfirmDelete(LibraryCard account, BuildContext context, LibraryCardBloc libraryCardBloc) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Suppression du compte ${account.name}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Voulez-vous supprimer le compte ${account.name} ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Oui'),
              onPressed: () {
                libraryCardBloc.add(RemoveLibraryCardEvent(account));
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Non'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog(BuildContext context, LibraryCardBloc libraryCardBloc) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return BlocProvider.value(
          value: libraryCardBloc,
          child: AddAccountDialog(),
        );
      },
    );
  }
}