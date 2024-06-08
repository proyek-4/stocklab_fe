import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocklab_fe/colors.dart';
import 'stock_page.dart';
import 'package:stocklab_fe/provider/UserProvider.dart';
import 'record_page.dart';
import 'sales_page.dart';
import 'restock_page.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  var height, width;

  List imgData = [
    "assets/icon/stock.png",
    "assets/icon/history.png",
    "assets/icon/sales.png",
    "assets/icon/user.png",
  ];

  List<IconData> icons = [
    Icons.article, // Daftar Barang
    Icons.note_alt, // Pencatatan
    Icons.sell, // Penjualan
    Icons.add_business_outlined,
    Icons.book, // Modul Pembelajaran
  ];

  List titles = [
    "Daftar Barang",
    "Pencatatan",
    "Penjualan",
    "Stok Ulang",
    "Modul Pembelajaran",
  ];

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var userData = userProvider.userData;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: primary,
        height: height,
        width: width,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(),
              height: height * 0.25,
              width: width,
              child: Padding(
                padding: EdgeInsets.only(top: 40, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'StockLab',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 50),
                    userData != null
                        ? Text(
                            'Halo, ${userData['name']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  height: height * 0.75,
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50, left: 10, right: 10),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.3,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 0,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: titles.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                if (titles[index] == "Daftar Barang") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StockPage()),
                                  );
                                } else if (titles[index] == "Pencatatan") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecordPage()),
                                  );
                                } else if (titles[index] == "Penjualan") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SalesPage()),
                                  );
                                } else if (titles[index] == "Stok Ulang") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RestockPage()),
                                  );
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 1,
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        icons[index],
                                        size: 55,
                                        color: Colors
                                            .blue, // Ubah warna ikon sesuai keinginan Anda
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              titles[index],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    ),
                  )),
            )
          ],
        ),
      ),
    ));
  }
}
