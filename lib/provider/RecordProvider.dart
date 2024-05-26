import 'package:flutter/material.dart';
import '../models/Record.dart';
import '../network/RecordService.dart';

class RecordProvider extends ChangeNotifier {
  List<Record> _records = [];
  bool _isLoading = false;
  List<Record> get records => _records;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadRecords() async {
    try {
      isLoading =
      true; // Menandakan bahwa proses pengambilan data sedang berlangsung
      List<Record> loadedRecords = await RecordService.getRecords();
      // Memperbarui _records hanya jika data yang dimuat tidak kosong
      if (loadedRecords.isNotEmpty) {
        _records = loadedRecords;
      }else{
        resetProvider();
      }
    } catch (error) {
      print('Error loading records: $error');
      // Throw exception to indicate failure
      throw Exception('Failed to load records');
    } finally {
      isLoading =
      false; // Memberitahu bahwa proses pengambilan data sudah selesai
    }
  }

  void resetProvider() {
    _records.clear();
    _isLoading = false;
    notifyListeners();
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
