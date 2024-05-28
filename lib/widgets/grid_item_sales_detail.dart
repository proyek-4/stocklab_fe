import 'package:flutter/material.dart';
import '../models/Stock.dart';
import '../utils.dart';
import '../colors.dart';

class SalesDetailItem extends StatefulWidget {
  final Stock stock;
  final ValueSetter<int>? onQuantityChanged;

  const SalesDetailItem({required this.stock, this.onQuantityChanged});

  @override
  _SalesDetailItemState createState() => _SalesDetailItemState();
}

class _SalesDetailItemState extends State<SalesDetailItem> {
  TextEditingController _costController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  int selectedQuantity = 0;
  double totalPrice = 0;
  double totalCost = 0;


  @override
  void initState() {
    super.initState();
    selectedQuantity = widget.stock.selectedQuantity;
    _costController = TextEditingController(text: widget.stock.cost.toString());
    _priceController = TextEditingController(text: widget.stock.price.toString());
    _priceController.addListener(_updateTotals);
    _costController.addListener(_updateTotals);
    _updateTotals();
  }

  @override
  void dispose() {
    _priceController.removeListener(_updateTotals);
    _costController.removeListener(_updateTotals);
    _costController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updateTotals() {
    setState(() {
      double price = double.tryParse(_priceController.text) ?? 0.0;
      double cost = double.tryParse(_costController.text) ?? 0.0;
      totalPrice = price * selectedQuantity;
      totalCost = cost * selectedQuantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Box for the item name
            Container(
              padding: EdgeInsets.only(
                bottom: 10,
                left: 10,
                right: 10,
                top: 7,
              ),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Text(
                widget.stock.name.length > 40
                    ? '${widget.stock.name.substring(0, 40)}...'
                    : widget.stock.name,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
            // Box for the details
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
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
                            padding: EdgeInsets.only(top: 0),
                            child: Text(
                              'Qty : $selectedQuantity',
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
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: 100,
                          child: TextField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              labelText: 'Debit',
                              hintText: 'Harga',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: 100,
                          child: TextField(
                            controller: _costController,
                            decoration: InputDecoration(
                              hintText: 'Biaya',
                              labelStyle: TextStyle(color: Colors.black),
                              labelText: 'Kredit',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: 10,
                left: 10,
                right: 10,
                top: 7,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Sub Total',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(width: 40),
                  Text(
                    formatPrice((totalPrice).toInt()),
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(width: 55),
                  Text(
                    formatPrice((totalCost).toInt()),
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
