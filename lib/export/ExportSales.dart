import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/Record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class ExportPDF {
  Future<void> generatePDF(List<Record> records) async {
    final pdf = pw.Document();

    // Load the fonts
    final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/fonts/NotoSans-Bold.ttf');

    final font = pw.Font.ttf(fontData.buffer.asByteData());
    final fontBold = pw.Font.ttf(fontBoldData.buffer.asByteData());


    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Rekapitulasi Penjualan',
                style: pw.TextStyle(font: fontBold, fontSize: 24),
              ),
              pw.SizedBox(height: 20),
              ...records.map((record) {
                return pw.Text(
                  record.toString(),
                  style: pw.TextStyle(font: font, fontSize: 12),
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    final output = await getExternalStorageDirectory();
    final path = output?.path;

    if (path != null) {
      final file = File('$path/rekapitulasi_penjualan.pdf');
      await file.writeAsBytes(await pdf.save());
    } else {
      print('Error: Unable to access storage directory');
    }
  }
}