import 'dart:math';

import 'package:flutter/material.dart';
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
  int winnerId;
  var winnerDoc;
  String person = '';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  getParticipants() async {
    DocumentSnapshot document
    = await firestore.collection('post').doc(widget.post.documentName).get();
    participants = document['people'];

    for(int i = 0; i < participants.length; ++i){
      DocumentSnapshot participant
      = await firestore.collection('users').doc(participants[i].toString()).get();

      Widget participantWidget = Column(
        children: [
          InkWell(
            onTap: (){
              Future((){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ProfilePage(participant)));
              });
            },
            child: Text(
              '${participant['name']}: ${participant['email']}',
              style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 10,),
        ],
      );

      setState(() {
        participantWidgets.add(participantWidget);
      });
    }
  }

  generateWinner() async {
    var winnerIndex = Random().nextInt(participants.length);
    winnerId = winnerIndex;
    DocumentSnapshot winnerParticipant
    = await firestore.collection('users').doc(participants[winnerIndex].toString()).get();
    setState(() {
      winnerName = '${winnerParticipant['name']}: ${winnerParticipant['email']}';
    });
    return winnerParticipant;
  }

  @override
  void initState() {
    super.initState();
    getParticipants();
  }

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
          SizedBox(height: 15,),
          Text(
            'Post details:',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 15,),
          Text(
            'Description',
            overflow: TextOverflow.ellipsis,
            style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15,),
          Text(
            widget.post.description,
            style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 30,),
          Text(
            'Participants: ',
            overflow: TextOverflow.ellipsis,
            style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15,),
          ParticipantsList(participantWidgets),
          Text(
            'Winner: ',
            overflow: TextOverflow.ellipsis,
            style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15,),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ProfilePage(winnerDoc)));
            },
            child: Text(
              widget.post.winner,
              style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 30,),
          Container(
              color: Colors.deepPurpleAccent,
              height: 45,
              child:  FlatButton(
                  child: Text(
                    'Generate winner',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async{
                    //get winner
                    // if(widget.post.winner == "") {
                    //   winnerDoc = await generateWinner();
                    //     FirebaseFirestore.instance.collection('post')
                    //         .doc(widget.post.documentName)
                    //         .update({'winner': winnerDoc['name'], 'winnerId': winnerId});
                    //     setState(() {
                    //       widget.post.winner = winnerDoc['name'];
                    //     });
                    // }
                    // else{
                    //     winnerDoc
                    //     = await firestore.collection('users').doc(
                    //         participants[widget.post.winnerId].toString()).get();
                    // }
                    winnerDoc = await generateWinner();
                    FirebaseFirestore.instance.collection('post')
                        .doc(widget.post.documentName)
                        .update({'winner': winnerDoc['name'], 'winnerId': winnerId});
                    setState(() {
                      widget.post.winner = winnerDoc['name'];
                    });
                  })
          ),
          SizedBox(height: 30,),
          Container(
              color: Colors.deepPurpleAccent,
              height: 45,
              child:  FlatButton(
                  child: Text(
                    'Close post',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async{
                    FirebaseFirestore.instance.collection('post')
                        .doc(widget.post.documentName)
                        .update({'isFinished': true});

                    final DocumentReference ref = firestore.collection('finished_posts').doc(widget.post.documentName);
                    var docID = ref.id;
                    var _postData = {
                      'postId' : widget.post.documentName,
                    };
                    await ref.set(_postData);
                    openDialog(context, 'Post closed', '');
                  })
          ),
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
                }
              ),
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
