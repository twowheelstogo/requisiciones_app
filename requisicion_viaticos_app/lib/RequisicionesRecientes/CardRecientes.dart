import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Metodos.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/ModalDetalles.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/ModalFacturas.dart';


class PermisosRecientesRequestCard extends StatelessWidget {
  
  RequisicionesFormato historial;
  PermisosRecientesRequestCard(this.historial ,{Key ? key}):super(key:key);
        

  @override
  Widget build(BuildContext context) {
    
  void openDetalles(){
    showModalBottomSheet(context: context,
        //    isScrollControlled: true,
        // isDismissible: false,
        // enableDrag: false,
          builder: (context) {
      return Detalles();
    });
  }

  void openFacturas(){
    showModalBottomSheet(context: context,
        //    isScrollControlled: true,
        // isDismissible: false,
        // enableDrag: false,
          builder: (context) {
      return Facturas();
    });
  }

    return Card(    
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),    
    margin: EdgeInsets.all(15),    
    elevation: 10,
    child: Column(
      children: <Widget>[
        
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),          
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Inicio: ' + DateFormat("yyyy-MM-dd").format(DateTime.parse(historial.Inicio)),style: TextStyle(color: Colors.black)),
                SizedBox(height: 5,),
                Text('Fin: ' + DateFormat("yyyy-MM-dd").format(DateTime.parse(historial.Fin)),style: TextStyle(color: Colors.black)), SizedBox(height: 5,),
                Text('Monto: Q ' + double.parse(historial.Monto).toString() ,style: TextStyle(color: Colors.black)),SizedBox(height: 5,),
                Text('Agencia: ' +  historial.Agencias.toLowerCase(),style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),  SizedBox(height: 5,),
                Text('Status: ' + historial.Status.toLowerCase(),style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
                SizedBox(height: 3,),   
                 Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(onPressed: () {openFacturas();}, child: Text('Añadir facturas')),
            FlatButton(onPressed: () {openDetalles();}, child: Text('Ver Detalles'))
          ],
        )                                                 
              ],
            ),)
      ])                                    
  );
  }

    

}
