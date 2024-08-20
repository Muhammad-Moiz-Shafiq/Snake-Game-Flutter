import 'package:flutter/material.dart';
import 'dart:async';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List snakePosition = [5, 15, 25];
  int foodPosition = 58;
  final gridColumns = 10;
  final gridPixels = 100;
  void startGame() {
    // setState(() {
    //   Timer(Duration(milliseconds: 200), () {
    //     snakePosition.removeAt(0);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Column(
          children: [
            //Score tracker
            Expanded(
              child: Container(
                  //color: Colors.blueGrey,
                  ),
            ),
            //main board
            Expanded(
              flex: 3,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: gridPixels,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridColumns),
                itemBuilder: (build, index) {
                  if (snakePosition.contains(index))
                    return BoardTile(
                      Colors.white,
                    );
                  else if (foodPosition == index)
                    return BoardTile(Colors.green);
                  else
                    return BoardTile(Colors.grey[900]!);
                },
              ),
            ),
            // play button and credits
            Expanded(
              child: Container(
                child: Center(
                  child: MaterialButton(
                    onPressed: startGame,
                    color: Colors.blueGrey,
                    child: Text(
                      'Start',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoardTile extends StatelessWidget {
  BoardTile(this.tileColor);
  final Color tileColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
