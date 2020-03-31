import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:group_chat/constants.dart';


class WelcomeScreen extends StatefulWidget {
  static String id = 'WelcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
//      upperBound: 100,
    );
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener((){
      setState(() {
      });
    });
  }



  static String id = 'WelcomeScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'Logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 500 ),
                  totalRepeatCount: 1,
                  text: ['Group Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            WelcomeScreenButtons(text: 'Login', onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },),
            WelcomeScreenButtons(text: 'Register', onPressed: () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            },),
          ],
        ),
      ),
    );
  }
}

