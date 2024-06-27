import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  final String text;
  final IconData icon;


  const CustomWidget({super.key, required this.text, required this.icon,});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [CircleAvatar(
        radius:35 ,
        child: Icon(icon),),
        const SizedBox(width: 25),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}