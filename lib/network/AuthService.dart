import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils.dart';
import '../models/Auth.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(
            url + '/api/login'), // Ganti dengan URL endpoint login API kamu
        body: {
          'email': email,
          'password': password,
        },
      );

      print('Login Response: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error logging in: $e');
      throw Exception('Failed to login');
    }
  }
}
