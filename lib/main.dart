import 'package:biblionantes/bloc/library_card/library_card_bloc.dart';
import 'package:biblionantes/repositories/account_repository.dart';
import 'package:biblionantes/repositories/search.dart';
import 'package:biblionantes/router.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(BiblioNantesApp());
}

BaseOptions options = BaseOptions(
  baseUrl: "https://catalogue-bm.nantes.fr/in/rest/api/",
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(options);

class BiblioNantesApp extends StatelessWidget {
  final _appRouter = AppRouter();

  BiblioNantesApp({Key? key}) : super(key: key) {
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: false,
        responseBody: false,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
              create: (context) => LibraryCardRepository(client: dio)),
          RepositoryProvider(
              create: (context) => SearchRepository(client: dio)),
        ],
        child: BlocProvider(
            create: (context) =>
                LibraryCardBloc(accountRepository: context.read())
                  ..add(LoadLibraryCardEvent()),
            lazy: false,
            child: MaterialApp.router(
              title: 'Biblio Nantes',
              theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
                // This makes the visual density adapt to the platform that you run
                // the app on. For desktop platforms, the controls will be smaller and
                // closer together (more dense) than on mobile platforms.
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              routerConfig: _appRouter.config(),
            )));
  }
}
