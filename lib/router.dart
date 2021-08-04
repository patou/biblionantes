import 'package:auto_route/auto_route.dart';
import 'package:biblionantes/pages/about_page.dart';
import 'package:biblionantes/pages/accountpage.dart';
import 'package:biblionantes/pages/detail_page.dart';
import 'package:biblionantes/pages/loanspage.dart';
import 'package:biblionantes/pages/search_page.dart';

import 'app.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: "/",
      page: AppWidget,
      children: [
        AutoRoute(
          path: "search",
          name: "SearchRouter",
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: SearchPage),
            AutoRoute(path: ':id', page: DetailPage),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        AutoRoute(
          path: "loans",
          name: "LoansRouter",
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: LoansPage),
            AutoRoute(path: ':id', page: DetailPage),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        AutoRoute(
          path: "account",
          name: "AccountRouter",
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: AccountPage),
            AutoRoute(path: 'about', page: AboutPage),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
      ],
    ),
  ],
)
class $AppRouter {}