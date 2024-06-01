import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../models/Stock.dart';
import '../../widgets/grid_item_sales_detail.dart';
import '../../utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../provider/StockProvider.dart';
import 'package:quickalert/quickalert.dart';

class SalesDetailPage extends StatefulWidget {
  final List<Stock> selectedStocks;
  SalesDetailPage({required this.selectedStocks}) : super();
  final String title = "Detail Penjualan";

  @override
  DataStockState createState() => DataStockState();
}

class DataStockState extends State<SalesDetailPage> {
  late List<Stock> _stocks;
  late String _titleProgress;
  double totalDebit = 0;
  double totalKredit = 0;

  void calculateTotals() {
    totalDebit = _stocks.fold(0, (sum, stock) => sum + (double.tryParse(stock.price.toString()) ?? 0) * stock.selectedQuantity);
    totalKredit = _stocks.fold(0, (sum, stock) => sum + (double.tryParse(stock.cost.toString()) ?? 0) * stock.selectedQuantity);
  }

  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _stocks = widget.selectedStocks;
    calculateTotals();
  }

  void _updateTotal() {
    setState(() {
      calculateTotals();
    });
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda yakin ingin menyimpan data penjualan?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ya'),
              onPressed: () {
                Navigator.of(context).pop();
                _submitData();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitData() async {
    for (Stock stock in _stocks) {
      var uri = url + '/api/records';
      var response = await http.post(
        Uri.parse(uri),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'stock_id': stock.id,
          'quantity': stock.selectedQuantity,
          'date': DateTime.now().toIso8601String(),
          'record_type': 'out',
          'debit': stock.price * stock.selectedQuantity,
          'kredit': stock.cost * stock.selectedQuantity,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to submit data');
      }
    }
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: "Data penjualan berhasil disimpan.",
    );
    Provider.of<StockProvider>(context, listen: false).loadStocks();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_titleProgress),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(top: 15, bottom: 30),
                  sliver: _stocks.isEmpty
                      ? SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Image.asset(
                          "assets/icon/not_found_item.jpg",
                          width: 300,
                          height: 300,
                        ),
                        Text(
                          'Tidak ada data yang tersedia.',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  )
                      : SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 2.2,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        final stock = _stocks[index];
                        return SalesDetailItem(
                          stock: stock,
                          onQuantityChanged: (quantity) {
                            setState(() {
                              _stocks[index].selectedQuantity = quantity;
                              _updateTotal;
                            });
                          },
                        );
                      },
                      childCount: _stocks.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isKeyboardVisible)
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Total Debit: ${formatPrice(totalDebit.toInt())}',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Total Kredit: ${formatPrice(totalKredit.toInt())}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primary,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 16),
                      onPrimary: Colors.white,
                    ),
                    child: Text('Simpan'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
