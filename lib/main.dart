import 'package:firedeneme/home_Screen.dart';
import 'package:firedeneme/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: HomeScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyHomePageState();
  }

}

class MyHomePageState extends State{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.deepPurpleAccent,
    );
  }
}