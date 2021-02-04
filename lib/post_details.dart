import 'dart:math';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'utils/cached_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'participant_profile.dart';

class PostDetails extends StatefulWidget {
  final post;

  PostDetails(this.post);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  List<dynamic> participants;
  List<Widget> participantWidgets = [];
  String winnerName = "";
  String winnerUid;
  int winnerId;
  var winnerDoc;
  String person = '';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool taskOneShared = false;
  bool taskTwoShared = false;
  bool taskThreeShared = false;

  getParticipants() async {
    DocumentSnapshot document =
        await firestore.collection('post').doc(widget.post.documentName).get();
    participants = document['people'];

    for (int i = 0; i < participants.length; ++i) {
      DocumentSnapshot participant = await firestore
          .collection('users')
          .doc(participants[i].toString())
          .get();

      Widget participantWidget = Column(
        children: [
          InkWell(
            onTap: () {
              Future(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(participant)));
              });
            },
            child: Text(
              '${participant['name']}: ${participant['email']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      );

      setState(() {
        participantWidgets.add(participantWidget);
      });
      setState(() {
        doneLoadingParticipants = true;
      });
    }
  }

  generateWinner() async {
    var winnerIndex = Random().nextInt(participants.length);
    print(winnerIndex);
    winnerId = winnerIndex;
    DocumentSnapshot winnerParticipant = await firestore
        .collection('users')
        .doc(participants[winnerIndex].toString())
        .get();
    winnerUid = participants[winnerIndex].toString();
    var timestamp = FieldValue.serverTimestamp();
    final DocumentReference ref =
        firestore.collection('users/$winnerUid/notifications').doc();
    var docID = ref.id;
    var _postData = {
      'message': "Поздравляем! Вы победили в конкурсе!",
      'type': 1,
      'title': "Победа!",
      'is_Unread': true,
      'ts': timestamp,
    };
    await ref.set(_postData);

    if (widget.post.taskOneTypeShared.contains(winnerUid))
      setState(() {
        taskOneShared = true;
      });
    else
      setState(() {
        taskOneShared = false;
      });

    if (widget.post.taskTwoTypeShared.contains(winnerUid))
      setState(() {
        taskTwoShared = true;
      });
    else
      setState(() {
        taskTwoShared = false;
      });

    if (widget.post.taskThreeTypeShared.contains(winnerUid))
      setState(() {
        taskThreeShared = true;
      });
    else
      setState(() {
        taskThreeShared = false;
      });

    setState(() {
      winnerName =
          '${winnerParticipant['name']}: ${winnerParticipant['email']}';
    });
    return winnerParticipant;
  }

  @override
  void initState() {
    super.initState();
    if (widget.post.people.length == 0)
      setState(() {
        doneLoadingParticipants = true;
      });
    getParticipants();

    if (widget.post.taskOneTypeShared.contains(widget.post.winnerUid))
      setState(() {
        taskOneShared = true;
      });
    else
      setState(() {
        taskOneShared = false;
      });

    if (widget.post.taskTwoTypeShared.contains(widget.post.winnerUid))
      setState(() {
        taskTwoShared = true;
      });
    else
      setState(() {
        taskTwoShared = false;
      });

    if (widget.post.taskThreeTypeShared.contains(widget.post.winnerUid))
      setState(() {
        taskThreeShared = true;
      });
    else
      setState(() {
        taskThreeShared = false;
      });
  }

  bool doneLoadingParticipants = false;
  bool doneGeneratingTheWinner = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 350,
            //width: 600,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: CustomCacheImage(
              imageUrl: widget.post.prize,
              radius: 10,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Детали конкурса:',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Описание',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            widget.post.description,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Text(
                'Участники: ',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              doneLoadingParticipants
                  ? Container()
                  : SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator()),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          ParticipantsList(participantWidgets),
          Row(
            children: [
              Text(
                'Победитель: ',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              doneGeneratingTheWinner
                  ? Container()
                  : SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator()),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(winnerDoc)));
                },
                child: Text(
                  doneGeneratingTheWinner ? widget.post.winner : "",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text('Task 1: '),
                      taskOneShared
                          ? Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.dnd_forwardslash,
                              color: Colors.red,
                            ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Task 2: '),
                      taskTwoShared
                          ? Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.dnd_forwardslash,
                              color: Colors.red,
                            ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Task 3: '),
                      taskThreeShared
                          ? Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.dnd_forwardslash,
                              color: Colors.red,
                            ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
              color: Colors.deepPurpleAccent,
              height: 45,
              child: FlatButton(
                  child: Text(
                    'Сгенерировать победителя',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    setState(() {
                      doneGeneratingTheWinner = false;
                    });
                    winnerDoc = await generateWinner();
                    FirebaseFirestore.instance
                        .collection('post')
                        .doc(widget.post.documentName)
                        .update({
                      'winner': winnerDoc['name'],
                      'winnerId': winnerId,
                      'winnerUid': winnerUid
                    });
                    setState(
                      () {
                        widget.post.winner = winnerDoc['name'];
                      },
                    );
                    setState(() {
                      doneGeneratingTheWinner = true;
                    });
                  })),
          SizedBox(
            height: 30,
          ),
          Container(
              color: Colors.deepPurpleAccent,
              height: 45,
              child: FlatButton(
                  child: Text(
                    'Завершить конкурс',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    FirebaseFirestore.instance
                        .collection('post')
                        .doc(widget.post.documentName)
                        .update({'isFinished': true});

                    final DocumentReference ref = firestore
                        .collection('finished_posts')
                        .doc(widget.post.documentName);
                    var docID = ref.id;
                    var _postData = {
                      'postId': widget.post.documentName,
                    };
                    await ref.set(_postData);
                    openDialog(context, 'Конкурс завершен', '');
                  })),
        ],
      ),
    );
  }
}

void openDialog(context, title, message) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(50),
          elevation: 0,
          children: <Widget>[
            Text(title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900)),
            SizedBox(
              height: 10,
            ),
            Text(message,
                style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            SizedBox(
              height: 30,
            ),
            Center(
              child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: Colors.deepPurpleAccent,
                  child: Text(
                    'Okay',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
            )
          ],
        );
      });
}

class ParticipantsList extends StatelessWidget {
  final participants;

  ParticipantsList(this.participants);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: participants,
    );
  }
}
