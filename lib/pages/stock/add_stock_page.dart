import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../network/StockService.dart';

class AddStockPage extends StatefulWidget {
  AddStockPage() : super();

  @override
  _AddStockPageState createState() => _AddStockPageState();

  final String title = "Tambah Stok Gudang";
}

class _AddStockPageState extends State<AddStockPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  late String _titleProgress;

  _addStock() {
    if (_nameController.text
        .trim()
        .isEmpty ||
        _priceController.text
            .trim()
            .isEmpty ||
        _quantityController.text
            .trim()
            .isEmpty) {
      print("Empty fields");
      return;
    }

    _showProgress('Tambah Stok...');

    StockService.addStock(
      _nameController.text,
      int.parse(_priceController.text),
      int.parse(_quantityController.text),
      _descriptionController.text,
    ).then((result) {
      if (result) {
      }
      _clearValues();
    });
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _clearValues() {
    _nameController.clear();
    _priceController.clear();
    _quantityController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Stok Gudang'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _nameController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primary),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _priceController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primary),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _quantityController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primary),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _descriptionController,
                cursorColor: Colors.black,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primary),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addStock,
              child: Text('Tambah'),
              labelStyle: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
