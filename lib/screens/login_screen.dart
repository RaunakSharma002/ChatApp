import 'package:chat_app/components/rouded_button.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_sceen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
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
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),

              SizedBox(height: 48.0),
              TextField(
                textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value){
                    //do something else
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email')
              ),

              SizedBox(height: 8.0),
              TextField(
                textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value){
                    //do something else
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password')
              ),

              SizedBox(height: 24.0),
              RoundedButton(title: 'Login', colour: Colors.lightBlueAccent, onPressed: () async{
                setState((){
                  showSpinner = true;
                });
                try{
                  final user = await _auth.signInWithEmailAndPassword(email: email!, password: password!);
                  if(user != null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                }catch(e){
                  print(e);
                }
                setState(() {
                  showSpinner = false;
                });
              },)
            ],
          ),
        ),
      ),
    );
  }
}
