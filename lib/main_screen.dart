import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

enum SnakeDirection { UP, RIGHT, DOWN, LEFT }

class _MainScreenState extends State<MainScreen> {
  List snakePosition = [5, 15, 25];
  int foodPosition = 58;
  final gridColumns = 10;
  final gridPixels = 100;
  int currentScore = 0;
  var currentDirection = SnakeDirection.DOWN;

  void startGame() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();
//Game Over scenario
        if (gameOver()) {
          timer.cancel();

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Game Over'),
                  content: Text('Your Score is $currentScore'),
                );
              });
        }
      });
    });
  }

  void moveSnake() {
    switch (currentDirection) {
      case SnakeDirection.UP:
        if (snakePosition.last < gridColumns)
          //add a new head
          snakePosition.add(snakePosition.last - gridColumns + gridPixels);
        else
          snakePosition.add(snakePosition.last - gridColumns);
        break;
      case SnakeDirection.RIGHT:
        if (snakePosition.last % gridColumns == 9)
          //add a new head
          snakePosition.add(snakePosition.last + 1 - gridColumns);
        else
          snakePosition.add(snakePosition.last + 1);
        break;
      case SnakeDirection.DOWN:
        if (snakePosition.last + gridColumns > gridPixels)
          //add a new head
          snakePosition.add(snakePosition.last + gridColumns - gridPixels);
        else
          snakePosition.add(snakePosition.last + gridColumns);
        break;
      case SnakeDirection.LEFT:
        if (snakePosition.last % gridColumns == 0)
          //add a new head
          snakePosition.add(snakePosition.last - 1 + gridColumns);
        else
          snakePosition.add(snakePosition.last - 1);
        break;
    }
    if (snakePosition.last == foodPosition)
      eatFood();
    else
      snakePosition.removeAt(0); //removing the tail
  }

  void eatFood() {
    currentScore++;
    while (snakePosition.contains(foodPosition)) {
      foodPosition = Random().nextInt(gridPixels);
    }
  }

  bool gameOver() {
    //checking if head hits the body
    List snakeBody = snakePosition.sublist(0, snakePosition.length - 1);
    if (snakeBody.contains(snakePosition.last)) {
      return true;
    }
    return false;
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Your Score'),
                      Text(
                        '$currentScore',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  Text('High Scores...')
                ],
              ),
            ),
            //main board
            Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0 &&
                      currentDirection != SnakeDirection.UP)
                    currentDirection = SnakeDirection.DOWN;
                  else if (details.delta.dy < 0 &&
                      currentDirection != SnakeDirection.DOWN)
                    currentDirection = SnakeDirection.UP;
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0 &&
                      currentDirection != SnakeDirection.LEFT)
                    currentDirection = SnakeDirection.RIGHT;
                  else if (details.delta.dx < 0 &&
                      currentDirection != SnakeDirection.RIGHT)
                    currentDirection = SnakeDirection.LEFT;
                },
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
