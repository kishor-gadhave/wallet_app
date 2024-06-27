import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../provider/wallet_provider.dart';
import 'custom_widget.dart';

class WalletScreen extends StatelessWidget {
  final String network = 'devnet';


  final TextEditingController _receiverAddressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final walletProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Balance: \$${walletProvider.balance}',
                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            const SizedBox(height: 20),
            const Divider(thickness: 10,),
            const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                      onTap: () async {
                        await walletProvider.fetchBalance(network, );
                      },
                      child: const CustomWidget(
                        text: 'fetch balance',
                        icon: Icons.paypal_outlined,)
                  ),
                  const SizedBox(width: 40,),
                  GestureDetector(
                      onTap: () async {
                        await walletProvider.requestAirdrop(network,1);
                      },
                      child: const CustomWidget(
                        text: 'Airdrop',
                        icon: Icons.arrow_circle_down_outlined,)
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 10,),
              const SizedBox(height: 20),

              const Row(

                children: [CircleAvatar(
                  radius:35 ,
                  child: Icon(Icons.arrow_forward)
                  ,),SizedBox(width: 30,)
                  ,Text("transfer money",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)
                ],

              ),
              TextField(
                controller: _receiverAddressController,
                decoration: const InputDecoration(labelText: 'Receiver Address'),
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final receiverAddress = _receiverAddressController.text;
                  final amount = double.parse(_amountController.text);

                  await walletProvider.transferBalance(network, receiverAddress, amount);
                },
                child: const Text('Transfer Balance'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
