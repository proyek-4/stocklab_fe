import 'package:flutter/material.dart';
import '../models/Stock.dart';
import '../utils.dart';
import 'package:intl/intl.dart';
import 'image_loader.dart';

class BottomSheetModal extends StatelessWidget {
  final Stock stock;

  const BottomSheetModal({required this.stock});

  @override
  Widget build(BuildContext context) {
    String imageUrl = url + stock.image;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.5,
        maxChildSize: 0.8,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Center(
                      child: Container(
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                        imageUrl: imageUrl, stockId: stock.id),
                                  ),
                                );
                              },
                              child: Center(
                                child: Hero(
                                  tag: 'stock_image_${stock.id}',
                                  child: ImageLoader(
                                    imageUrl: imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              stock.name,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Harga Jual : ${formatPrice(stock.price)}',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Harga Modal : ${formatPrice(stock.cost)}',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Stok : ${stock.quantity}',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tanggal : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(stock.date))}',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Deskripsi : ${stock.description}',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String imageUrl;
  final int stockId;

  const DetailScreen({required this.imageUrl, required this.stockId});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'stock_image_$stockId',
            child: ImageLoader(
              imageUrl: imageUrl,
              width: screenSize.width,
              height: 1000,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
