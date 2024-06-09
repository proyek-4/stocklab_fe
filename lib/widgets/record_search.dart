// lib/utils/record_search.dart

import 'package:flutter/material.dart';
import 'package:stocklab_fe/provider/RecordProvider.dart';
import '../models/Record.dart'; // Ensure you have this import for Record model

class RecordSearch extends SearchDelegate {
  final RecordProvider provider;

  RecordSearch(this.provider);

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
    final List<Record> filteredRecords = query.isEmpty
        ? []
        : provider.records
            .where((record) =>
                record.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        final Record result = filteredRecords[index];
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
  Widget buildSuggestions(BuildContext context) {
    final List<Record> filteredRecords = query.isEmpty
        ? []
        : provider.records
            .where((record) =>
                record.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        final Record result = filteredRecords[index];
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
