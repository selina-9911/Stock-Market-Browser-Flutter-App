import 'package:flutter/material.dart';
import 'package:hw4_stockbrowser/pages/home.dart';
import 'package:hw4_stockbrowser/pages/search.dart';
import 'package:hw4_stockbrowser/pages/stockinfo.dart';
import 'package:provider/provider.dart';
import 'package:hw4_stockbrowser/providers/favoriteList.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteList()),
      ],
    child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: Colors.black),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/search': (context) => Search(),
          '/stockinfo': (context) => Stockinfo(),
        }
    );
  }
}