import 'package:flutter/material.dart';
import 'package:stocklab_fe/widgets/bottom_sheet_modal_date_picker.dart';
import '../colors.dart';
import '../models/Record.dart';
import '../widgets/grid_item_record.dart';
//import 'stock/add_stock_page.dart';
import 'package:provider/provider.dart';
import '../provider/RecordProvider.dart';

class RecapPage extends StatefulWidget {
  RecapPage() : super();

  final String title = "Rekapitulasi";

  @override
  DataRecordState createState() => DataRecordState();
}

class DataRecordState extends State<RecapPage> {
  late String _titleProgress;
  var height, width;
  late RecordProvider _recordProvider;

  List<String> titles = [
    'Rekapitulasi Penjualan',
    'Rekapitulasi Pembelian',
    'Rekapitulasi Penjualan dan Pembelian'
  ];

  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
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
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(titles[index]),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                      return BottomSheetModalDatePicker();
                    },
                  );
                }
                  // Handle navigation based on the index
                //   if (index == 0) {
                //     // Handle navigation to Rekapitulasi Penjualan
                //   } else if (index == 1) {
                //     // Handle navigation to Rekapitulasi Pembelian
                //   } else if (index == 2) {
                //     // Handle navigation to Rekapitulasi Penjualan dan Pembelian
                //   }
                // },
              ),
            ],
          );
        },
      ),
    );
  }
}
