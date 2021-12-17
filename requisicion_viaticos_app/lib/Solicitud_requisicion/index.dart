import 'package:flutter/cupertino.dart';


class Solicitud extends StatefulWidget {

  const Solicitud({Key? key}) : super(key: key);
  Solicitud_ createState() => Solicitud_();
}

class Solicitud_ extends State<Solicitud> {

   @override  
  Widget build(BuildContext context) {
    return 
    Container(
    alignment: Alignment.center,
    child: Column(children: [
        Text('hola')
    ],)
    );
  }
}