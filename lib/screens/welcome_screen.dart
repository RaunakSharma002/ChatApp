import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/components/rouded_button.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeSreen extends StatefulWidget {
  static const String id = "welcome_screen";
  const WelcomeSreen({Key? key}) : super(key: key);

  @override
  State<WelcomeSreen> createState() => _WelcomeSreenState();
}

class _WelcomeSreenState extends State<WelcomeSreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  Animation? animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller!.forward();
    controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation!.value * 100,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                )
              ],
            ),

            SizedBox(height: 48.0,),
            RoundedButton(colour: Colors.lightBlueAccent, title: 'Login',
              onPressed: (){Navigator.pushNamed(context, LoginScreen.id);},
            ),

            SizedBox(height: 8.0,),
            RoundedButton(colour: Colors.blueAccent, title: 'Registration',
              onPressed: (){Navigator.pushNamed(context, RegistrationScreen.id);},
            ),
          ],
        ),
      ),
    );
  }
}


