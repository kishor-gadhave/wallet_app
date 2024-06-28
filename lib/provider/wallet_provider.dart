import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WalletProvider with ChangeNotifier {
  double _balance = 0.0;
  final String _baseUrl = 'https://api.socialverseapp.com';
  String? _token;
  String? _walletAddress;

  WalletProvider() {
    _loadTokenAndWalletAddress();
  }

  //fetching token and wallet address from share-preference
  Future<void> _loadTokenAndWalletAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _walletAddress = prefs.getString('walletAddress');
    notifyListeners();
  }

  double get balance => _balance;
  String? get walletAddress => _walletAddress;

  //api call for fetching balance
  Future<void> fetchBalance(String network) async {
    if (_walletAddress == null) {
      throw Exception('Wallet address is not available');
    }

    final url = Uri.parse('$_baseUrl/solana/wallet/balance?network=$network&wallet_address=$_walletAddress');
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

  // request airdrop function
  Future<void> requestAirdrop(String network, int amount) async {
    if (_walletAddress == null) {
      throw Exception('Wallet address is not available');
    }

    final url = Uri.parse('$_baseUrl/solana/wallet/airdrop');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Flic-Token': _token!,
      },
      body: json.encode({
        'wallet_address': _walletAddress,
        'network': network,
        'amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      await fetchBalance(network);
    } else {
      throw Exception('Failed to request airdrop');
    }
  }

  //api call for transfer money
  Future<void> transferBalance(String network, String receiverAddress, double amount) async {
    if (_walletAddress == null) {
      throw Exception('Wallet address is not available');
    }

    final url = Uri.parse('$_baseUrl/solana/wallet/transfer');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Flic-Token': _token!,
      },
      body: json.encode({
        'network': network,
        'sender_address': _walletAddress,
        'receiver_address': receiverAddress,
        'amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      await fetchBalance(network);
    } else {
      throw Exception('Failed to transfer balance');
    }
  }
}
