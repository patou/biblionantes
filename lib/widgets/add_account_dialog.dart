import 'package:biblionantes/bloc/library_card/library_card_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AddAccountDialog extends StatefulWidget {
  const AddAccountDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final FocusNode nameFocus = FocusNode();

  final FocusNode loginFocus = FocusNode();

  final FocusNode passwordFocus = FocusNode();

  final TextEditingController nameField = TextEditingController();

  final TextEditingController loginField = TextEditingController();

  final TextEditingController passwordField = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldAlertKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    nameField.dispose();
    loginField.dispose();
    passwordField.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LibraryCardBloc, AbstractLibraryCardState>(
      listener: (context, state) {
        if (state is AddLibraryCardStateSuccess) {
          Navigator.pop(context);
        }
        if (state is AddLibraryCardStateError) {
          print(state.error);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
                "La carte n'existe pas, vérifier le numero de la carte et la date de naissance"),
            backgroundColor: Colors.red[100],
            elevation: 30,
          ));
        }
      },
      child: Scaffold(
        key: _scaffoldAlertKey,
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          title: const Text("Ajouter une carte de bibliothèque"),
          scrollable: true,
          content: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 5.0),
                  GestureDetector(
                      onTap: () => nameFocus.requestFocus(),
                      child: const Text("Nom de la carte")),
                  TextFormField(
                      controller: nameField,
                      obscureText: false,
                      focusNode: nameFocus,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrez un nom de carte';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Nom de la carte",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      )),
                  const SizedBox(height: 5.0),
                  GestureDetector(
                      onTap: () => loginFocus.requestFocus(),
                      child: const Text("Numero de la carte")),
                  TextFormField(
                      controller: loginField,
                      obscureText: false,
                      focusNode: loginFocus,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrez le numéro de la carte';
                        }
                        if (value.length != 10) {
                          return 'Le numéro de la carte est de 10 chiffre';
                        }
                        return null;
                      },
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "0000000000",
                        helperText: "Numéro sur votre carte de bibliothèque",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      )),
                  const SizedBox(height: 5.0),
                  GestureDetector(
                      onTap: () => passwordFocus.requestFocus(),
                      child: const Text("Mot de passe")),
                  TextFormField(
                      controller: passwordField,
                      obscureText: true,
                      focusNode: passwordFocus,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: saveForm,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrez le mot de passe';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "JJDDAAAA ou ******",
                        helperText:
                            "Par défaut votre date de naissance ou votre mot de passe modifié",
                        helperMaxLines: 3,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      )),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black45),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            BlocBuilder<LibraryCardBloc, AbstractLibraryCardState>(
                buildWhen: (previous, current) =>
                    current is AddLibraryCardState,
                builder: (context, state) {
                  if (state is AddLibraryCardStateInProgress) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueAccent),
                    ),
                    onPressed: saveForm,
                    child: const Text("Ajouter"),
                  );
                }),
          ],
        ),
      ),
    );
  }

  void saveForm() async {
    if (formKey.currentState!.validate()) {
      context.read<LibraryCardBloc>().add(AddLibraryCardEvent(
          login: loginField.value.text,
          name: nameField.value.text,
          pass: passwordField.value.text));
    }
  }
}
