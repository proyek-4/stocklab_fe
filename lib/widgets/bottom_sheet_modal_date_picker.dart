import 'package:flutter/material.dart';
import '../../widgets/date_picker.dart';
import '../../colors.dart';

class BottomSheetModalDatePicker extends StatefulWidget {
  final Function(String, String, int) onSelected;
  final int selectedMenu;

  const BottomSheetModalDatePicker({required this.onSelected, required this.selectedMenu, Key? key}) : super(key: key);

  @override
  _BottomSheetModalDatePickerState createState() => _BottomSheetModalDatePickerState();
}

class _BottomSheetModalDatePickerState extends State<BottomSheetModalDatePicker> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: TextFormField(
                                        controller: _startDateController,
                                        readOnly: true,
                                        onTap: () {
                                          selectDate(context, _startDateController);
                                        },
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          labelText: 'Tanggal Mulai',
                                          labelStyle: TextStyle(color: Colors.black),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: primary),
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.calendar_today),
                                            onPressed: () {
                                              selectDate(context, _startDateController);
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
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: TextFormField(
                                        controller: _endDateController,
                                        readOnly: true,
                                        onTap: () {
                                          selectDate(context, _endDateController);
                                        },
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          labelText: 'Tanggal Selesai',
                                          labelStyle: TextStyle(color: Colors.black),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: primary),
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.calendar_today),
                                            onPressed: () {
                                              selectDate(context, _endDateController);
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
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      widget.onSelected(
                                        _startDateController.text,
                                        _endDateController.text,
                                        widget.selectedMenu, // Use the selected menu from widget
                                      );
                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    onPrimary: Colors.white,
                                  ),
                                  child: Text('Pilih'),
                                ),
                              ),
                            ],
                          ),
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