import 'package:flutter/material.dart';
import 'package:minesweeper/board_square.dart';
import 'dart:math';

class mainGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        automaticallyImplyLeading: false, // To prevent a default back button
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  // Call the restart game method from the stateful widget
                  _mainGameState? gameState = context.findAncestorStateOfType<_mainGameState>();
                  gameState?._restartGame();
                },
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
                onPressed: () {
                  //call the settings method from stateful widget
                  _mainGameState? gameState = context.findAncestorStateOfType<_mainGameState>();
                  gameState?._goToSettings();
                },
                icon: Icon(Icons.settings),
                iconSize: 30,
              ),
            )
          ],
        ),
        toolbarHeight: 56.0,
      ),
      body: GameWidget(), // Add the stateful widget here
    );
  }
}

class GameWidget extends StatefulWidget {
  @override
  _mainGameState createState() => _mainGameState();
}

class _mainGameState extends State<GameWidget> {
  // Row and Column count
  int rowCount = 10;
  int columnCount = 10;

  // Grid of squares
  late List<List<BoardSquare>> board;

  // Clicked squares
  late List<bool> openedSquares;

  // Flagged squares
  late List<bool> flaggedSquares;

  // Probability of bomb creating
  int bombProb = 0;
  int maxProb = 15;

  int bombCount = 0;
  late int squaresLeft;

  @override
  void initState() {
    super.initState();
    _initialiseGame();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        // The grid of squares
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
          ),
          itemBuilder: (context, position) {
            // Get row and column number of square
            int rowNumber = (position / columnCount).floor();
            int columnNumber = (position % columnCount);

            Image image;

            if (!openedSquares[position]) {
              if (flaggedSquares[position]) {
                image = Image.asset('assets/flagged.png');
              } else {
                image = Image.asset('assets/facingDown.png');
              }
            } else {
              if (board[rowNumber][columnNumber].hasBomb) {
                image = Image.asset('assets/bomb.png');
              } else {
                image = Image.asset(
                  getImagePathFromNumber(
                      board[rowNumber][columnNumber].bombsAround),
                );
              }
            }

            return InkWell(
              // Opens square
              onTap: () {
                if (board[rowNumber][columnNumber].hasBomb) {
                  _handleGameOver();
                }
                if (board[rowNumber][columnNumber].bombsAround == 0) {
                  _handleTap(rowNumber, columnNumber);
                } else {
                  setState(() {
                    openedSquares[position] = true;
                    squaresLeft -= 1;
                  });
                }

                if (squaresLeft <= bombCount) {
                  _handleWin();
                }
              },
              // Flags square
              onLongPress: () {
                if (!openedSquares[position]) {
                  setState(() {
                    flaggedSquares[position] = !flaggedSquares[position];
                  });
                }
              },
              splashColor: Colors.grey,
              child: Container(
                color: Colors.grey,
                child: image,
              ),
            );
          },
          itemCount: rowCount * columnCount,
        ),
      ],
    );
  }

  void _restartGame() {
    _initialiseGame();
  }
  void _goToSettings(){

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
        if (i > 0 && j > 0 && board[i - 1][j - 1].hasBomb) board[i][j].bombsAround++;//top left
        if (i > 0 && board[i - 1][j].hasBomb) board[i][j].bombsAround++;//top
        if (i > 0 && j < columnCount - 1 && board[i - 1][j + 1].hasBomb) board[i][j].bombsAround++;//top right
        if (j > 0 && board[i][j - 1].hasBomb) board[i][j].bombsAround++;//left
        if (j < columnCount - 1 && board[i][j + 1].hasBomb) board[i][j].bombsAround++;//right
        if (i < rowCount - 1 && j > 0 && board[i + 1][j - 1].hasBomb) board[i][j].bombsAround++;//bottom left
        if (i < rowCount - 1 && board[i + 1][j].hasBomb) board[i][j].bombsAround++;//bottom
        if (i < rowCount - 1 && j < columnCount - 1 && board[i + 1][j + 1].hasBomb) board[i][j].bombsAround++;//bottom right
      }
    }

    setState(() {});
  }

  // This function opens other squares around the target square which don't have any bombs around them.
  // We use a recursive function which stops at squares which have a non-zero number of bombs around them.
  void _handleTap(int i, int j) {
    int position = (i * columnCount) + j;
    openedSquares[position] = true;
    squaresLeft -= 1;

    if (i > 0 && !board[i - 1][j].hasBomb && !openedSquares[((i - 1) * columnCount) + j]) {
      if (board[i][j].bombsAround == 0) _handleTap(i - 1, j);
    }

    if (j > 0 && !board[i][j - 1].hasBomb && !openedSquares[(i * columnCount) + j - 1]) {
      if (board[i][j].bombsAround == 0) _handleTap(i, j - 1);
    }

    if (j < columnCount - 1 && !board[i][j + 1].hasBomb && !openedSquares[(i * columnCount) + j + 1]) {
      if (board[i][j].bombsAround == 0) _handleTap(i, j + 1);
    }

    if (i < rowCount - 1 && !board[i + 1][j].hasBomb && !openedSquares[((i + 1) * columnCount) + j]) {
      if (board[i][j].bombsAround == 0) _handleTap(i + 1, j);
    }

    setState(() {});
  }

  // Function to handle when a bomb is clicked.
  void _handleGameOver() {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Center(child: Text("mayına tıklandı")),

        );
      }
    );
  }
  // Function to hande when the game is won
  void _handleWin() {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Center(child: Text("oyun kazanıldı")),
        );
      }
    );
  }

  String getImagePathFromNumber(int number) {
    switch (number) {
      case 0:
        return 'assets/0.png';
      case 1:
        return 'assets/1.png';
      case 2:
        return 'assets/2.png';
      case 3:
        return 'assets/3.png';
      case 4:
        return 'assets/4.png';
      default:
        return 'assets/default.png'; // A default case
    }
  }
}
