import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../models/Stock.dart';
import '../../widgets/grid_item_sales_detail.dart';
import 'package:provider/provider.dart';
import '../../provider/StockProvider.dart';

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

  String selectedSort = 'A-Z';

  void sortStocks(List<Stock> stocks) {
    if (selectedSort == 'A-Z') {
      stocks.sort((a, b) => a.name.compareTo(b.name));
    } else {
      stocks.sort((a, b) => b.name.compareTo(a.name));
    }
  }

  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _stocks = widget.selectedStocks;
    sortStocks(_stocks);
  }

  Future<void> _refreshStocks() async {
    // Optionally, you can refresh the selected stocks if needed.
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
      body: RefreshIndicator(
        onRefresh: _refreshStocks,
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
                    );
                  },
                  childCount: _stocks.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
