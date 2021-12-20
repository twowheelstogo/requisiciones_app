import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:requisicion_viaticos_app/Solicitud_requisicion/CreateRequisicionModal.dart';
import 'package:requisicion_viaticos_app/VisualizarRequisiciones/index.dart';


class Solicitud extends StatefulWidget {

  const Solicitud({Key? key}) : super(key: key);
  Solicitud_ createState() => Solicitud_();
}

class Solicitud_ extends State<Solicitud> {

    bool Bandera = false;
    TextEditingController FechaInicio = TextEditingController();
    TextEditingController FechaFin = TextEditingController();
    TextEditingController Monto = TextEditingController();
    String Agencia = "";
         

   @override  
  Widget build(BuildContext context) {
   final size = MediaQuery.of(context).size;
    return 
    Container(
    alignment: Alignment.center,
    child:     
    Column(children: [
      Container(        
        child: Column(
          children: [            
            CalendarModal(),            
          ],
        ),
      )               
    ],)
    );
  }    

  
}