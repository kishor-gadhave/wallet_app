import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  final String text;
  final IconData icon;


  //this for making ui simple

  //creating customwidget for use anywhere in app
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