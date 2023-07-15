
import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:zainlak_tech/Auth/LoginScreen.dart';
import 'package:zainlak_tech/Constant/AppColor.dart';
import 'package:zainlak_tech/Screen/Ui/MainScreen.dart';

class SplachScreen extends StatefulWidget {
  final String? token;
  const SplachScreen({super.key, required this.token});

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3), () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return widget.token != null ? MainScreen() : LoginScreen();
    })); });
    super.initState();
  }
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.AppColors,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text("Z" , style: TextStyle(color: Colors.white,
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
                ),),
              ),
              Center(
                child: Text("Welcome To Zainlk" , style: TextStyle(color: Colors.white,
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                ),).tr(),
              ),
              Center(
                child: Text("For Home Services" , style: TextStyle(color: Colors.white,
                    fontSize: 22,

                    fontStyle: FontStyle.italic
                ),).tr(),
              ),
              SizedBox(height: 12,),
              CircularProgressIndicator(color: Colors.white,),
              SizedBox(height: 12,),

            ],
          ),
        ),
      ),
    );
  }
}