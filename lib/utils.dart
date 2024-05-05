import 'package:intl/intl.dart';

String formatPrice(int price) {
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  return currencyFormat.format(price);
}

String url =
    'https://7908-2001-448a-3032-30a4-de2c-8afa-4499-4d55.ngrok-free.app';
