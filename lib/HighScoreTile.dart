import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HighScoreTile extends StatelessWidget {
  HighScoreTile(this.documentID);
  final documentID;
  @override
  Widget build(BuildContext context) {
    CollectionReference highscores =
        FirebaseFirestore.instance.collection('highscores');
    return FutureBuilder(
        future: highscores.doc(documentID).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Row(
                children: [
                  Text(data['score'].toString()),
                  SizedBox(
                    width: 15,
                  ),
                  Text(data['name']),
                ],
              );
            }
          } else {
            return Text('loading...');
          }
        });
  }
}
