

import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zainlak_tech/Constant/AppColor.dart';
import 'package:zainlak_tech/Services/reservations.dart';
import 'package:zainlak_tech/Services/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zainlak_tech/main.dart';

import '../../Auth/LoginScreen.dart';

class employeeProfile extends StatefulWidget {
  final Map<String,dynamic> tech;
  const employeeProfile ({Key? key, required this.tech}) : super(key: key);

  @override
  State<employeeProfile> createState() => _employeeProfile();
}

class _employeeProfile extends State<employeeProfile> {



  bool isLoading = false;
  String phoneNumber = "";
  String email="";
  String name = "";
  String position = "";
  String joinedAt = "";
  String imageUrl = "";
  String job = "";
  bool isSameUser = false;

  DateTime? _date;

  int _time = 0;
  bool _isFavorite = false;
  void detectIsFavorite()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? decoded = sharedPreferences.getString('user');
    Map<String,dynamic> user = jsonDecode(decoded!);
    if((user['favorites'] as List).contains(widget.tech['_id'])){
      setState(() {
        _isFavorite = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detectIsFavorite();
  }

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime Date = DateTime.now();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Stack(


                      children: [


                        Card(

                          margin: EdgeInsets.symmetric(vertical: 40,horizontal: 20),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 30,),
                                Align( alignment: Alignment.center, child: Text(widget.tech['name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                                SizedBox(height: 10,),
                                Align( alignment: Alignment.center, child: Text('Joined Since',style: TextStyle(fontSize: 17,color: Colors.indigo),).tr(args: [dateFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.tech['createdAt'])))])),
                                SizedBox(height: 20,),
                                Align(alignment: Alignment.center , child: Text('status',style: TextStyle(fontWeight: FontWeight.bold),).tr(args: [widget.tech['available'] == true ? "available" : "Not available"]),),

                                SizedBox(height: 20,),
                                Align(alignment: Alignment.center  , child: Text('WorkTime').tr(args: [widget.tech['from'],widget.tech['to']]),),
                                SizedBox(height: 20,),
                                Align(alignment: Alignment.center, child: Text('Service Price').tr(args: [widget.tech['price'].toString()]),),
                                SizedBox(height: 20,),

                                Divider(thickness: 1,),
                                SizedBox(height: 40,),
                                Center(child: Text('تواصل مع الفني',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),).tr()),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.green,
                                      child: CircleAvatar(
                                        radius: 23,
                                        backgroundColor: Colors.white,
                                        child: IconButton(onPressed: (){
                                          SendMessageByWatsapp();
                                        }, icon:Icon (FontAwesomeIcons.whatsapp,color: Colors.green,)) ,
                                      ),
                                    ),

                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.blue,
                                      child: CircleAvatar(
                                        radius: 23,
                                        backgroundColor: Colors.white,
                                        child: IconButton(onPressed: (){
                                          CallPhoneNumber();
                                        }, icon:Icon (Icons.phone,color: Colors.blue,)) ,
                                      ),
                                    ),


                                  ],
                                ),
                                SizedBox(height: 15,),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20,right: 20,left: 20,top: 0),
                                    child: MaterialButton(
                                      onPressed: () async{
                                        DateTime? date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2024)
                                        );

                                        if(date != null){
                                          TimeOfDay? time = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now()
                                          );

                                          if(time != null){
                                            setState(() {
                                              _date = date;
                                              _time = time.hour;
                                            });
                                          }
                                          await bookReservation();
                                        }


                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('احجز زياره للمنزل',style: TextStyle(color: Colors.white,fontSize: 18),).tr(),
                                  SizedBox(width: 10,),
                                  Icon(Icons.bookmark_border,color: Colors.white,)
                                  ],
                                ),
                                      color: AppColor.AppColors,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: ()async{
                                      SharedPreferences shared = await SharedPreferences.getInstance();
                                      var decoded = shared.getString('user');
                                      var user = jsonDecode(decoded!);
                                      if(_isFavorite){
                                        List newT = await UserService.deleteFavoriteTech(user['_id'], widget.tech['_id']);
                                        user['favorites'] = newT;
                                        await shared.setString('user', jsonEncode(user));
                                      }else{
                                        List newX = await UserService.createFavoriteTech(user['_id'], widget.tech['_id']);
                                        user['favorites'] = newX;
                                        await shared.setString('user', jsonEncode(user));
                                      }
                                      setState(() {
                                        _isFavorite = !_isFavorite;
                                      });
                                    },
                                    icon: Icon(Icons.favorite,color: _isFavorite ? Colors.red : Colors.black,),
                                  ),
                                ),
                                Divider(thickness: 1,),

                                SizedBox(height: 10,),


                                SizedBox(height: 10,),






                              ],
                            ),
                          ),


                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Container(
                              width:70 ,
                              height:70 ,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(width: 5,color: Theme.of(context).scaffoldBackgroundColor),
                                  image: DecorationImage(image: CachedNetworkImageProvider(widget.tech['image']),fit: BoxFit.fill)
                              ),
                            )
                          ],)
                      ]
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void SendMessageByWatsapp()async{
    if(await canLaunch('https://wa.me/${widget.tech['phone']}')){
      await launch('https://wa.me/${widget.tech['phone']}');
    }
  }
  void SendMail()async{
    String email = 'omarsabry8989@gmail.com';
    var url =  'mailto:${widget.tech['email']}';
    await launch(url);
  }
  void CallPhoneNumber () async{
    var phoneUrl = 'tel://${widget.tech['phone']}';

    await  launch(phoneUrl);
  }
  void logOut (context){
    showDialog(context: context, builder: (context){

      return  AlertDialog(

        title: Column(
          children: [
            Row(children: [
              Icon(Icons.logout),
              SizedBox(width: 10,),
              Text('Sign Out').tr()
            ],),
            SizedBox(height: 10,),
            TextButton(onPressed: (){}, child: Text('Do you want logOut',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),).tr())
          ],
        ),
        actions: [
          TextButton(onPressed: ()async{


            Navigator.push(context, MaterialPageRoute(builder: (context){
              return LoginScreen();
            }));

          }, child: Text('Ok').tr()),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel').tr()),
        ],

      );
    });
  }
  Future<void> bookReservation() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String? decoded = sharedPreferences.getString('user');
      Map<String, dynamic> user = jsonDecode(decoded!);
      DateFormat format = DateFormat('MM-dd');
      String newDate = format.format(_date!);

      ({String? message}) result = await ReservationService.createReservation(
          user['_id'], widget.tech['_id'], newDate, _time);

      if(result.message == null){
        await showFlutterNotification('Booking Status', 'Your Booking Was Created');
      }else{
        await showFlutterNotification('Booking Status', 'Your Booking Was Not Created');
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AnimatedDialog(
            title: 'Booking Successful'.tr(),
            icon: Icons.check_circle,
            iconColor: Colors.green,
            backgroundColor: AppColor.AppColors,
          );
        },
      );

    } catch (error) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AnimatedDialog(
            title: 'Booking Failed'.tr(),
            icon: Icons.close,
            iconColor: Colors.red,
            backgroundColor: Colors.white,
          );
        },
      );
    }
  }

}


class AnimatedDialog extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  AnimatedDialog({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return ScaleTransition(
            scale: _scaleAnimation,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      color: widget.iconColor,
                      size: 80,
                    ),
                    SizedBox(height: 20),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
