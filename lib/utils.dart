import 'package:intl/intl.dart';

String formatPrice(int price) {
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  return currencyFormat.format(price);
}

String url =
    'http://10.0.2.2:8000';
