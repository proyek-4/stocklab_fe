import '../models/Record.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils.dart';

class RecordService {

  static Future<List<Record>> getRecords() async {
    try {
      final response = await http.get(Uri.parse(url + '/api/records'));
      print('getRecords Response: ${response.body}');

      if (response.statusCode == 200) {
        List<Record> list = parseResponse(response.body);
        return list;
      } else {
        throw Exception('Failed to load records');
      }
    } catch (e) {
      print('Error fetching records: $e');
      throw Exception('Failed to load records');
    }
  }

  static List<Record> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody);
    if (parsed['data'] != null) {
      List<dynamic> data = parsed['data'];
      return data.map<Record>((json) => Record.fromJson(json)).toList();
    } else {
      throw Exception('Invalid response format');
    }
  }

}
