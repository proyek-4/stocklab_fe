import 'package:flutter/material.dart';
import '../../colors.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import '../../widgets/date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../widgets/alert_image.dart';
import '../../widgets/error_dialog.dart';
import 'package:http_parser/http_parser.dart';
import '../../utils.dart';
import 'package:provider/provider.dart';
import '../../provider/StockProvider.dart';

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
  TextEditingController _costController = TextEditingController();
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

  Future<void> _addStock() async {
    _showProgress('Menyimpan stok...');

    try {
      var uri = Uri.parse(url + '/api/stocks');
      var request = http.MultipartRequest('POST', uri);

      request.fields.addAll({
        'name': _nameController.text,
        'price': _priceController.text,
        'cost': _costController.text,
        'description': _descriptionController.text,
        'date': _dateController.text,
        'quantity' : '0',
        'warehouse_id' : '1',
      });

      if (_image != null) {
        int maxSizeInBytes = 3 * 1024 * 1024; // 3MB (bytes)
        if (_image!.lengthSync() <= maxSizeInBytes) {
          var mimeType = 'image/jpeg';
          var multipartFile = await http.MultipartFile.fromPath(
            'image',
            _image!.path,
            contentType: MediaType.parse(mimeType),
          );
          request.files.add(multipartFile);
        } else {
          showErrorDialog(
            context,
            'Image size exceeds limit (3MB). Please try again.',
          );
          return;
        }
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Stok berhasil ditambah.",
        );
        Provider.of<StockProvider>(context, listen: false).loadStocks();
        Navigator.pop(context);
      } else {
        print('Failed to add stock: ${response.statusCode}');
        showErrorDialog(
          context,
          'Failed to add stock. ${response.reasonPhrase}. Please try again. WOY',
        );
      }
    } catch (e) {
      print('Error adding stock: $e');
      showErrorDialog(
        context,
        'Failed to add stock. $e. Please try again.',
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
                        labelText: 'Harga Jual',
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
                      controller: _costController,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: 'Harga Modal',
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
                                  padding: const EdgeInsets.only(bottom: 20),
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
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child:Text(
                                    "Tidak ada gambar yang ditambahkan",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
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
