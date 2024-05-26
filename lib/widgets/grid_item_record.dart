import 'package:flutter/material.dart';
//import 'package:stocklab_fe/pages/stock/edit_stock_page.dart';
import '../models/Record.dart';
import 'package:flutter/widgets.dart';
//import 'bottom_sheet_modal.dart';
import '../utils.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../provider/RecordProvider.dart';

class RecordItem extends StatelessWidget {
  final Record record;

  const RecordItem({required this.record});

  Future<void> _deleteRecord(BuildContext context) async {
    try {
      final response = await http.delete(
        Uri.parse(url + '/api/records/${record.id}'),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item berhasil dihapus'),
          ),
        );
        Provider.of<RecordProvider>(context, listen: false).loadRecords();
      } else {
        throw Exception('Gagal menghapus item');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus item: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 0.5,
              blurRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 15.0,
            top: 0.0,
            right: 0.0,
            bottom: 0.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        record.name.length > 20
                            ? '${record.name.substring(0, 20)}...'
                            : record.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        '${DateFormat('dd-MM-yyyy').format(DateTime.parse(record.date))}',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                  '${formatPrice((record.debit == 0 ? record.kredit : record.debit).toInt())}',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Icon(
                record.kredit == 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                color: record.kredit == 0 ? Colors.green : Colors.red,
                size: 24.0,
              ),
              // Tambahkan ikon titik tiga di pojok kanan atas
              PopupMenuButton<String>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Ubah'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Hapus'),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'edit') {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => EditStockPage(stock: stock),
                    //   ),
                    // );
                  } else if (value == 'delete') {
                    bool confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Konfirmasi Hapus'),
                          content: Text(
                              'Apakah Anda yakin ingin menghapus item ini?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false); // Batal
                              },
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                    context, true); // Konfirmasi Hapus
                              },
                              child: Text('Hapus'),
                            ),
                          ],
                        );
                      },
                    );

                    // Jika pengguna konfirmasi untuk menghapus
                    if (confirmDelete == true) {
                      // _deleteStock(
                      //     context); // Panggil fungsi untuk menghapus item
                    }
                  }
                },
                icon: Icon(Icons.more_vert), // Icon titik tiga
              ),
            ],
          ),
        ),
      ),
    );
  }
}
