import 'package:flutter/material.dart';

class DifficultyLevel {
  final String name;
  final int rows;
  final int columns;
  final int mineCount;

  DifficultyLevel(this.name, this.rows, this.columns, this.mineCount);
}

class DifficultyScreen extends StatelessWidget {
  final List<DifficultyLevel> levels = [
    DifficultyLevel('Easy', 9, 9, 10),
    DifficultyLevel('Medium', 16, 16, 40),
    DifficultyLevel('Hard', 16, 30, 99)
  ];

  void selectLevel(BuildContext context, DifficultyLevel level) {
    // Seçilen zorluk seviyesi ile ilgili işlemler burada yapılır
    print('Selected difficulty level: ${level.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Difficulty'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: levels.map((level) {
            return ElevatedButton(
              onPressed: () {
                selectLevel(context, level);
              },
              child: Text(
                level.name,
                style: TextStyle(fontSize: 18.0),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DifficultyScreen(),
  ));
}
