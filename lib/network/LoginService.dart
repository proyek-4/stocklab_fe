import 'package:flutter/material.dart';

class AuthService {
  Future<bool> login(String email, String password) async {
    // Di sini kamu bisa melakukan proses autentikasi,
    // misalnya dengan memanggil API login atau proses autentikasi lainnya.
    // Contoh sederhana, jika email dan password adalah 'admin', maka login berhasil.
    if (email == 'admin' && password == 'admin') {
      return true;
    } else {
      return false;
    }
  }
}
