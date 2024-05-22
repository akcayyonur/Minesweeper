import 'package:flutter/material.dart';
import 'package:minesweeper/main_page.dart';
import 'difficulty_screen.dart';

void main() {
  runApp(AnaUygulama());

}
class AnaUygulama extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: mainPage(),
    );
  }
}

