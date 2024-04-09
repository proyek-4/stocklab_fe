import '../models/Stock.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils.dart';

class StockService {

  static Future<List<Stock>> getStocks() async {
    try {
      final response = await http.get(Uri.parse(url + '/api/stocks'));
      print('getStocks Response: ${response.body}');

      if (response.statusCode == 200) {
        List<Stock> list = parseResponse(response.body);
        return list;
      } else {
        throw Exception('Failed to load stocks');
      }
    } catch (e) {
      print('Error fetching stocks: $e');
      throw Exception('Failed to load stocks');
    }
  }

  static List<Stock> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody);
    if (parsed['data'] != null) {
      List<dynamic> data = parsed['data'];
      return data.map<Stock>((json) => Stock.fromJson(json)).toList();
    } else {
      throw Exception('Invalid response format');
    }
  }

}
