import 'package:flutter/material.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  MainPage_ createState() => MainPage_();
}

class MainPage_ extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: SingleChildScrollView(
        child: Column(
          children: [
            Text('MAIN PAGE')
          ]
        ))
          );
  }
}