import 'package:auto_route/auto_route.dart';
import 'package:biblionantes/pages/WebPage.dart';
import 'package:biblionantes/pages/about_page.dart';
import 'package:biblionantes/pages/accountpage.dart';
import 'package:biblionantes/pages/detail_page.dart';
import 'package:biblionantes/pages/loanspage.dart';
import 'package:biblionantes/pages/reservationpage.dart';
import 'package:biblionantes/pages/search_list.dart';
import 'package:biblionantes/pages/search_page.dart';
import 'package:flutter/material.dart';

import 'app.dart';

part 'router.gr.dart';

@RoutePage(name: 'SearchTab')
class SearchTabPage extends AutoRouter {
  const SearchTabPage({super.key});
}

@RoutePage(name: 'LoansTab')
class LoansTabPage extends AutoRouter {
  const LoansTabPage({super.key});
}

@RoutePage(name: 'ReservationTab')
class ReservationTabPage extends AutoRouter {
  const ReservationTabPage({super.key});
}

@RoutePage(name: 'AccountTab')
class AccountTabPage extends AutoRouter {
  const AccountTabPage({super.key});
}

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: "/",
          page: AppRoute.page,
          children: [
            AutoRoute(
              path: "search",
              page: SearchTab.page,
              children: [
                AutoRoute(path: '', page: WebRoute.page),
                AutoRoute(path: ':id', page: DetailRoute.page),
                RedirectRoute(path: '*', redirectTo: ''),
              ],
            ),
            AutoRoute(
              path: "loans",
              page: LoansTab.page,
              children: [
                AutoRoute(path: '', page: LoansRoute.page),
                AutoRoute(path: ':id', page: DetailRoute.page),
                RedirectRoute(path: '*', redirectTo: ''),
              ],
            ),
            AutoRoute(
              path: "reservation",
              page: ReservationTab.page,
              children: [
                AutoRoute(path: '', page: ReservationRoute.page),
                AutoRoute(path: ':id', page: DetailRoute.page),
                RedirectRoute(path: '*', redirectTo: ''),
              ],
            ),
            AutoRoute(
              path: "account",
              page: AccountTab.page,
              children: [
                AutoRoute(path: '', page: AccountRoute.page),
                AutoRoute(path: 'about', page: AboutRoute.page),
                RedirectRoute(path: '*', redirectTo: ''),
              ],
            ),
          ],
        )
      ];
}
