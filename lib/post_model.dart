import 'package:cloud_firestore/cloud_firestore.dart';

class Post {

  String name;
  String description;
  String imagepost;
  String prize;
  String task1;
  var taskOneTypeShared;
  String task2;
  var taskTwoTypeShared;
  String task3;
  var taskThreeTypeShared;
  bool shared;
  String todo;
  var date;
  var people;
  String prizeImageFileName;
  var postId;
  String documentName;
  String winner;
  int winnerId;
  String winnerUid;
  bool isFinished;

  Post({
    this.name,
    this.description,
    this.imagepost,
    this.prize,
    this.task1,
    this.taskOneTypeShared,
    this.task2,
    this.taskTwoTypeShared,
    this.task3,
    this.taskThreeTypeShared,
    this.shared,
    this.todo,
    this.date,
    this.people,
    this.prizeImageFileName,
    this.postId,
    this.documentName,
    this.winner,
    this.winnerId,
    this.winnerUid,
    this.isFinished,
  });


  factory Post.fromFirestore(DocumentSnapshot snapshot){
    var d = snapshot.data();
    String docName = snapshot.id;
    return Post(
      name: d['name'],
      description: d['description'],
      imagepost: d['imagepost'],
      prize: d['prize'],
      task1: d['task1'],
      taskOneTypeShared: d['task1TypeShared'],
      task2: d['task2'],
      taskTwoTypeShared: d['task2TypeShared'],
      task3: d['task3'],
      taskThreeTypeShared: d['task3TypeShared'],
      shared: d['shared'],
      todo: d['todo'],
      date: d['date'],
      people: d['people'],
      prizeImageFileName: d['prizeImageFileName'],
      postId: d['postId'],
      documentName: docName,
      winner: d['winner'],
      winnerId: d['winnerId'],
      winnerUid: d['winnerUid'],
      isFinished: d['isFinished'],
    );
  }
}