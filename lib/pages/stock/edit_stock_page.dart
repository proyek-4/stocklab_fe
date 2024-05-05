import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import '../../provider/StockProvider.dart';
import '../../utils.dart';
import '../../widgets/date_picker.dart';
import '../../colors.dart';
import '../../models/Stock.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/alert_image.dart';


class EditStockPage extends StatefulWidget {
  final Stock stock;

  EditStockPage({required this.stock}) : super();

  @override
  _EditStockPageState createState() => _EditStockPageState();
}

class _EditStockPageState extends State<EditStockPage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  late String _titleProgress;

  File? _image;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.stock.name);
    _priceController = TextEditingController(text: widget.stock.price.toString());
    _quantityController = TextEditingController(text: widget.stock.quantity.toString());
    _descriptionController = TextEditingController(text: widget.stock.description);
    _dateController = TextEditingController(text: widget.stock.date);
    _titleProgress = "Edit Stok Gudang";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      _image = img != null ? File(img.path) : null;
    });
  }

  Future<void> _editStock() async {
    _showProgress('Memperbarui stok...');

    try {
      var uri = Uri.parse(url + '/api/stocks/update/${widget.stock.id}');
      var request = http.MultipartRequest('POST', uri);

      request.fields.addAll({
        'name': _nameController.text,
        'price': _priceController.text,
        'quantity': _quantityController.text,
        'description': _descriptionController.text,
        'date': _dateController.text,
      });

      if (_image != null) {
        var mimeType = 'image/jpeg';
        var multipartFile = await http.MultipartFile.fromPath(
          'image',
          _image!.path,
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Stok berhasil diperbarui.",
        );
        Provider.of<StockProvider>(context, listen: false).loadStocks();
        Navigator.pop(context);
      } else {
        print('Failed to update stock: ${response.statusCode}');
        showErrorDialog(
          context,
          'Failed to update stock. ${response.reasonPhrase}. Please try again.',
        );
      }
    } catch (e) {
      print('Error updating stock: $e');
      showErrorDialog(
        context,
        'Failed to update stock. $e. Please try again.',
      );
    }
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _clearValues() {
    _nameController.clear();
    _priceController.clear();
    _quantityController.clear();
    _descriptionController.clear();
    _dateController.clear();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      appBar: AppBar(
        title: Text('Edit Stok Gudang'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () {
                        selectDate(context, _dateController);
                      },
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: 'Tanggal',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            selectDate(context, _dateController);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kolom harus diisi!';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Barang',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kolom harus diisi!';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Harga',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kolom harus diisi!';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Harga harus berupa angka!';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Jumlah',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kolom harus diisi!';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Jumlah harus berupa angka!';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _descriptionController,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          _image != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(_image!.path),
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      height: 300,
                                    ),
                                  ),
                                )
                              : widget.stock.image != '/storage/stock/default.png'
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      url + widget.stock.image,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      height: 300,
                                    ),
                                  ),
                                )
                              : Text(
                                "Tidak ada gambar yang ditambahkan",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                          ElevatedButton(
                            onPressed: () async {
                              myAlert(context, (ImageSource source) async {
                                final pickedImage = await ImagePicker().pickImage(source: source);
                                if (pickedImage != null) {
                                  setState(() {
                                    _image = File(pickedImage.path);
                                  });
                                }
                              });
                            },
                            child: Text('Upload Gambar'),
                            style: ElevatedButton.styleFrom(
                              onPrimary: primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                            _editStock();
                          }
                        },
                        child: Text('Simpan'),
                        style: ElevatedButton.styleFrom(
                          primary: primary,
                          onPrimary: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
