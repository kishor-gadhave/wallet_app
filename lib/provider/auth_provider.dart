import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider with ChangeNotifier {
  String? _token;
  String? _walletAddress;

  String? get token => _token;
  //String? get walletAddress => _walletAddress;

  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _loadTokenAndWalletAddress();
  }

  Future<void> _loadTokenAndWalletAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _walletAddress = prefs.getString('walletAddress');
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    String url = 'https://api.socialverseapp.com/user/login';

    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        "mixed": email,
        "password": password,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      _token = responseData['token'];
      _walletAddress = responseData['wallet_address'];

      // Store token and wallet address in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      await prefs.setString('walletAddress', _walletAddress!);
      notifyListeners();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logout() async {
    _token = null;
    _walletAddress = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('walletAddress');
    notifyListeners();
  }
}
