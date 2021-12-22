import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/Components/Spinner.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Detalles/Metodos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Detalles/CardDetalles.dart';

class Detalles extends StatefulWidget {
  
  List<RequisicionesDetallesFormato> lstActivas;
  String ID;
  Detalles(this.lstActivas,this.ID,{Key ? key}) : super(key: key);

  @override
  Detalles_ createState() => Detalles_();
}

class Detalles_ extends State<Detalles> {

  List<RequisicionesDetallesFormato> ListaFiltra(){
    List<RequisicionesDetallesFormato> newLst = widget.lstActivas
        .where((o) => o.ID.contains(widget.ID))
        .toList();            
    return newLst;
  }  
     
  @override
  Widget build(BuildContext context) { 
    return Container(
      alignment: Alignment.topCenter,
      child:
      SingleChildScrollView(child: 
       Column(children: [
         SizedBox(height: 30,),
         Text('Detalles de requisiciones',style:TextStyle(fontSize: 18)),

         ListaFiltra().length > 0 ?           
        Column(children: [for(var tmp in ListaFiltra()) DetallesCard(tmp,'Visualizar Factura')],)
        : Container(
          width: MediaQuery.of(context).size.width * 0.8
          ,alignment:Alignment.bottomCenter ,child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [SizedBox(height: MediaQuery.of(context).size.width * 0.5,) ,Text('No se ha adjuntado ninguna factura al detalle de requisición.',style:TextStyle(fontSize: 17)),SizedBox(height: 50,)],))             
        ,Container(
        alignment: Alignment.center,
        child: FlatButton(child: Text('Salir',style: TextStyle(fontSize: 17),),onPressed: (){Navigator.pop(context);},),
      )
      ],),)
    );
  }

  
}