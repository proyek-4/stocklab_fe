import 'package:flutter/material.dart';
import '../colors.dart';
import '../models/Stock.dart';
import '../network/StockService.dart';
import '../widgets/grid_item_stock.dart';
import 'stock/add_stock_page.dart';
import '../provider/StockProvider.dart';

class StockPage extends StatefulWidget {
  StockPage() : super();

  final String title = "Stok Gudang";

  @override
  DataStockState createState() => DataStockState();
}

class DataStockState extends State<StockPage> {
  List<Stock> _stocks = [];
  late Stock _selectedStock;
  late bool _isUpdating;
  late String _titleProgress;
  var height, width;

  @override
  void initState() {
    super.initState();
    _isUpdating = false;
    _titleProgress = widget.title;
    _getStocks();
  }

  String selectedFilter = 'Semua';
  String selectedSort = 'A-Z';

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _getStocks() {
    _showProgress('Memuat Stok...');
    StockService.getStocks().then((stocks) {
      setState(() {
        _stocks = stocks;
      });
      _showProgress(widget.title);
    }).catchError((error) {
      print('Error fetching stocks: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch stocks. Please try again later.'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_titleProgress),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: StockSearch(),
                );
              },
            icon: Visibility(
              visible: !_stocks.isEmpty,
              child: const Icon(Icons.search),
            ),
          ),
          IconButton(
              onPressed: () async {
                // await showFilterSortDialog(context);
              },
            icon: Visibility(
              visible: !_stocks.isEmpty,
              child: const Icon(Icons.filter_list),
            ),
          ),
        ],
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: !_stocks.isEmpty,
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      onChanged: (value) {
                        setState(() {
                          selectedFilter = value!;
                        });
                      },
                      items: ['Semua', 'Filter 1', 'Filter 2', 'Filter 3']
                          .map<DropdownMenuItem<String>>((String value) {
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
                    visible: !_stocks.isEmpty,
                    child: DropdownButton<String>(
                      value: selectedSort,
                      onChanged: (value) {
                        setState(() {
                          selectedSort = value!;
                        });
                      },
                      items: ['A-Z', 'Z-A']
                          .map<DropdownMenuItem<String>>((String value) {
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

            //item list
            _stocks.isEmpty
                ? Column(
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
                  )
                : Container(
                    height: height,
                    width: width,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 3.1,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _stocks.length,
                      itemBuilder: (context, index) {
                        final stock = _stocks[index];
                        return StockItem(stock: stock);
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        tooltip: 'Add',
        onPressed: (){
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

class StockSearch extends SearchDelegate {
  List<String> searchTerms = [
    'Accu',
    'Oli',
    'Radiator',
  ];

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
    List<String> matchQuery = [];
    for (var item in searchTerms) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in searchTerms) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
