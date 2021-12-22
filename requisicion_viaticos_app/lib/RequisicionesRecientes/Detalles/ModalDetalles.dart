import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/Components/Spinner.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Detalles/Metodos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Detalles/CardDetalles.dart';

class Detalles extends StatefulWidget {
  
  List<RequisicionesDetallesFormato> lstActivas;
  Detalles(this.lstActivas,{Key ? key}) : super(key: key);

  @override
  Detalles_ createState() => Detalles_();
}

class Detalles_ extends State<Detalles> {
     
  @override
  Widget build(BuildContext context) { 
    return Container(
      alignment: Alignment.topCenter,
      child:
      SingleChildScrollView(child: 
       Column(children: [
         SizedBox(height: 30,),
         Text('Detalles de requisiciones',style:TextStyle(fontSize: 18)),

         widget.lstActivas.length > 0 ?           
        Column(children: [for(var tmp in widget.lstActivas) DetallesCard(tmp,'Visualizar Factura')],)
        : Container(alignment:Alignment.topCenter ,child: Column(children: [SizedBox(height: MediaQuery.of(context).size.width * 0.5,) ,Text('No se ha adjuntado ninguna factura al detalle.',style:TextStyle(fontSize: 17))],))             
         
      ],),)
    );
  }

  
}