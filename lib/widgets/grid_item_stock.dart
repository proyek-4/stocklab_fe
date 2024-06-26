import 'package:flutter/material.dart';
import 'package:stocklab_fe/pages/stock/edit_stock_page.dart';
import '../models/Stock.dart';
import 'package:flutter/widgets.dart';
import 'bottom_sheet_modal.dart';
import '../utils.dart';
import 'image_loader.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../provider/StockProvider.dart';

class StockItem extends StatelessWidget {
  final Stock stock;

  const StockItem({required this.stock});

  Future<void> _deleteStock(BuildContext context) async {
    try {
      final response = await http.delete(
        Uri.parse(url + '/api/stocks/${stock.id}'),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item berhasil dihapus'),
          ),
        );
        Provider.of<StockProvider>(context, listen: false).loadStocks();
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
    String imageUrl = url + stock.image;
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return BottomSheetModal(stock: stock);
          },
        );
      },
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
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: ImageLoader(
                  imageUrl: imageUrl,
                  width: 70,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        stock.name.length > 20
                            ? '${stock.name.substring(0, 20)}...'
                            : stock.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        formatPrice(stock.price),
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        'Stok : ${stock.quantity}',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditStockPage(stock: stock),
                      ),
                    );
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
                      _deleteStock(
                          context); // Panggil fungsi untuk menghapus item
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
