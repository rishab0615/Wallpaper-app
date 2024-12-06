import 'package:flutter/material.dart';

class Customappbar extends StatelessWidget {
  String word1;
  String word2;
  Customappbar({super.key,
    required this.word1,
    required this.word2
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: word1,
                style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w600)),
            TextSpan(
                text: word2, style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.w600)),
          ])),
    );
  }
}