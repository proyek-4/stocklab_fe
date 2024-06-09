import 'package:flutter/material.dart';
import 'package:stocklab_fe/widgets/filter_stock.dart';
import 'package:stocklab_fe/widgets/stock_search.dart';
import '../colors.dart';
import '../models/Stock.dart';
import '../widgets/grid_item_sales.dart';
import '../utils.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../provider/StockProvider.dart';
import 'package:quickalert/quickalert.dart';
import 'dart:convert';

class RestockPage extends StatefulWidget {
  RestockPage() : super();

  final String title = "Stok Ulang";

  @override
  DataStockState createState() => DataStockState();
}

class DataStockState extends State<RestockPage> {
  List<Stock> _stocks = [];
  late String _titleProgress;
  var height, width;
  late StockProvider _stockProvider;
  late FilterStocks _stockFilter;

  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _stockFilter = FilterStocks();
    Future.microtask(() {
      _stockProvider = Provider.of<StockProvider>(context, listen: false);
      _stockProvider.loadStocks();
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
                Text('Apakah Anda yakin ingin menyimpan data stok ulang?'),
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
                _updateStock();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateStock() async {
    for (Stock stock in _stocks.where((s) => s.selectedQuantity > 0)) {
      var uri = url + '/api/records';
      var response = await http.post(
        Uri.parse(uri),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'stock_id': stock.id,
          'quantity': stock.selectedQuantity,
          'date': DateTime.now().toIso8601String(),
          'record_type': 'in',
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to submit data');
      }
    }
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: "Data stok ulang berhasil disimpan.",
    );
    Provider.of<StockProvider>(context, listen: false).loadStocks();
  }

  Future<void> _refreshStocks() async {
    await _stockProvider.loadStocks();
  }

  bool hasInputQuantities() {
    return _stocks.any((stock) => stock.selectedQuantity > 0);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_titleProgress),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _stockFilter.isSearch
                ? setState(() {
                    _stockFilter.isSearch = false;
                  })
                : Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: StockSearch(
                  Provider.of<StockProvider>(context, listen: false),
                ),
              ).then((query) {
                if (query != null) {
                  setState(() {
                    _stockFilter.searchQuery = query;
                    _stocks = _stockFilter.filterStocks(
                        Provider.of<StockProvider>(context, listen: false)
                            .stocks);
                    _stockFilter.isSearch = true;
                  });
                }
              });
            },
            icon: Visibility(
              // visible: !_stocks.isEmpty,
              child: const Icon(Icons.search),
            ),
            padding: EdgeInsets.only(right: 16),
          ),
        ],
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshStocks,
        child: Consumer<StockProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              _stocks = _stockFilter.filterStocks(provider.stocks);
              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Visibility(
                                    visible: !provider.stocks.isEmpty,
                                    child: DropdownButton<String>(
                                      value: _stockFilter.selectedFilter,
                                      onChanged: (value) {
                                        setState(() {
                                          _stockFilter.selectedFilter = value!;
                                        });
                                      },
                                      items: [
                                        'Nama',
                                        'Quantity',
                                        'Harga Modal',
                                        'Harga Jual',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Visibility(
                                    visible: !provider.stocks.isEmpty,
                                    child: DropdownButton<String>(
                                      value: _stockFilter.selectedSort,
                                      onChanged: (value) {
                                        setState(() {
                                          _stockFilter.selectedSort = value!;
                                        });
                                      },
                                      items: ['Ascending', 'Descending']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: 30),
                    sliver: provider.stocks.isEmpty
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
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 4.3,
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 1,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final stock = _stocks[index];
                                return SalesItem(
                                  stock: stock,
                                  onQuantityChanged: (int newQuantity) {
                                    setState(() {
                                      stock.selectedQuantity = newQuantity;
                                    });
                                  },
                                );
                              },
                              childCount: _stockFilter.isSearch
                                  ? _stocks.length
                                  : provider.stocks.length,
                            ),
                          ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: hasInputQuantities()
          ? FloatingActionButton(
              backgroundColor: primary,
              tooltip: 'Kirim',
              onPressed: () {
                _showConfirmationDialog(context);
              },
              child: const Icon(Icons.arrow_right_alt,
                  color: Colors.white, size: 28),
            )
          : null,
    );
  }
}
