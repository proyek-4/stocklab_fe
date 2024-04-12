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
      isLoading =
          true; // Menandakan bahwa proses pengambilan data sedang berlangsung
      List<Stock> loadedStocks = await StockService.getStocks();
      // Memperbarui _stocks hanya jika data yang dimuat tidak kosong
      if (loadedStocks.isNotEmpty) {
        _stocks = loadedStocks;
      }
    } catch (error) {
      print('Error loading stocks: $error');
      // Throw exception to indicate failure
      throw Exception('Failed to load stocks');
    } finally {
      isLoading =
          false; // Memberitahu bahwa proses pengambilan data sudah selesai
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
