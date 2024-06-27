import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/provider/auth_provider.dart';
import 'package:wallet_app/provider/wallet_provider.dart';
import 'package:wallet_app/screens/login_screen.dart';
import 'package:wallet_app/screens/wallet_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, WalletProvider>(
          create: (_) => WalletProvider(),
          update: (context, auth, previousWallet) => WalletProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Wallet App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: LoginScreen(),
        ),
      ),
    );
  }
}
