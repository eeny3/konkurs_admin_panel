import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var passwordCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String password;
  String email;

  singIn() async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          //email: email, password: password);
          email: 'xabuovx@gmail.com', password: '123456');
      if (user != null) {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => AdminPanel()));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Container(
            height: 638,
            width: 600,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 10,
                    offset: Offset(3, 3))
              ],
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Konkurs: Admin panel',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                Text(
                  'Welcome to Admin Panel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailCtrl,
                          decoration: InputDecoration(
                            hintText: 'Enter email',
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            contentPadding: EdgeInsets.only(right: 0, left: 10),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.grey[300],
                                child: IconButton(
                                    icon: Icon(Icons.close, size: 15),
                                    onPressed: () {
                                      emailCtrl.clear();
                                    }),
                              ),
                            ),
                          ),
                          validator: (String value) {
                            if (value.length == 0)
                              return "Email can't be empty";
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          controller: passwordCtrl,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: 'Enter Password',
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              contentPadding:
                              EdgeInsets.only(right: 0, left: 10),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.grey[300],
                                  child: IconButton(
                                      icon: Icon(Icons.close, size: 15),
                                      onPressed: () {
                                        passwordCtrl.clear();
                                      }),
                                ),
                              )),
                          validator: (String value) {
                            if (value.length == 0)
                              return "Password can't be empty";
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              password = value;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 45,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey[400],
                            blurRadius: 10,
                            offset: Offset(2, 2))
                      ]),
                  child: FlatButton.icon(
                    //padding: EdgeInsets.only(left: 30, right: 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 25,
                    ),
                    label: Text(
                      'Log In',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                    onPressed: () {
                      singIn();

                    },
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),);
  }
}
