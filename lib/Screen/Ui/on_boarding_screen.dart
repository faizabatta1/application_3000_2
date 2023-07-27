import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:zainlak_tech/Auth/LoginScreen.dart';
import 'package:zainlak_tech/Screen/Ui/MainScreen.dart';

class OnboardingScreen extends StatelessWidget {
  final String? token;
  OnboardingScreen({ required this.token });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Welcome to Technicians App",
            body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            image: Image.asset("assets/icon/logo.jpg",fit: BoxFit.cover,),
          ),
          PageViewModel(
            title: "Find Jobs Easily",
            body: "Search and apply for jobs near your location.",
            image: Image.asset("assets/icon/logo.jpg",fit: BoxFit.cover,),
          ),
          PageViewModel(
            title: "Get Started Now!",
            body: "Join our community and start earning.",
            image: Image.asset("assets/icon/logo.jpg",fit: BoxFit.cover,),
          ),
        ],
        onDone: () {
          // Navigate to the HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => token == null ? LoginScreen() : MainScreen()),
          );
        },
        done: Text("Get Started"),
        showSkipButton: true,
        skip: Text("Skip"),
        next: Icon(Icons.arrow_forward),
        dotsDecorator: DotsDecorator(
          activeColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

