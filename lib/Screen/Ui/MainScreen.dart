import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zainlak_tech/Constant/AppColor.dart';
import 'package:zainlak_tech/Screen/Ui/BookingScreen.dart';
import 'package:zainlak_tech/Screen/Ui/FavouriteScreen.dart';
import 'package:zainlak_tech/Screen/Ui/HomeScreen.dart';
import 'package:zainlak_tech/Screen/Ui/MoreScreen.dart';
import 'package:zainlak_tech/Screen/Ui/ProfileScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;
  List<Widget> screens = [
    HomeScreen(),
    BookingScreen(),
    FavouriteScreen(),
    ProfileScreen(),
    MoreScreen(),
  ];

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Press back again to exit').tr(),
        ),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                pageIndex == 0 ? Icons.home : Icons.home_outlined,
              ),
              label: 'Home'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                pageIndex == 1 ? Icons.book : Icons.book_outlined,
              ),
              label: 'Bookings'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                pageIndex == 2 ? Icons.favorite : Icons.favorite_outline,
              ),
              label: 'Favorites'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                pageIndex == 3 ? Icons.person : Icons.person_outline,
              ),
              label: 'Profile'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                pageIndex == 4 ? Icons.more_horiz : Icons.more_horiz_outlined,
              ),
              label: 'More'.tr(),
            ),
          ],
          backgroundColor: Colors.red,
          elevation: 50,
          currentIndex: pageIndex,
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.black,
          showUnselectedLabels: true,
        ),
        body: screens[pageIndex],
      ),
    );
  }
}