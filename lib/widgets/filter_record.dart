import '../models/Record.dart';

class FilterRecords {
  String selectedSort;
  String selectedFilter;
  bool isSearch;
  String searchQuery;

  FilterRecords({
    this.selectedSort = 'Descending',
    this.selectedFilter = 'Tanggal',
    this.isSearch = false,
    this.searchQuery = '',
  });

  List<Record> filterRecords(List<Record> records) {
    switch (selectedFilter) {
      case 'Nama':
        records.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Tipe':
        records.sort((a, b) => a.record_type.compareTo(b.record_type));
        break;
      case 'Tanggal':
        records.sort((a, b) => a.date.compareTo(b.date));
        break;
      default:
        // Default case if 'Semua' or unknown filter
        break;
    }

    if (selectedSort == 'Descending') {
      records = records.reversed.toList();
    }

    if (isSearch) {
      return records
          .where((record) =>
              record.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return records;
  }
}
