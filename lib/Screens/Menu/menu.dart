import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:techathon/Screens/Menu/addQuestions.dart';
import 'package:techathon/Screens/Menu/profile.dart';

import '../../constants.dart';
import 'all questions.dart';


class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

final tabs = [
  AllQuestion(),
  Container(color: Colors.green,),
  Profile()
];
class _MenuState extends State<Menu> {
  int _currentIndex = 0;
  bool initialized = false;
  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      initialized = true;
      setState(() {});
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddQuestion()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30.0,
        ),
      ),
      body: (initialized)?tabs[_currentIndex]:Container(child: Text('loading'),),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.question_answer,
                color: kPrimaryColor,
              ),
              title: Text(
                'Home',
                style: TextStyle(color: kPrimaryColor),
              ),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle, color: kPrimaryColor),
              title: Text(
                'Chat',
                style: TextStyle(color: kPrimaryColor),
              ),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: kPrimaryColor),
              title: Text(
                'Profile',
                style: TextStyle(color: kPrimaryColor),
              ),
              backgroundColor: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

}
