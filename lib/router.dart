import 'package:auto_route/auto_route.dart';
import 'package:biblionantes/pages/accountpage.dart';
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
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        AutoRoute(
          path: "loans",
          name: "LoansRouter",
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: LoansPage),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        AutoRoute(
          path: "account",
          name: "AccountRouter",
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: AccountPage),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
      ],
    ),
  ],
)
class $AppRouter {}