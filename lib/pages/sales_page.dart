import 'package:flutter/material.dart';
import '../colors.dart';
import '../models/Stock.dart';
import '../widgets/grid_item_sales.dart';
import 'sales/sales_detail_page.dart';
import 'package:provider/provider.dart';
import '../provider/StockProvider.dart';

class SalesPage extends StatefulWidget {
  SalesPage() : super();

  final String title = "Penjualan";

  @override
  DataStockState createState() => DataStockState();
}

class DataStockState extends State<SalesPage> {
  List<Stock> _stocks = [];
  late String _titleProgress;
  var height, width;
  late StockProvider _stockProvider;

  String selectedSort = 'A-Z';

  void sortStocks(List<Stock> stocks) {
    if (selectedSort == 'A-Z') {
      stocks.sort((a, b) => a.name.compareTo(b.name));
    } else {
      stocks.sort((a, b) => b.name.compareTo(a.name));
    }
  }

  bool isSearch = false;

  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    Future.microtask(() {
      Provider.of<StockProvider>(context, listen: false).loadStocks();
    });
  }

  void _showQuantityAlert(List<Stock> stocks) {
    final List<String> messages = [];

    for (final stock in stocks) {
      if (stock.selectedQuantity > stock.quantity) {
        messages.add('Kuantitas untuk barang ${stock.name} tidak mencukupi. '
            'Anda memilih ${stock.selectedQuantity} tetapi stok hanya '
            '${stock.quantity}.');
      }
    }

    final String alertMessage = messages.join('\n\n');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kuantitas Tidak Cukup'),
          content: Text(alertMessage),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _checkQuantities() {
    final List<Stock> overQuantityStocks = _stocks.where((stock) => stock.selectedQuantity > stock.quantity).toList();

    if (overQuantityStocks.isNotEmpty) {
      _showQuantityAlert(overQuantityStocks);
    } else {
      final List<Stock> selectedStocks = _stocks.where((stock) => stock.selectedQuantity > 0).toList();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SalesDetailPage(selectedStocks: selectedStocks)),
      );
    }
  }


  String selectedFilter = 'Semua';
  // String selectedSort = 'A-Z';

  Future<void> _refreshStocks() async {
    await _stockProvider.loadStocks();
  }

  List<Stock> _filterStocks(String query, StockProvider provider) {
    return provider.stocks
        .where(
            (stock) => stock.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
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
            isSearch
                ? setState(() {
              isSearch = false;
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
                  filterStocks: _filterStocks,
                ),
              ).then((query) {
                if (query != null) {
                  setState(() {
                    _stocks = _filterStocks(query,
                        Provider.of<StockProvider>(context, listen: false));
                    isSearch = true;
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
              _stocks = provider.stocks;
              sortStocks(provider.stocks);
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
                                      value: selectedFilter,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedFilter = value!;
                                        });
                                      },
                                      items: [
                                        'Semua',
                                        'Filter 1',
                                        'Filter 2',
                                        'Filter 3'
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
                                      value: selectedSort,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedSort = value!;
                                        });
                                      },
                                      items: ['A-Z', 'Z-A']
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 4.3,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          final stock = isSearch
                              ? _stocks[index]
                              : provider.stocks[index];
                          return SalesItem(
                            stock: stock,
                            onQuantityChanged: (int newQuantity) {
                              setState(() {
                                stock.selectedQuantity = newQuantity;
                              });
                            },
                          );
                        },
                        childCount:
                        isSearch ? _stocks.length : provider.stocks.length,
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
          onPressed: _checkQuantities,
          child: const Icon(Icons.arrow_right_alt, color: Colors.white, size: 28),
        )
      : null,
    );
  }
}

class StockSearch extends SearchDelegate {
  final StockProvider provider;
  final List<Stock> Function(String, StockProvider) filterStocks;

  // StockSearch(this.provider);
  StockSearch(this.provider, {required this.filterStocks});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Stock> filteredStocks =
    query.isEmpty ? [] : filterStocks(query.toLowerCase(), provider);

    return ListView.builder(
      itemCount: filteredStocks.length,
      itemBuilder: (context, index) {
        final Stock result = filteredStocks[index];
        return ListTile(
          title: Text(result.name),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Stock> filteredStocks =
    query.isEmpty ? [] : filterStocks(query.toLowerCase(), provider);

    return ListView.builder(
      itemCount: filteredStocks.length,
      itemBuilder: (context, index) {
        final Stock result = filteredStocks[index];
        return ListTile(
            title: Text(result.name),
            onTap: () {
              close(context, result.name);
            });
      },
    );
  }

  @override
  void showResults(BuildContext context) {
    Navigator.pop(context, query);
  }
}
