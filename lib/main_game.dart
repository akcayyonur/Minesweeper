import 'package:flutter/material.dart';

enum Imagee {
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
        backgroundColor: Colors.grey,
        automaticallyImplyLeading: false, // To prevent a default back button
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: _restartGame,
                icon: Image.asset(
                  "assets/smileyface.png",
                  width: 50,
                  height: 40,
                ),
                iconSize: 30,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: _goToSettings,
                icon: Icon(Icons.settings),
                iconSize: 30,
              ),
            ),
          ],
        ),
        toolbarHeight: 56.0,
      ),
      body: Center(
        child: Text("where game should be at"),
      ),
    );
  }

  void _restartGame() {
    // Add your restart game logic here
  }

  void _goToSettings() {
    // Action for the right button
  }
}
