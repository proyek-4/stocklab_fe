import 'package:flutter/material.dart';
import 'package:stocklab_fe/widgets/filter_record.dart';
import 'package:stocklab_fe/widgets/record_search.dart';
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
  late FilterRecords _recordsFilter;

  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _recordsFilter = FilterRecords();
    Future.microtask(() {
      Provider.of<RecordProvider>(context, listen: false).loadRecords();
    });
  }

  Future<void> _refreshRecords() async {
    await _recordProvider.loadRecords();
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
            _recordsFilter.isSearch
                ? setState(() {
                    _recordsFilter.isSearch = false;
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
                ),
              ).then((query) {
                if (query != null) {
                  setState(() {
                    _recordsFilter.searchQuery = query;
                    _records = _recordsFilter.filterRecords(
                        Provider.of<RecordProvider>(context, listen: false)
                            .records);
                    _recordsFilter.isSearch = true;
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
              _records = _recordsFilter.filterRecords(provider.records);
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
                                      value: _recordsFilter.selectedFilter,
                                      onChanged: (value) {
                                        setState(() {
                                          _recordsFilter.selectedFilter =
                                              value!;
                                        });
                                      },
                                      items: [
                                        'Nama',
                                        'Quantity',
                                        'Tipe',
                                        'Tanggal',
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
                                      value: _recordsFilter.selectedSort,
                                      onChanged: (value) {
                                        setState(() {
                                          _recordsFilter.selectedSort = value!;
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
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 5.5,
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 1,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final record = _records[index];
                                return RecordItem(record: record);
                              },
                              childCount: _recordsFilter.isSearch
                                  ? _records.length
                                  : provider.records.length,
                            ),
                          ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
