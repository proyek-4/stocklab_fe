import 'package:flutter/material.dart';
import '../models/Stock.dart';

class StockProvider extends ChangeNotifier {
  List<Stock> _stocks = [];

  List<Stock> get stocks => _stocks;

  void addStock(Stock newStock) {
    _stocks.add(newStock);
    notifyListeners();
  }
}