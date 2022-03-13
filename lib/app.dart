import 'package:auto_route/auto_route.dart';
import 'package:biblionantes/router.gr.dart';
import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class AppWidget extends StatelessWidget {
  AppWidget({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: [
        SearchRouter(),
        LoansRouter(),
        ReservationRouter(),
        AccountRouter()
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
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
              icon: Icon(Icons.date_range),
              label: 'Reservations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_membership),
              label: 'Mes cartes',

            ),
          ],
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          selectedItemColor: Colors.blueAccent[800],
          unselectedItemColor: Colors.black,
        );
      }
    );
  }
}
