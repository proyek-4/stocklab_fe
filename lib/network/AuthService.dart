// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils.dart';
// import '../models/Auth.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(url + '/api/login'),
        body: {
          'username_or_email': email,
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

  static Future<Map<String, dynamic>> register(String name, String username,
      String email, String password, String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse(url + '/api/register'),
        body: {
          'name': name,
          'email': email,
          'username': username,
          'password': password,
          'password_confirmation': confirmPassword,
        },
      );

      print('Register Response: ${response.body}');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('response') && data['response'] == 422) {
          throw Exception(data['message']);
        } else if (data.containsKey('success') && data['success'] == true) {
          return data;
        } else {
          throw Exception('Unknown error occurred');
        }
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      print('Error logging in: $e');
      throw Exception('Failed to register');
    }
  }
}
