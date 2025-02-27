import 'package:chat_app/components/rouded_button.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "registration_screen";
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>{
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
              RoundedButton(title: 'Register', colour: Colors.blueAccent,
                onPressed: () async{
                  setState(() {
                    showSpinner = true;
                  });
                  try{
                    final newUser = await _auth.createUserWithEmailAndPassword(email: email!, password: password!);
                    if(newUser != null){
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  }catch(e){
                    print(e);
                  }
                  setState(() {
                    showSpinner = false;
                  });
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}
