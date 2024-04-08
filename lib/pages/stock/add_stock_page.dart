import 'package:flutter/material.dart';
import '../../colors.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import '../../widgets/date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../widgets/alert_image.dart';
import '../../widgets/error_dialog.dart';
import '../../helper/upload_image.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import '../../utils.dart';

class AddStockPage extends StatefulWidget {
  AddStockPage() : super();

  @override
  _AddStockPageState createState() => _AddStockPageState();

  final String title = "Tambah Stok Gudang";
}

class _AddStockPageState extends State<AddStockPage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  late String _titleProgress;

  File? _image;
  final ImagePicker picker = ImagePicker();

  Future<void> getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      _image = img != null ? File(img.path) : null;
    });
  }

  _addStock() async {
    _showProgress('Menyimpan stok...');

    try {
      String? imageUrl;
      if (_image != null) {
        imageUrl = await uploadImage(_image!);
        if (imageUrl == null) {
          throw Exception('Gagal mengunggah gambar.');
        }
      }

      var uri = Uri.parse(url + '/api/stocks');
      var response = await http.post(
        uri,
        body: {
          'name': _nameController.text,
          'price': _priceController.text,
          'quantity': _quantityController.text,
          'description': _descriptionController.text,
          'date': _dateController.text,
        },
      );

      if (response.statusCode == 200) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Stok berhasil ditambah.",
        );
        Navigator.pop(context);
      } else {
        print('Failed to add stock: ${response.body}');
        showErrorDialog(context,
            'Failed to add stock. ${response.body}. Please try again.');
      }
    } catch (e) {
      print('Error adding stock: $e');
      showErrorDialog(context, 'Failed to add stock. $e. Please try again.');
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
        title: Text('Tambah Stok Gudang'),
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
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: 'Nama',
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
                      cursorColor: Colors.black,
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
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _quantityController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Stok',
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
                      controller: _descriptionController,
                      cursorColor: Colors.black,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          _image != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
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
                                final pickedImage = await ImagePicker()
                                    .pickImage(source: source);
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
                            _addStock();
                          }
                        },
                        child: Text('Tambah'),
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
