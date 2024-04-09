import 'package:flutter/material.dart';
import '../models/Stock.dart';
import '../network/StockService.dart';

class StockProvider extends ChangeNotifier {
  List<Stock> _stocks = [];
  bool _isLoading = false;
  List<Stock> get stocks => _stocks;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadStocks() async {
    try {
      await Future.delayed(Duration(seconds: 2));
      List<Stock> loadedStocks = await StockService.getStocks();
      _stocks = loadedStocks;
      notifyListeners();
    } catch (error) {
      print('Error loading stocks: $error');
      // Throw exception to indicate failure
      throw Exception('Failed to load stocks');
    }
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}