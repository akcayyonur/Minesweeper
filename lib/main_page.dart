import 'package:flutter/material.dart';
import 'package:minesweeper/main_game.dart';

class mainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minesweeper" , style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            _startGame(context);
          },
          child: Text(
            "Start Game",
            style: TextStyle(fontSize: 20),
          ),
        ),
      )
    );
  }
  void _startGame(BuildContext context){
    MaterialPageRoute sayfaYolu = MaterialPageRoute(
      builder: (BuildContext context) {
        return mainGame();
      },
    );
    Navigator.push(context, sayfaYolu);
  }
}
