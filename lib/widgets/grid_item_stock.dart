import 'package:flutter/material.dart';
import '../models/Stock.dart';
import 'package:flutter/widgets.dart';
import 'bottom_sheet_modal.dart';
import '../utils.dart';
import 'image_loader.dart';

class StockItem extends StatelessWidget {
  final Stock stock;

  const StockItem({required this.stock});

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
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ImageLoader(
                imageUrl: imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
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
                          fontSize: 20,
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
            ],
          ),
        ),
      ),
    );
  }
}
