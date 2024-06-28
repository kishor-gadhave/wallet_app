import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:wallet_app/screens/wallet_screen.dart';

import '../provider/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Wallet App", style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 45,
                fontWeight: FontWeight.bold
            ),),

            const SizedBox(height: 20,),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            const SizedBox(height: 10,),

            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),

            const SizedBox(height: 20),


            ElevatedButton(
              onPressed: () async {
                await Provider.of<AuthProvider>(context, listen: false).login(
                  _emailController.text,
                  _passwordController.text,
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => WalletScreen()),
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
