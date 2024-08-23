import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'HighScoreTile.dart';
import 'board_tile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

enum SnakeDirection { UP, RIGHT, DOWN, LEFT }

class _MainScreenState extends State<MainScreen> {
  final gridColumns = 15;
  final gridPixels = 225;
  List snakePosition = [5, 20, 35];
  int foodPosition = 58;
  int currentScore = 0;
  var currentDirection = SnakeDirection.DOWN;
  bool isStarted = false;
  final _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> docsID = [];
  //late final Future getHSDocsIDs;
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    //getHSDocsIDs = getDocID();
    newGame();
    super.initState();
  }

  Future<List<String>> getDocID() async {
    List<String> ids = [];
    await FirebaseFirestore.instance
        .collection('highscores')
        .orderBy('score', descending: true)
        .limit(5)
        .get()
        .then((value) => value.docs.forEach((element) {
              ids.add(element.reference.id);
            }));
    return ids;
  }

  void startGame() {
    isStarted = true;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();
        //Game Over scenario
        if (gameOver()) {
          timer.cancel();

          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return AlertDialog(
                  title: Text('Game Over'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Your Score is $currentScore'),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        submitScore();
                        newGame();
                        Navigator.pop(context);
                      },
                      child: Text('Submit'),
                      color: Colors.green,
                    ),
                  ],
                );
              }).then((value) {
            newGame();
          });
        }
      });
    });
  }

  Future newGame() async {
    //reset the game state
    setState(() {
      //docsID = [];
      snakePosition = [5, 20, 35];
      foodPosition = 58;
      currentScore = 0;
      currentDirection = SnakeDirection.DOWN;
      isStarted = false;
    });
    docsID = await getDocID();
    setState(() {});
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
        if (snakePosition.last % gridColumns == gridColumns - 1)
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
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) {
          if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
              currentDirection != SnakeDirection.UP)
            currentDirection = SnakeDirection.DOWN;
          else if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
              currentDirection != SnakeDirection.DOWN)
            currentDirection = SnakeDirection.UP;
          else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
              currentDirection != SnakeDirection.RIGHT)
            currentDirection = SnakeDirection.LEFT;
          else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
              currentDirection != SnakeDirection.LEFT)
            currentDirection = SnakeDirection.RIGHT;
        },
        child: SizedBox(
          width: screenWidth > 430 ? 430 : screenWidth,
          //height: screenHeight > 968 ? 968 : screenHeight,
          child: Column(
            children: [
              //Score tracker
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Current Score'),
                          Text(
                            '$currentScore',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Highscores',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          isStarted
                              ? Container()
                              : Expanded(
                                  child: FutureBuilder(
                                    future: getDocID(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      return ListView.builder(
                                        itemCount: docsID.length,
                                        itemBuilder: (context, index) {
                                          return HighScoreTile(docsID[index]);
                                        },
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
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
                  child: AspectRatio(
                    aspectRatio: gridColumns /
                        (gridPixels /
                            gridColumns), // Aspect ratio based on grid dimensions
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: gridPixels,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridColumns),
                      itemBuilder: (build, index) {
                        if (snakePosition.contains(index))
                          return BoardTile(Colors.white);
                        else if (foodPosition == index)
                          return BoardTile(Colors.green);
                        else
                          return BoardTile(Colors.grey[900]!);
                      },
                    ),
                  ),
                ),
              ),
              // play button and credits
              Expanded(
                child: Container(
                  child: Center(
                    child: MaterialButton(
                      onPressed: isStarted ? () {} : startGame,
                      color: isStarted ? Colors.blueGrey : Colors.green,
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
      ),
    );
  }

  void submitScore() {
    //submit score to firebase
    var db = FirebaseFirestore.instance;
    db.collection('highscores').add({
      "name": _nameController.text,
      "score": currentScore,
    });
  }
}
