import 'package:flutter/material.dart';
import 'package:stocklab_fe/widgets/filter_stock.dart';
import 'package:stocklab_fe/widgets/stock_search.dart';
import '../colors.dart';
import '../models/Stock.dart';
import '../widgets/grid_item_stock.dart';
import 'stock/add_stock_page.dart';
import 'package:provider/provider.dart';
import '../provider/StockProvider.dart';

class StockPage extends StatefulWidget {
  StockPage() : super();

  final String title = "Daftar Barang";

  @override
  DataStockState createState() => DataStockState();
}

class DataStockState extends State<StockPage> {
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

  Future<void> _refreshStocks() async {
    await _stockProvider.loadStocks();
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
            icon: const Icon(Icons.search),
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
                                          _stocks = _stockFilter
                                              .filterStocks(provider.stocks);
                                        });
                                      },
                                      items: [
                                        'Nama',
                                        'Quantity',
                                        'Harga Modal',
                                        'Harga Jual',
                                        'Tanggal'
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
                                          _stocks = _stockFilter
                                              .filterStocks(provider.stocks);
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
                              childAspectRatio: 3.5,
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 1,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final stock = _stocks[index];
                                return StockItem(stock: stock);
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        tooltip: 'Add',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStockPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
