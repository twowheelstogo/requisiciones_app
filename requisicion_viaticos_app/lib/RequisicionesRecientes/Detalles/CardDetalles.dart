import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Detalles/Imagenes.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Detalles/Metodos.dart';

class DetallesCard extends StatelessWidget {
  
  RequisicionesDetallesFormato historial;
  String Mensaje;
  DetallesCard(this.historial ,this.Mensaje,{Key ? key}):super(key:key);
        
  @override
  Widget build(BuildContext context) {      
    return Card(    
        shape: RoundedRectangleBorder(
    side: BorderSide(color: Colors.blue.shade400, width: 5),
    borderRadius: BorderRadius.circular(10),
  ),  
    margin: EdgeInsets.all(15),    
    elevation: 10,
    child: Column(
      children: <Widget>[
        
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),          
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Text(
                  "Fecha factura: "+DateFormat("yyyy-MM-dd").format(DateTime.parse(historial.Fecha)).toString()
                  ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                  SizedBox(height: 20,),
                Text(
                  "Monto factura: Q "+ double.parse(historial.MONTO).toString()
                  ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                  SizedBox(height: 20,),
                Text(
                  "Tipo gasto: "+historial.TIPO_GASTO
                  ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                  SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center
                  ,children: [
                  for(var tmp in historial.FOTO_FACTURA) 
                FlatButton(onPressed: () {VisualizaImagen(context,tmp["url"]);}, child: Column(children: [
                  Text(Mensaje),Icon( Icons.photo)
                ],))  
                ],),
                SizedBox(height: 25,),
              ],
            ),)
      ])                                    
  );
  }

  void VisualizaImagen(context,String url){
    showModalBottomSheet(context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
          builder: (context) {
      return Imagenes(url);
    });
  }


  
    

}
