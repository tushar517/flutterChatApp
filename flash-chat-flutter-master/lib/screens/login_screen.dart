import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flash_chat/Components.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static String id='login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth=FirebaseAuth.instance;
  String emailId,pass;

 bool showSpinner=false;
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
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
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
                  emailId=value;
                },
                decoration: kTextDecoration.copyWith(hintText: 'Enter E-mail Id'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  pass=value;
                },
                decoration: kTextDecoration.copyWith(hintText: 'Enter Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              button(Colors.lightBlueAccent,'Log In',() async {
                //Go to Log In screen.
                setState(() {
                  showSpinner=true;
                });
                try{
                final user=await _auth.signInWithEmailAndPassword(email: emailId, password: pass);
                if(user!=null) {
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
