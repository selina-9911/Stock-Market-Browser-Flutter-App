import 'package:flutter/material.dart';
import 'package:hw4_stockbrowser/objects/stocks.dart';

class FavoriteList with ChangeNotifier {
  List<Stock> _favoriteList = [];

  int get count => _favoriteList.length;
  List<Stock> get list => _favoriteList;

  void addStock(Stock s) {
    _favoriteList.add(s);
    notifyListeners();
  }

  void removeStock(Stock s) {
    _favoriteList.remove(s);
    notifyListeners();
  }
}