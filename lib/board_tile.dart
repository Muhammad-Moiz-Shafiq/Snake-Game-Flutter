import 'package:flutter/material.dart';

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
