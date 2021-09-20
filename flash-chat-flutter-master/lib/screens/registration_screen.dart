import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/Components.dart';
import 'package:flash_chat/constants.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
class RegistrationScreen extends StatefulWidget {
  static String id='registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner=false;
  final _auth=FirebaseAuth.instance;
  String email,password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  email=value;
                },
                decoration: kTextDecoration.copyWith(hintText: 'Enter Your E-mail Id'),

              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  password=value;
                },
                decoration: kTextDecoration.copyWith(hintText: 'Enter Your Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              button(Colors.blueAccent,'Register',() async{
                setState(() {
                  showSpinner=true;
                });
                //Go to registration screen.
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if(newUser!=null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                  setState(() {
                    showSpinner=false;
                  });
                }catch(e){
                  print(e);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
