import 'package:flutter/material.dart';
import 'package:stocklab_fe/widgets/bottom_sheet_modal_date_picker.dart';
import '../colors.dart';
import '../models/Record.dart';
import 'package:provider/provider.dart';
import '../provider/RecordProvider.dart';
import '../export/ExportSales.dart';

class RecapPage extends StatefulWidget {
  @override
  _RecapPageState createState() => _RecapPageState();
}

class _RecapPageState extends State<RecapPage> {
  late RecordProvider _recordProvider;
  int selectedMenu = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RecordProvider>(context, listen: false).loadRecords();
    });
  }

  void _onSelected(String startDate, String endDate, int selectedMenu) {
    List<Record> records = Provider.of<RecordProvider>(context, listen: false).records;

    if (selectedMenu == 1) {
      // Export Sales
      ExportPDF().generatePDF(records.where((record) => record.record_type == 'out').toList());
    // } else if (selectedMenu == 2) {
    //   // Export Restock
    //   ExportRestockPDF().generatePDF(records.where((record) => record.recordType == 'in').toList());
    // } else if (selectedMenu == 3) {
    //   // Export Sales and Restock
    //   ExportSalesAndRestockPDF().generatePDF(records);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Rekapitulasi Penjualan"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Rekapitulasi Penjualan"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              setState(() {
                selectedMenu = 1;
              });
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return BottomSheetModalDatePicker(onSelected: _onSelected, selectedMenu: selectedMenu);
                },
              );
            },
          ),
          ListTile(
            title: Text("Rekapitulasi Pembelian"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              setState(() {
                selectedMenu = 2;
              });
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return BottomSheetModalDatePicker(onSelected: _onSelected, selectedMenu: selectedMenu);
                },
              );
            },
          ),
          ListTile(
            title: Text("Rekapitulasi Penjualan dan Pembelian"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              setState(() {
                selectedMenu = 3;
              });
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return BottomSheetModalDatePicker(onSelected: _onSelected, selectedMenu: selectedMenu);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
