import 'package:flutter/material.dart';
import '../colors.dart';
import '../models/Record.dart';
import '../widgets/grid_item_record.dart';
//import 'stock/add_stock_page.dart';
import 'package:provider/provider.dart';
import '../provider/RecordProvider.dart';

class RecordPage extends StatefulWidget {
  RecordPage() : super();

  final String title = "Riwayat";

  @override
  DataRecordState createState() => DataRecordState();
}

class DataRecordState extends State<RecordPage> {
  List<Record> _records = [];
  late String _titleProgress;
  var height, width;
  late RecordProvider _recordProvider;

  String selectedSort = 'A-Z';

  void sortRecords(List<Record> records) {
    if (selectedSort == 'A-Z') {
      records.sort((a, b) => a.name.compareTo(b.name));
    } else {
      records.sort((a, b) => b.name.compareTo(a.name));
    }
  }

  bool isSearch = false;

  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    Future.microtask(() {
      Provider.of<RecordProvider>(context, listen: false).loadRecords();
    });
  }

  String selectedFilter = 'Semua';
  // String selectedSort = 'A-Z';

  Future<void> _refreshRecords() async {
    await _recordProvider.loadRecords();
  }

  List<Record> _filterRecords(String query, RecordProvider provider) {
    return provider.records
        .where(
            (record) => record.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
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
                delegate: RecordSearch(
                  Provider.of<RecordProvider>(context, listen: false),
                  filterRecords: _filterRecords,
                ),
              ).then((query) {
                if (query != null) {
                  setState(() {
                    _records = _filterRecords(query,
                        Provider.of<RecordProvider>(context, listen: false));
                    isSearch = true;
                  });
                }
              });
            },
            icon: Visibility(
              // visible: !_records.isEmpty,
              child: const Icon(Icons.search),
            ),
            padding: EdgeInsets.only(right: 16),
          ),
        ],
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshRecords,
        child: Consumer<RecordProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              sortRecords(provider.records);
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
                                    visible: !provider.records.isEmpty,
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
                                    visible: !provider.records.isEmpty,
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
                    sliver: provider.records.isEmpty
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
                        childAspectRatio: 5.5,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          final record = isSearch
                              ? _records[index]
                              : provider.records[index];
                          return RecordItem(record: record);
                        },
                        childCount:
                        isSearch ? _records.length : provider.records.length,
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => AddStockPage()),
          // );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

class RecordSearch extends SearchDelegate {
  final RecordProvider provider;
  final List<Record> Function(String, RecordProvider) filterRecords;

  // RecordSearch(this.provider);
  RecordSearch(this.provider, {required this.filterRecords});
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
    final List<Record> filteredRecords =
    query.isEmpty ? [] : filterRecords(query.toLowerCase(), provider);

    return ListView.builder(
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        final Record result = filteredRecords[index];
        return ListTile(
          title: Text(result.name),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Record> filteredRecords =
    query.isEmpty ? [] : filterRecords(query.toLowerCase(), provider);

    return ListView.builder(
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        final Record result = filteredRecords[index];
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
