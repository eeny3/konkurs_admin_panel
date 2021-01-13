import 'package:cloud_firestore/cloud_firestore.dart';

class Post {

  String name;
  String description;
  String imagepost;
  String prize;
  String task1;
  String task2;
  String task3;
  bool shared;
  String todo;
  var date;
  var postId;

  Post({
    this.name,
    this.description,
    this.imagepost,
    this.prize,
    this.task1,
    this.task2,
    this.task3,
    this.shared,
    this.todo,
    this.date,
    this.postId,
  });


  factory Post.fromFirestore(DocumentSnapshot snapshot){
    var d = snapshot.data();
    return Post(
      name: d['name'],
      description: d['description'],
      imagepost: d['imagepost'],
      prize: d['prize'],
      task1: d['task1'],
      task2: d['task2'],
      task3: d['task3'],
      shared: d['shared'],
      todo: d['todo'],
      date: d['date'],
      postId: d['postId'],
    );
  }
}