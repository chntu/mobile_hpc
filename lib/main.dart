import 'package:flutter/material.dart';
import 'constants.dart';
import 'Q1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context) => Q1()));
        },
        color: Colors.green,
        child: Text(
          'Start',
          style: kWhiteTextStyle,
        ),
      ),
    );
  }
}


