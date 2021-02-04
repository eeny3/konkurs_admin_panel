import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:firebase/firebase.dart' as fb;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:path/path.dart' as Path;
import 'package:mime_type/mime_type.dart';
import 'package:date_time_picker/date_time_picker.dart';

class UploadPost extends StatefulWidget {
  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var formKey = GlobalKey<FormState>();
  var titleCtrl = TextEditingController();
  var imageUrlCtrl = TextEditingController();
  var prizeUrlCtrl = TextEditingController();
  var taskOneCtrl = TextEditingController();
  var taskTwoCtrl = TextEditingController();
  var taskThreeCtrl = TextEditingController();
  var descriptionCtrl = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool notifyUsers = true;
  bool uploadStarted = false;
  String _timestamp;
  String _date;
  var _postData;
  var endDate;

  clearTextFeilds() {
    titleCtrl.clear();
    descriptionCtrl.clear();
    imageUrlCtrl.clear();
    prizeUrlCtrl.clear();
    taskOneCtrl.clear();
    taskTwoCtrl.clear();
    taskThreeCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  void handleSubmit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      setState(() => uploadStarted = true);
      await saveToDatabase();
      setState(() => uploadStarted = false);
      openDialog(context, 'Uploaded Successfully', '');
      clearTextFeilds();
    }
  }

  Future saveToDatabase() async {
    var timestamp = FieldValue.serverTimestamp();
    int a;
    bool b;
    var people = [];
    final DocumentReference ref = firestore.collection('post').doc();
    var docID = ref.id;
    _postData = {
      'date': timestamp,
      'description': descriptionCtrl.text,
      'endDate': endDate,
      'imagepost': imageUrlCtrl.text,
      'isFinished': false,
      'likesCount': 0,
      'name': titleCtrl.text,
      'people': people,
      'prize': prizeUrlCtrl.text,
      'shared': b,
      'task1': taskOneCtrl.text,
      'task1Type': taskType1.name,
      'task1TypeShared': [],
      'task2': taskTwoCtrl.text,
      'task2Type': taskType2.name,
      'task2TypeShared': [],
      'task3': taskThreeCtrl.text,
      'task3Type': taskType3.name,
      'task3TypeShared': [],
      'todo': 'kekW',
      'postId': docID,
      'winner': "",
      'winnerId': a,
      'winnerUid': "",
    };
    await ref.set(_postData);
  }

  // Future uploadImageToFirebase(BuildContext context, File file) async {
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   Reference ref = storage.ref().child("image1" + DateTime.now().toString());
  //   UploadTask uploadTask = ref.putFile(file);
  //   uploadTask.then((res) {
  //     res.ref.getDownloadURL();
  //   });
  // }

  Future<MediaInfo> imagePicker() async {
    MediaInfo mediaInfo = await ImagePickerWeb.getImageInfo;
    return mediaInfo;
  }

  Future<Uri> uploadFile(
      MediaInfo mediaInfo, String ref, String fileName) async {
    try {
      String mimeType = mime(Path.basename(mediaInfo.fileName));

      // html.File mediaFile =
      //     new html.File(mediaInfo.data, mediaInfo.fileName, {'type': mimeType});
      final String extension = extensionFromMime(mimeType);

      var metadata = fb.UploadMetadata(
        contentType: mimeType,
      );

      fb.StorageReference storageReference =
          fb.storage().ref(ref).child(fileName + ".$extension");

      fb.UploadTaskSnapshot uploadTaskSnapshot =
          await storageReference.put(mediaInfo.data, metadata).future;

      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      return imageUri;
    } catch (e) {
      return null;
    }
  }

  List<TaskType> users = <TaskType>[
    const TaskType('instagram'),
    const TaskType('tweeter'),
    const TaskType('system'),
    const TaskType('comment'),
    const TaskType('facebook'),
  ];

  TaskType taskType1;
  TaskType taskType2;
  TaskType taskType3;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: h * 0.10,
              ),
              Text(
                'Детали конкурса',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration('Введите имя', 'Имя', titleCtrl),
                controller: titleCtrl,
                validator: (value) {
                  if (value.isEmpty) return 'Пустое значение';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      decoration: inputDecoration(
                          'Введите Url картинки', 'Превью картинки', imageUrlCtrl),
                      controller: imageUrlCtrl,
                      validator: (value) {
                        if (value.isEmpty) return 'Пустое значение';
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.upload_file),
                      onPressed: () async {
                        var img = await imagePicker();
                        var url = await uploadFile(
                            img, 'images/konkurs_images', img.fileName);
                        imageUrlCtrl.text = url.toString();
                        print(url);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      decoration: inputDecoration(
                          'Url приза', 'Изображение приза', prizeUrlCtrl),
                      controller: prizeUrlCtrl,
                      validator: (value) {
                        if (value.isEmpty) return 'Пустое значение';
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.upload_file),
                      onPressed: () async {
                        var img = await imagePicker();
                        var url = await uploadFile(
                            img, 'images/konkurs_images', img.fileName);
                        prizeUrlCtrl.text = url.toString();
                        print(url);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration('задание 1', 'задание 1', taskOneCtrl),
                controller: taskOneCtrl,
                validator: (value) {
                  //if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<TaskType>(
                decoration: InputDecoration(
                  hintText: 'выберите тип задания',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.only(right: 0, left: 10),
                ),
                value: taskType1,
                onChanged: (TaskType Value) {
                  setState(() {
                    taskType1 = Value;
                  });
                },
                items: users.map((TaskType user) {
                  return DropdownMenuItem<TaskType>(
                    value: user,
                    child: Text(
                      user.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration('задание 2', 'задание 2', taskTwoCtrl),
                controller: taskTwoCtrl,
                validator: (value) {
                  //if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<TaskType>(
                decoration: InputDecoration(
                  hintText: 'выберите тип задания',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.only(right: 0, left: 10),
                ),
                value: taskType2,
                onChanged: (TaskType Value) {
                  setState(() {
                    taskType2 = Value;
                  });
                },
                items: users.map((TaskType user) {
                  return DropdownMenuItem<TaskType>(
                    value: user,
                    child: Text(
                      user.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration('задание 3', 'задание 3', taskThreeCtrl),
                controller: taskThreeCtrl,
                validator: (value) {
                  //if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<TaskType>(
                decoration: InputDecoration(
                  hintText: 'выберите тип задания',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.only(right: 0, left: 10),
                ),
                value: taskType3,
                onChanged: (TaskType Value) {
                  setState(() {
                    taskType3 = Value;
                  });
                },
                items: users.map((TaskType user) {
                  return DropdownMenuItem<TaskType>(
                    value: user,
                    child: Text(
                      user.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Введите описание',
                    border: OutlineInputBorder(),
                    labelText: 'Описание',
                    contentPadding:
                        EdgeInsets.only(right: 0, left: 10, top: 15, bottom: 5),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[300],
                        child: IconButton(
                            icon: Icon(Icons.close, size: 15),
                            onPressed: () {
                              descriptionCtrl.clear();
                            }),
                      ),
                    )),
                textAlignVertical: TextAlignVertical.top,
                minLines: 5,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: descriptionCtrl,
                validator: (value) {
                  if (value.isEmpty) return 'Пустое значение';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text('Дата завершения', style: TextStyle(color: Colors.grey),),
              DateTimePicker(
                decoration: InputDecoration(
                  hintText: 'Дата завершения',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.only(right: 0, left: 10),
                ),
                type: DateTimePickerType.dateTime,
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                onChanged: (val) {
                  DateTime dateTime = DateTime.parse(val);

                  Timestamp myTimeStamp = Timestamp.fromDate(dateTime);

                  endDate = myTimeStamp;
                },
                validator: (val) {
                  return null;
                },
                onSaved: (val) => print(val),
              ),
              SizedBox(
                height: 100,
              ),
              Container(
                  color: Colors.deepPurpleAccent,
                  height: 45,
                  child: uploadStarted == true
                      ? Center(
                          child: Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator()),
                        )
                      : FlatButton(
                          child: Text(
                            'Создать конкурс',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () async {
                            handleSubmit();
                          })),
              SizedBox(
                height: 200,
              ),
            ],
          )),
    );
  }
}

class TaskType {
  const TaskType(this.name);

  final String name;
}

InputDecoration inputDecoration(hint, label, controller) {
  return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(),
      labelText: label,
      contentPadding: EdgeInsets.only(right: 0, left: 10),
      suffixIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 15,
          backgroundColor: Colors.grey[300],
          child: IconButton(
              icon: Icon(Icons.close, size: 15),
              onPressed: () {
                controller.clear();
              }),
        ),
      ));
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
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        );
      });
}
