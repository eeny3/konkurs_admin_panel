import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:firebase/firebase.dart' as fb;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:path/path.dart' as Path;
import 'package:mime_type/mime_type.dart';

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
        setState(()=> uploadStarted = true);
          await saveToDatabase();
          setState(()=> uploadStarted = false);
          openDialog(context, 'Uploaded Successfully', '');
          clearTextFeilds();
    }
  }

  Future saveToDatabase() async {
    var timestamp = FieldValue.serverTimestamp();
    final DocumentReference ref = firestore.collection('post').doc();
    var docID = ref.id;
    _postData = {
      'name' : titleCtrl.text,
      'description' : descriptionCtrl.text,
      'imagepost' : imageUrlCtrl.text,
      'prize' : prizeUrlCtrl.text,
      'task1' : taskOneCtrl.text,
      'task2' : taskTwoCtrl.text,
      'task3' : taskThreeCtrl.text,
      'shared': true,
      'todo': 'kekW',
      'date': timestamp,
      'postId' : docID,
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
      print("download url $imageUri");
      return imageUri;
    } catch (e) {
      print("File Upload Error $e");
      return null;
    }
  }

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
                'Post Details',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),

              SizedBox(height: 20,),

              TextFormField(
                decoration: inputDecoration('Enter Name', 'Name', titleCtrl),
                controller: titleCtrl,
                validator: (value) {
                  if (value.isEmpty) return 'Value is empty';
                  return null;
                },

              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      decoration: inputDecoration('Enter Image Url', 'Thumbnail Image', imageUrlCtrl),
                      controller: imageUrlCtrl,
                      validator: (value) {
                        if (value.isEmpty) return 'Value is empty';
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(icon: Icon(Icons.upload_file),
                        onPressed: () async {
                          var img = await imagePicker();
                          var url = await uploadFile(img, 'images/konkurs_images', 'kto');
                          imageUrlCtrl.text = url.toString();
                          print(url);
                        },
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      decoration: inputDecoration('Prize Image Url', 'Prize Image', prizeUrlCtrl),
                      controller: prizeUrlCtrl,
                      validator: (value) {
                        if (value.isEmpty) return 'Value is empty';
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(icon: Icon(Icons.upload_file),
                      onPressed: () async {
                        var img = await imagePicker();
                        var url = await uploadFile(img, 'images/konkurs_images', img.fileName);
                        prizeUrlCtrl.text = url.toString();
                        print(url);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: inputDecoration('task 1', 'task 1', taskOneCtrl),
                controller: taskOneCtrl,
                validator: (value) {
                  //if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: inputDecoration('task 2', 'task 2', taskTwoCtrl),
                controller: taskTwoCtrl,
                validator: (value) {
                  //if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: inputDecoration('task 3', 'task 3', taskThreeCtrl),
                controller: taskThreeCtrl,
                validator: (value) {
                  //if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Enter Description (Html or Normal Text)',
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                    contentPadding: EdgeInsets.only(
                        right: 0, left: 10, top: 15, bottom: 5),
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
                  if (value.isEmpty) return 'Value is empty';
                  return null;
                },

              ),
              SizedBox(height: 100,),
              Container(
                  color: Colors.deepPurpleAccent,
                  height: 45,
                  child: uploadStarted == true
                      ? Center(child: Container(height: 30, width: 30,child: CircularProgressIndicator()),)
                      : FlatButton(
                      child: Text(
                        'Upload Post',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () async{
                        handleSubmit();
                      })
              ),
              SizedBox(
                height: 200,
              ),
            ],
          )),

    );
  }
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