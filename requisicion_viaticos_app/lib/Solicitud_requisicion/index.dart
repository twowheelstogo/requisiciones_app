import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:requisicion_viaticos_app/Solicitud_requisicion/CreateRequisicionModal.dart';
import 'package:requisicion_viaticos_app/VisualizarRequisiciones/index.dart';


class Solicitud extends StatefulWidget {
    
  final Map<String,String> Diccionario;  
  final List<String> Agencias;  
  final String Desayuno,Almuerzo,Cena,Gasolina_super,Gasolina_diesel,Gasolina_regular,Hospedaje;
  const Solicitud(this.Diccionario,this.Agencias,this.Desayuno,this.Almuerzo,this.Cena,this.Gasolina_super,this.Gasolina_diesel,this.Gasolina_regular,this.Hospedaje,{Key? key}) : super(key: key);
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
            CalendarModal(widget.Diccionario,widget.Agencias,widget.Desayuno,widget.Almuerzo,widget.Cena,widget.Gasolina_diesel,widget.Gasolina_super,widget.Gasolina_regular,widget.Hospedaje),            
          ],
        ),
      )               
    ],)
    );
  }    

  
}