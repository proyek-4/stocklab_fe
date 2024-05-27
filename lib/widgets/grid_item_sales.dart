import 'package:flutter/material.dart';
import 'package:stocklab_fe/colors.dart';
import '../models/Stock.dart';
import 'bottom_sheet_modal.dart';

class SalesItem extends StatefulWidget {
  final Stock stock;
  final ValueChanged<int> onQuantityChanged;

  const SalesItem({required this.stock, required this.onQuantityChanged});

  @override
  _SalesItemState createState() => _SalesItemState();
}

class _SalesItemState extends State<SalesItem> {
  int selectedQuantity = 0;

  @override
  void initState() {
    super.initState();
    selectedQuantity = widget.stock.selectedQuantity;
  }

  void _increaseQuantity() {
    setState(() {
      selectedQuantity++;
      widget.onQuantityChanged(selectedQuantity);
    });
  }

  void _decreaseQuantity() {
    if (selectedQuantity > 0) {
      setState(() {
        selectedQuantity--;
        widget.onQuantityChanged(selectedQuantity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return BottomSheetModal(stock: widget.stock);
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
          padding: EdgeInsets.all(10),
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
                        widget.stock.name.length > 20
                            ? '${widget.stock.name.substring(0, 20)}...'
                            : widget.stock.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        'Stok : ${widget.stock.quantity}',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: primary),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        iconSize: 16,
                        icon: Icon(Icons.remove, color: primary),
                        onPressed: _decreaseQuantity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '$selectedQuantity',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: primary),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        iconSize: 16,
                        icon: Icon(Icons.add, color: primary),
                        onPressed: _increaseQuantity,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
