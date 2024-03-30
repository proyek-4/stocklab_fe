import '../models/Stock.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StockService {
  static const ROOT = "http://10.0.2.2:8000/api/stocks";
  static const _ADD_ACTION = 'ADD';
  static const _UPDATE_ACTION = 'UPDATE';
  static const _DELETE_ACTION = 'DELETE';

  static Future<List<Stock>> getStocks() async {
    try {
      final response = await http.get(Uri.parse(ROOT));
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

  static Future<bool> addStock(String name, int price, int quantity, String description) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_ACTION;
      map['name'] = name;
      map['price'] = price;
      map['quantity'] = quantity;
      map['description'] = description;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('addEmployee Response: ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to store stocks');
      }
    } catch (e) {
      print('Error storing stocks: $e');
      throw Exception('Failed to store stocks');
    }
  }
}
