

import 'package:easy_localization/easy_localization.dart' show BuildContextEasyLocalizationExtension, tr;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constant/AppColor.dart';
import 'package:http/http.dart' as http;

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override

  Future <String> getAbout () async {
    try{
      http.Response response = await http.get(Uri.parse("https://adminzaindev.zaindev.com.sa/informations/about"));
      return response.body;
    } catch(error){
      return "error";
    }
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.AppColors,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,size: 30,color: Colors.white,),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: FutureBuilder(

           future: getAbout(),

          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
             if(snapshot.connectionState == ConnectionState.waiting){
               return Center(child: CircularProgressIndicator(
                 color: AppColor.AppColors,
               ));
             }
             if(snapshot.data==null){
               return Center(
                 child: Text('Data is null'),
               );
             }
             return Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text("${snapshot.data}",style: TextStyle(
                 fontSize: 20,
                 fontWeight: FontWeight.w500
               ),),
             );
        } ,

        ),
      )
    );
  }
}
