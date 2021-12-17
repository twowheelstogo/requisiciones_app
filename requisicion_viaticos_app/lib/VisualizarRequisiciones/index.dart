
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:requisicion_viaticos_app/MainPage/index.dart';

class VisualizarRequisiciones extends StatefulWidget {

  const VisualizarRequisiciones({Key? key}) : super(key: key);
  VisualizarRequisiciones_ createState() => VisualizarRequisiciones_();
}

class VisualizarRequisiciones_ extends State<VisualizarRequisiciones> {

  void Regresar(context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => MainPage(),
      ),
    );
  }
   @override  
  Widget build(BuildContext context) {
    return 
    Container(
    alignment: Alignment.center,
    child:     
    Column(children: [      
      Text('HOLAS') ,
      Regresar_(context) 
    ],)
    );
  }  


  Widget Regresar_(context) {
    return Column(
      children: [
        Container(
            alignment: Alignment.bottomLeft,
            child: Padding(
                padding: EdgeInsets.only(right: 0.0),
                child: ButtonTheme(
                  minWidth: 100.0,
                  height: 45.0,
                  child: RaisedButton(
                    textColor: HexColor('#535461'),
                    color: HexColor("#FFFFFF"),
                    child: Text(
                      "Regresar",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lato',
                        color: HexColor("#535461"),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () => Regresar(context),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(40.0),
                    ),
                  ),
                )))
      ],
    );
  }

}
