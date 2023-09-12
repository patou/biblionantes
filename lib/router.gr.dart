// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AboutRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AboutPage(),
      );
    },
    AccountRoute.name: (routeData) {
      final args = routeData.argsAs<AccountRouteArgs>(
          orElse: () => const AccountRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AccountPage(key: args.key),
      );
    },
    AccountTab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountTabPage(),
      );
    },
    AppRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AppPage(),
      );
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
                omnidexId: queryParams.optString('omnidexId'),
              ));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DetailPage(
          id: args.id,
          action: args.action,
          account: args.account,
          documentNumber: args.documentNumber,
          seqNo: args.seqNo,
          branchCode: args.branchCode,
          omnidexId: args.omnidexId,
          key: args.key,
        ),
      );
    },
    LoansRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoansPage(),
      );
    },
    LoansTab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoansTabPage(),
      );
    },
    ReservationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ReservationPage(),
      );
    },
    ReservationTab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ReservationTabPage(),
      );
    },
    SearchListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SearchListPage(),
      );
    },
    SearchRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SearchPage(),
      );
    },
    SearchTab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SearchTabPage(),
      );
    },
    WebRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WebPage(),
      );
    },
  };
}

/// generated route for
/// [AboutPage]
class AboutRoute extends PageRouteInfo<void> {
  const AboutRoute({List<PageRouteInfo>? children})
      : super(
          AboutRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountPage]
class AccountRoute extends PageRouteInfo<AccountRouteArgs> {
  AccountRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          AccountRoute.name,
          args: AccountRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AccountRoute';

  static const PageInfo<AccountRouteArgs> page =
      PageInfo<AccountRouteArgs>(name);
}

class AccountRouteArgs {
  const AccountRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'AccountRouteArgs{key: $key}';
  }
}

/// generated route for
/// [AccountTabPage]
class AccountTab extends PageRouteInfo<void> {
  const AccountTab({List<PageRouteInfo>? children})
      : super(
          AccountTab.name,
          initialChildren: children,
        );

  static const String name = 'AccountTab';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AppPage]
class AppRoute extends PageRouteInfo<void> {
  const AppRoute({List<PageRouteInfo>? children})
      : super(
          AppRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DetailPage]
class DetailRoute extends PageRouteInfo<DetailRouteArgs> {
  DetailRoute({
    required String id,
    String? action,
    String? account,
    String? documentNumber,
    String? seqNo,
    String? branchCode,
    String? omnidexId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          DetailRoute.name,
          args: DetailRouteArgs(
            id: id,
            action: action,
            account: account,
            documentNumber: documentNumber,
            seqNo: seqNo,
            branchCode: branchCode,
            omnidexId: omnidexId,
            key: key,
          ),
          rawPathParams: {'id': id},
          rawQueryParams: {
            'action': action,
            'account': account,
            'documentNumber': documentNumber,
            'seqNo': seqNo,
            'branchCode': branchCode,
            'omnidexId': omnidexId,
          },
          initialChildren: children,
        );

  static const String name = 'DetailRoute';

  static const PageInfo<DetailRouteArgs> page = PageInfo<DetailRouteArgs>(name);
}

class DetailRouteArgs {
  const DetailRouteArgs({
    required this.id,
    this.action,
    this.account,
    this.documentNumber,
    this.seqNo,
    this.branchCode,
    this.omnidexId,
    this.key,
  });

  final String id;

  final String? action;

  final String? account;

  final String? documentNumber;

  final String? seqNo;

  final String? branchCode;

  final String? omnidexId;

  final Key? key;

  @override
  String toString() {
    return 'DetailRouteArgs{id: $id, action: $action, account: $account, documentNumber: $documentNumber, seqNo: $seqNo, branchCode: $branchCode, omnidexId: $omnidexId, key: $key}';
  }
}

/// generated route for
/// [LoansPage]
class LoansRoute extends PageRouteInfo<void> {
  const LoansRoute({List<PageRouteInfo>? children})
      : super(
          LoansRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoansRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoansTabPage]
class LoansTab extends PageRouteInfo<void> {
  const LoansTab({List<PageRouteInfo>? children})
      : super(
          LoansTab.name,
          initialChildren: children,
        );

  static const String name = 'LoansTab';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ReservationPage]
class ReservationRoute extends PageRouteInfo<void> {
  const ReservationRoute({List<PageRouteInfo>? children})
      : super(
          ReservationRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReservationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ReservationTabPage]
class ReservationTab extends PageRouteInfo<void> {
  const ReservationTab({List<PageRouteInfo>? children})
      : super(
          ReservationTab.name,
          initialChildren: children,
        );

  static const String name = 'ReservationTab';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SearchListPage]
class SearchListRoute extends PageRouteInfo<void> {
  const SearchListRoute({List<PageRouteInfo>? children})
      : super(
          SearchListRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SearchPage]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute({List<PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SearchTabPage]
class SearchTab extends PageRouteInfo<void> {
  const SearchTab({List<PageRouteInfo>? children})
      : super(
          SearchTab.name,
          initialChildren: children,
        );

  static const String name = 'SearchTab';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WebPage]
class WebRoute extends PageRouteInfo<void> {
  const WebRoute({List<PageRouteInfo>? children})
      : super(
          WebRoute.name,
          initialChildren: children,
        );

  static const String name = 'WebRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
