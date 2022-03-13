// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/material.dart' as _i9;

import 'app.dart' as _i1;
import 'pages/about_page.dart' as _i8;
import 'pages/accountpage.dart' as _i7;
import 'pages/detail_page.dart' as _i4;
import 'pages/loanspage.dart' as _i5;
import 'pages/reservationpage.dart' as _i6;
import 'pages/search_page.dart' as _i3;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i9.GlobalKey<_i9.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    AppWidget.name: (routeData) {
      final args =
          routeData.argsAs<AppWidgetArgs>(orElse: () => const AppWidgetArgs());
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.AppWidget(key: args.key));
    },
    SearchRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    LoansRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    ReservationRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    AccountRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    SearchRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.SearchPage());
    },
    DetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<DetailRouteArgs>(
          orElse: () => DetailRouteArgs(
              id: pathParams.getString('id'),
              action: queryParams.optString('action'),
              account: queryParams.optString('account'),
              documentNumber: queryParams.optString('documentNumber'),
              seqNo: queryParams.optString('seqNo'),
              branchCode: queryParams.optString('branchCode'),
              omnidexId: queryParams.optString('omnidexId')));
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i4.DetailPage(
              id: args.id,
              action: args.action,
              account: args.account,
              documentNumber: args.documentNumber,
              seqNo: args.seqNo,
              branchCode: args.branchCode,
              omnidexId: args.omnidexId));
    },
    LoansRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i5.LoansPage());
    },
    ReservationRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i6.ReservationPage());
    },
    AccountRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i7.AccountPage());
    },
    AboutRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: _i8.AboutPage());
    }
  };

  @override
  List<_i2.RouteConfig> get routes => [
        _i2.RouteConfig(AppWidget.name, path: '/', children: [
          _i2.RouteConfig(SearchRouter.name,
              path: 'search',
              parent: AppWidget.name,
              children: [
                _i2.RouteConfig(SearchRoute.name,
                    path: '', parent: SearchRouter.name),
                _i2.RouteConfig(DetailRoute.name,
                    path: ':id', parent: SearchRouter.name),
                _i2.RouteConfig('*#redirect',
                    path: '*',
                    parent: SearchRouter.name,
                    redirectTo: '',
                    fullMatch: true)
              ]),
          _i2.RouteConfig(LoansRouter.name,
              path: 'loans',
              parent: AppWidget.name,
              children: [
                _i2.RouteConfig(LoansRoute.name,
                    path: '', parent: LoansRouter.name),
                _i2.RouteConfig(DetailRoute.name,
                    path: ':id', parent: LoansRouter.name),
                _i2.RouteConfig('*#redirect',
                    path: '*',
                    parent: LoansRouter.name,
                    redirectTo: '',
                    fullMatch: true)
              ]),
          _i2.RouteConfig(ReservationRouter.name,
              path: 'reservation',
              parent: AppWidget.name,
              children: [
                _i2.RouteConfig(ReservationRoute.name,
                    path: '', parent: ReservationRouter.name),
                _i2.RouteConfig(DetailRoute.name,
                    path: ':id', parent: ReservationRouter.name),
                _i2.RouteConfig('*#redirect',
                    path: '*',
                    parent: ReservationRouter.name,
                    redirectTo: '',
                    fullMatch: true)
              ]),
          _i2.RouteConfig(AccountRouter.name,
              path: 'account',
              parent: AppWidget.name,
              children: [
                _i2.RouteConfig(AccountRoute.name,
                    path: '', parent: AccountRouter.name),
                _i2.RouteConfig(AboutRoute.name,
                    path: 'about', parent: AccountRouter.name),
                _i2.RouteConfig('*#redirect',
                    path: '*',
                    parent: AccountRouter.name,
                    redirectTo: '',
                    fullMatch: true)
              ])
        ])
      ];
}

/// generated route for
/// [_i1.AppWidget]
class AppWidget extends _i2.PageRouteInfo<AppWidgetArgs> {
  AppWidget({_i9.Key? key, List<_i2.PageRouteInfo>? children})
      : super(AppWidget.name,
            path: '/',
            args: AppWidgetArgs(key: key),
            initialChildren: children);

  static const String name = 'AppWidget';
}

class AppWidgetArgs {
  const AppWidgetArgs({this.key});

  final _i9.Key? key;

  @override
  String toString() {
    return 'AppWidgetArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.EmptyRouterPage]
class SearchRouter extends _i2.PageRouteInfo<void> {
  const SearchRouter({List<_i2.PageRouteInfo>? children})
      : super(SearchRouter.name, path: 'search', initialChildren: children);

  static const String name = 'SearchRouter';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class LoansRouter extends _i2.PageRouteInfo<void> {
  const LoansRouter({List<_i2.PageRouteInfo>? children})
      : super(LoansRouter.name, path: 'loans', initialChildren: children);

  static const String name = 'LoansRouter';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class ReservationRouter extends _i2.PageRouteInfo<void> {
  const ReservationRouter({List<_i2.PageRouteInfo>? children})
      : super(ReservationRouter.name,
            path: 'reservation', initialChildren: children);

  static const String name = 'ReservationRouter';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class AccountRouter extends _i2.PageRouteInfo<void> {
  const AccountRouter({List<_i2.PageRouteInfo>? children})
      : super(AccountRouter.name, path: 'account', initialChildren: children);

  static const String name = 'AccountRouter';
}

/// generated route for
/// [_i3.SearchPage]
class SearchRoute extends _i2.PageRouteInfo<void> {
  const SearchRoute() : super(SearchRoute.name, path: '');

  static const String name = 'SearchRoute';
}

/// generated route for
/// [_i4.DetailPage]
class DetailRoute extends _i2.PageRouteInfo<DetailRouteArgs> {
  DetailRoute(
      {required String id,
      String? action,
      String? account,
      String? documentNumber,
      String? seqNo,
      String? branchCode,
      String? omnidexId})
      : super(DetailRoute.name,
            path: ':id',
            args: DetailRouteArgs(
                id: id,
                action: action,
                account: account,
                documentNumber: documentNumber,
                seqNo: seqNo,
                branchCode: branchCode,
                omnidexId: omnidexId),
            rawPathParams: {
              'id': id
            },
            rawQueryParams: {
              'action': action,
              'account': account,
              'documentNumber': documentNumber,
              'seqNo': seqNo,
              'branchCode': branchCode,
              'omnidexId': omnidexId
            });

  static const String name = 'DetailRoute';
}

class DetailRouteArgs {
  const DetailRouteArgs(
      {required this.id,
      this.action,
      this.account,
      this.documentNumber,
      this.seqNo,
      this.branchCode,
      this.omnidexId});

  final String id;

  final String? action;

  final String? account;

  final String? documentNumber;

  final String? seqNo;

  final String? branchCode;

  final String? omnidexId;

  @override
  String toString() {
    return 'DetailRouteArgs{id: $id, action: $action, account: $account, documentNumber: $documentNumber, seqNo: $seqNo, branchCode: $branchCode, omnidexId: $omnidexId}';
  }
}

/// generated route for
/// [_i5.LoansPage]
class LoansRoute extends _i2.PageRouteInfo<void> {
  const LoansRoute() : super(LoansRoute.name, path: '');

  static const String name = 'LoansRoute';
}

/// generated route for
/// [_i6.ReservationPage]
class ReservationRoute extends _i2.PageRouteInfo<void> {
  const ReservationRoute() : super(ReservationRoute.name, path: '');

  static const String name = 'ReservationRoute';
}

/// generated route for
/// [_i7.AccountPage]
class AccountRoute extends _i2.PageRouteInfo<void> {
  const AccountRoute() : super(AccountRoute.name, path: '');

  static const String name = 'AccountRoute';
}

/// generated route for
/// [_i8.AboutPage]
class AboutRoute extends _i2.PageRouteInfo<void> {
  const AboutRoute() : super(AboutRoute.name, path: 'about');

  static const String name = 'AboutRoute';
}
