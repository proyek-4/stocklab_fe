import '../models/Stock.dart';

class FilterStocks {
  String selectedSort;
  String selectedFilter;
  bool isSearch;
  String searchQuery;

  FilterStocks({
    this.selectedSort = 'Ascending',
    this.selectedFilter = 'Nama',
    this.isSearch = false,
    this.searchQuery = '',
  });

  List<Stock> filterStocks(List<Stock> stocks) {
    switch (selectedFilter) {
      case 'Nama':
        stocks.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Quantity':
        stocks.sort((a, b) => a.quantity.compareTo(b.quantity));
        break;
      case 'Harga Modal':
        stocks.sort((a, b) => a.cost.compareTo(b.cost));
        break;
      case 'Harga Jual':
        stocks.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Tanggal':
        stocks.sort((a, b) => a.date.compareTo(b.date));
        break;
      default:
        // Default case if 'Semua' or unknown filter
        break;
    }

    if (selectedSort == 'Descending') {
      stocks = stocks.reversed.toList();
    }

    if (isSearch) {
      return stocks
          .where((stock) =>
              stock.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return stocks;
  }
}
