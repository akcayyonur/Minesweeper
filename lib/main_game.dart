import 'package:flutter/material.dart';

enum Image {
  zero,
  one,
  two,
  three,
  four,
  bomb,
  facingDown,
  flagged,
}

class mainGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("game page", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text("where game should be at"),
      ),
    );
  }
}
