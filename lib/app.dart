import 'package:biblionantes/bloc/library_card/library_card_bloc.dart';
import 'package:biblionantes/pages/accountpage.dart';
import 'package:biblionantes/pages/loanspage.dart';
import 'package:biblionantes/pages/search_page.dart';
import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class AppWidget extends StatefulWidget {
  AppWidget({Key? key}) : super(key: key) {
  }

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

/// This is the private State class that goes with AppWidget.
class _AppWidgetState extends State<AppWidget> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    SearchPage(),
    LoansPageStateful(),
    AccountPageStateful(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }
  
  Widget buildBody() {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recherche',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.import_contacts),
            label: 'Livres empruntés',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership),
            label: 'Mes cartes',

          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
