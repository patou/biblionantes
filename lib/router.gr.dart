// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import 'app.dart' as _i3;
import 'pages/accountpage.dart' as _i7;
import 'pages/detail_page.dart' as _i5;
import 'pages/loanspage.dart' as _i6;
import 'pages/search_page.dart' as _i4;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    AppWidget.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args =
              data.argsAs<AppWidgetArgs>(orElse: () => const AppWidgetArgs());
          return _i3.AppWidget(key: args.key);
        }),
    SearchRouter.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        }),
    LoansRouter.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        }),
    AccountRouter.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        }),
    SearchRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i4.SearchPage();
        }),
    DetailRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<DetailRouteArgs>(
              orElse: () => DetailRouteArgs(id: pathParams.getString('id')));
          return _i5.DetailPage(id: args.id);
        }),
    LoansRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i6.LoansPage();
        }),
    AccountRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i7.AccountPage();
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(AppWidget.name, path: '/', children: [
          _i1.RouteConfig(SearchRouter.name, path: 'search', children: [
            _i1.RouteConfig(SearchRoute.name, path: ''),
            _i1.RouteConfig(DetailRoute.name, path: ':id'),
            _i1.RouteConfig('*#redirect',
                path: '*', redirectTo: '', fullMatch: true)
          ]),
          _i1.RouteConfig(LoansRouter.name, path: 'loans', children: [
            _i1.RouteConfig(LoansRoute.name, path: ''),
            _i1.RouteConfig(DetailRoute.name, path: ':id'),
            _i1.RouteConfig('*#redirect',
                path: '*', redirectTo: '', fullMatch: true)
          ]),
          _i1.RouteConfig(AccountRouter.name, path: 'account', children: [
            _i1.RouteConfig(AccountRoute.name, path: ''),
            _i1.RouteConfig('*#redirect',
                path: '*', redirectTo: '', fullMatch: true)
          ])
        ])
      ];
}

class AppWidget extends _i1.PageRouteInfo<AppWidgetArgs> {
  AppWidget({_i2.Key? key, List<_i1.PageRouteInfo>? children})
      : super(name,
            path: '/',
            args: AppWidgetArgs(key: key),
            initialChildren: children);

  static const String name = 'AppWidget';
}

class AppWidgetArgs {
  const AppWidgetArgs({this.key});

  final _i2.Key? key;
}

class SearchRouter extends _i1.PageRouteInfo {
  const SearchRouter({List<_i1.PageRouteInfo>? children})
      : super(name, path: 'search', initialChildren: children);

  static const String name = 'SearchRouter';
}

class LoansRouter extends _i1.PageRouteInfo {
  const LoansRouter({List<_i1.PageRouteInfo>? children})
      : super(name, path: 'loans', initialChildren: children);

  static const String name = 'LoansRouter';
}

class AccountRouter extends _i1.PageRouteInfo {
  const AccountRouter({List<_i1.PageRouteInfo>? children})
      : super(name, path: 'account', initialChildren: children);

  static const String name = 'AccountRouter';
}

class SearchRoute extends _i1.PageRouteInfo {
  const SearchRoute() : super(name, path: '');

  static const String name = 'SearchRoute';
}

class DetailRoute extends _i1.PageRouteInfo<DetailRouteArgs> {
  DetailRoute({required String id})
      : super(name,
            path: ':id',
            args: DetailRouteArgs(id: id),
            rawPathParams: {'id': id});

  static const String name = 'DetailRoute';
}

class DetailRouteArgs {
  const DetailRouteArgs({required this.id});

  final String id;
}

class LoansRoute extends _i1.PageRouteInfo {
  const LoansRoute() : super(name, path: '');

  static const String name = 'LoansRoute';
}

class AccountRoute extends _i1.PageRouteInfo {
  const AccountRoute() : super(name, path: '');

  static const String name = 'AccountRoute';
}
