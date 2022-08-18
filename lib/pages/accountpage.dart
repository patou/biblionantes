import 'package:biblionantes/bloc/library_card/library_card_bloc.dart';
import 'package:biblionantes/models/summery_account.dart';
import 'package:biblionantes/widgets/add_account_dialog.dart';
import 'package:biblionantes/widgets/summary_account.dart';
import 'package:biblionantes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

class AccountPage extends StatelessWidget {
  AccountPage({Key? key}) : super(key: key);

  Widget _displayBody(BuildContext context, AbstractLibraryCardState state) {
    if (state is InitialLibraryCardState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is LibraryCardStateChange) {
      if (state.libraryCards.isEmpty) {
        return const Center(
          child: Text('Ajouter une nouvelle carte avec le bouton ci-dessous'),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(top: 20, bottom: 50),
        itemCount: state.libraryCards.length,
        itemBuilder: (_, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: SummaryAccountCard(
                account: state.libraryCards[index],
                onDeleteAccount: (account) {
                  _showConfirmDelete(account, context, context.read());
                }),
          );
        },
      );
    } else {
      return const Center(
        child: Text('An error occurred'),
      );
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Mes cartes de bibliothèque'),
          centerTitle: true,
          actions: [
            PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 1:
                    context.pushRoute(const AboutRoute());
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("À propos"),
                ),
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
          label: const Text("Ajouter une carte"),
          onPressed: () => _showDialog(context, context.read()),
        ),
        body: BlocBuilder<LibraryCardBloc, AbstractLibraryCardState>(
          buildWhen: (prev, next) => next is LibraryCardState,
          builder: _displayBody,
        ));
  }

  Future<void> _showConfirmDelete(LibraryCard account, BuildContext context,
      LibraryCardBloc libraryCardBloc) async {
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
              child: const Text('Oui'),
              onPressed: () {
                libraryCardBloc.add(RemoveLibraryCardEvent(account));
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Non'),
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
          child: const AddAccountDialog(),
        );
      },
    );
  }
}
