import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatelessWidget {
  final participant;
  ProfilePage(this.participant);
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(w * 0.30, 40,
          w * 0.30, 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(participant['profileImageUrl']),
                radius: 80,
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 50,),
              ParticipantInfo(participant['name'], 'Name'),
              SizedBox(height: 20,),
              ParticipantInfo(participant['email'], 'Email'),
              SizedBox(height: 20,),
              ParticipantInfo(participant['phone'], 'Phone'),
              SizedBox(height: 20,),
              ParticipantInfo(participant['insta'], 'Instagram'),
              SizedBox(height: 20,),
              ParticipantInfo(participant['location'], 'Location'),
            ],
          ),
        ),
      ),
    );
  }
}

class ParticipantInfo extends StatelessWidget {
  final String participantInfo;
  final String infoType;

  ParticipantInfo(this.participantInfo, this.infoType);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          infoType,
          style: TextStyle(
            color: Colors.black45
          ),
        ),
        //SizedBox(height: 5,),
        Text(
          participantInfo,
        ),
      ],
    );
  }
}

Widget _appBar (){
  return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: Container(
        height: 60,
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 10,
                  offset: Offset(0, 5)
              )
            ]
        ),
        child: Row(
          children: <Widget>[
            RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.deepPurpleAccent),
                    text: 'Konkurs app: ',
                    children: <TextSpan>[
                      TextSpan(
                          text: ' - Admin Panel',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800])
                      )
                    ])),
            Spacer(),
          ],
        ),
      )

  );
}