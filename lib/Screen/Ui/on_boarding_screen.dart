import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:zainlak_tech/Auth/LoginScreen.dart';
import 'package:zainlak_tech/Screen/Ui/MainScreen.dart';

class OnboardingScreen extends StatelessWidget {
  final String? token;
  OnboardingScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white, // Set the background color
        pages: [
          PageViewModel(
            title: "Welcome to Zain Development App",
            body: "Your Favorite App To Find Technicians at Low Price",
            image: _buildImageWidget("assets/choice.png"),
            decoration: _getPageDecoration(),
          ),
          PageViewModel(
            title: "Find Technicians Easily",
            body: "Search for Technicians Near Your Location",
            image: _buildImageWidget("assets/clock.png"),
            decoration: _getPageDecoration(),
          ),
          PageViewModel(
            title: "Get Started Now!",
            body: "Join Our Community and Start Finding Technicians",
            image: _buildImageWidget("assets/snap.png"),
            decoration: _getPageDecoration(),
          ),
        ],
        onDone: () {
          // Navigate to the HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => token == null ? LoginScreen() : MainScreen(),
            ),
          );
        },
        done: Text(
          "Get Started",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        showSkipButton: true,
        skip: Text("Skip"),
        next: Icon(Icons.arrow_forward),
        dotsDecorator: DotsDecorator(
          activeColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    return Center(
      child: Image.asset(
        imagePath,
        height: 200,
        width: 200,
        fit: BoxFit.contain,
      ),
    );
  }

  PageDecoration _getPageDecoration() {
    return PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: TextStyle(fontSize: 20.0),
      imagePadding: EdgeInsets.fromLTRB(0, 40, 0, 0),
      pageColor: Colors.white,
    );
  }
}
