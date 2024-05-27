import 'package:intl/intl.dart';

String formatPrice(int price) {
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  return currencyFormat.format(price);
}

String url = 'https://73bb-2001-448a-3032-30a4-f96e-fc0e-52b7-472b.ngrok-free.app';
