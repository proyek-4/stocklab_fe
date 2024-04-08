import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> selectDate(BuildContext context, TextEditingController dateController) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
  if (picked != null) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
    dateController.text = formattedDate;
  }
}