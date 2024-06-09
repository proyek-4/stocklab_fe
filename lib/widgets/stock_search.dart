// lib/utils/stock_search.dart

import 'package:flutter/material.dart';
import '../models/Stock.dart';
import '../provider/StockProvider.dart';

class StockSearch extends SearchDelegate {
  final StockProvider provider;

  StockSearch(this.provider);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Stock> filteredStocks = query.isEmpty
        ? []
        : provider.stocks
            .where((stock) =>
                stock.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

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
    final List<Stock> filteredStocks = query.isEmpty
        ? []
        : provider.stocks
            .where((stock) =>
                stock.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: filteredStocks.length,
      itemBuilder: (context, index) {
        final Stock result = filteredStocks[index];
        return ListTile(
          title: Text(result.name),
          onTap: () {
            close(context, result.name);
          },
        );
      },
    );
  }

  @override
  void showResults(BuildContext context) {
    Navigator.pop(context, query);
  }
}
