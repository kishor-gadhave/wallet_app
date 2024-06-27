import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WalletProvider with ChangeNotifier {
  double _balance = 0.0;
  final String _baseUrl = 'https://api.socialverseapp.com';
  String? _token;

  WalletProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }

  double get balance => _balance;

  Future<void> fetchBalance(String network, String walletAddress) async {
    final url = Uri.parse('$_baseUrl/solana/wallet/balance?network=$network&wallet_address=$walletAddress');
    final response = await http.get(
      url,
      headers: {
        'Flic-Token': _token!,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _balance = responseData['balance'];
      notifyListeners();
    } else {
      throw Exception('Failed to fetch balance');
    }
  }

  Future<void> requestAirdrop(String network, String walletAddress, int amount) async {
    final url = Uri.parse('$_baseUrl/solana/wallet/airdrop');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Flic-Token': _token!,
      },
      body: json.encode({
        'wallet_address': walletAddress,
        'network': network,
        'amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      await fetchBalance(network, walletAddress);
    } else {
      throw Exception('Failed to request airdrop');
    }
  }

  Future<void> transferBalance(String network, String senderAddress, String receiverAddress, double amount) async {
    final url = Uri.parse('$_baseUrl/solana/wallet/transfer');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Flic-Token': _token!,
      },
      body: json.encode({
        'network': network,
        'sender_address': senderAddress,
        'receiver_address': receiverAddress,
        'amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      await fetchBalance(network, senderAddress);
    } else {
      throw Exception('Failed to transfer balance');
    }
  }
}
