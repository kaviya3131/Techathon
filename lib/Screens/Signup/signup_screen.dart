import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techathon/Screens/Menu/menu.dart';
import 'package:techathon/Screens/Signup/components/background.dart';
import 'package:techathon/Screens/Signup/components/body.dart';
import 'package:techathon/Screens/Signup/components/or_divider.dart';
import 'package:techathon/components/already_have_an_account_acheck.dart';
import 'package:techathon/components/rounded_button.dart';

import '../Login/login_screen.dart';
import '../Widgets/simple_textstyle.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String text = '';

  TextEditingController emailEditingController = new TextEditingController();

  TextEditingController passwordEditingController = new TextEditingController();

  bool found = false;

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();



        final _auth = FirebaseAuth.instance;
        final user = await _auth.createUserWithEmailAndPassword(
            email: emailEditingController.text,
            password: passwordEditingController.text);
        if (user != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('id', emailEditingController.text);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Menu()));
        }
      }
      catch (e) {
        print(e);
        setState(() {
          isLoading = false;
          text = 'Account Does not found & password Did not match!!';
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(

          child: Container(
            padding: EdgeInsets.all(15.0),
            child: isLoading
                ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
                : Container
              (
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "SIGNUP",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.height * 0.03),
                  SvgPicture.asset(
                    "assets/icons/signup.svg",
                    height: size.height * 0.35,
                  ),
                  SizedBox(height: size.height * 0.03),


                  Form(
                    key: formKey,

                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      child: Column(
                        children: [


                          TextFormField(
                            validator: (val) {
                              return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                                  ? null
                                  : "Please Enter Correct Email";
                            },
                            controller: emailEditingController,

                            style: simpleTextStyle(),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 20),
                                prefixIcon: Padding(
                                  padding:
                                  EdgeInsets.only(top: 15, bottom: 10),
                                  child: Icon(
                                    Icons.account_circle,
                                    color: Colors.black87,
                                    size: 30.0,
                                  ),
                                ),
                                hintText: 'Email ID',
                                hintStyle: TextStyle(color: Colors.black38),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFF6F35A5))),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.black))),
                          ),
                          SizedBox(height: 20,),

                          TextFormField(
                            obscureText: true,


                            controller: passwordEditingController,

                            style: simpleTextStyle(),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 20),
                                prefixIcon: Padding(
                                  padding:
                                  EdgeInsets.only(top: 15, bottom: 10),
                                  child: Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                    size: 30.0,
                                  ),
                                ),
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.black38),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFF6F35A5))),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.black))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Text(
                              text, textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),


                  RoundedButton(
                    text: "SIGN UP",
                    press: () {
                      signIn();
                    },
                  ),
                  SizedBox(height: size.height * 0.03),
                  AlreadyHaveAnAccountCheck(
                    login: false,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                  ),
                  //guest
//            SizedBox(height: 15,),
                  OrDivider(),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => Menu()
                      ));
                    },
                    child: Text(
                        "Sign In as Guest!",
                        style: signin_uptextstyle()
                      //style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
