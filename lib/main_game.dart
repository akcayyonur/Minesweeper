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
  // Initializes all lists
  void _initialiseGame() {
    // Initialize all squares to having no bombs
    board = List.generate(rowCount, (i) {
      return List.generate(columnCount, (j) {
        return BoardSquare();
      });
    });

    // Initialize list to store which squares have been opened
    openedSquares = List.generate(rowCount * columnCount, (i) => false);

    flaggedSquares = List.generate(rowCount * columnCount, (i) => false);

    // Reset bomb count
    bombCount = 0;
    squaresLeft = rowCount * columnCount;

    // Randomly generate bombs
    Random random = Random();
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        int randomNumber = random.nextInt(maxProb);
        if (randomNumber < bombProb) {
          board[i][j].hasBomb = true;
          bombCount++;
        }
      }
    }
    // Check bombs around and assign numbers
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (i > 0 && j > 0 && board[i - 1][j - 1].hasBomb) board[i][j].bombsAround++;
        if (i > 0 && board[i - 1][j].hasBomb) board[i][j].bombsAround++;
        if (i > 0 && j < columnCount - 1 && board[i - 1][j + 1].hasBomb) board[i][j].bombsAround++;
        if (j > 0 && board[i][j - 1].hasBomb) board[i][j].bombsAround++;
        if (j < columnCount - 1 && board[i][j + 1].hasBomb) board[i][j].bombsAround++;
        if (i < rowCount - 1 && j > 0 && board[i + 1][j - 1].hasBomb) board[i][j].bombsAround++;
        if (i < rowCount - 1 && board[i + 1][j].hasBomb) board[i][j].bombsAround++;
        if (i < rowCount - 1 && j < columnCount - 1 && board[i + 1][j + 1].hasBomb) board[i][j].bombsAround++;
      }
    }

    setState(() {});
  }  
}
