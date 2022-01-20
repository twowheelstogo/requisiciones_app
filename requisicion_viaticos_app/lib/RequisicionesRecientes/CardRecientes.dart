import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Facturas/Switch.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Metodos.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Detalles/ModalDetalles.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Facturas/ModalFacturas.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Detalles/Metodos.dart';

class PermisosRecientesRequestCard extends StatelessWidget {
  
  RequisicionesFormato historial;
  List<RequisicionesDetallesFormato> lstActivas;
  PermisosRecientesRequestCard(this.historial,this.lstActivas,{Key ? key}):super(key:key);
          
  @override
  Widget build(BuildContext context) {
    
  void openDetalles(String ID){
    showModalBottomSheet(context: context,
        isScrollControlled: true,
          builder: (context) {
      return 
      FractionallySizedBox(
        heightFactor: 0.9,
        child: Detalles(lstActivas,ID)
      );      
    });
  }

  void openFacturas(){
    showModalBottomSheet(context: context,
        isScrollControlled: true,
          builder: (context) {
      return 
      FractionallySizedBox(
        heightFactor: 1,
        child: Switch_(historial)
        //Facturas(historial)
      );      
    });
  }  

    return 
    Card(          
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
                SizedBox(height: 10,),
                Text('Región: ' +  historial.Agencias.toLowerCase(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),  SizedBox(height: 5,),
                Text('Inicio viaje: ' + DateFormat("yyyy-MM-dd").format(DateTime.parse(historial.Inicio)),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500)),
                SizedBox(height: 5,),
                Text('Fin viaje: ' + DateFormat("yyyy-MM-dd").format(DateTime.parse(historial.Fin)),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500)), SizedBox(height: 5,),
                Text('Monto víaticos: Q ' + double.parse(historial.Monto).toString() ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500)),SizedBox(height: 5,),                
                Text('Liquidado: Q ' + historial.LIQUIDADO.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                SizedBox(height: 3,),   
                 Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(onPressed: () {openDetalles(historial.ID_Tarifario);}, child: Text('Ver Detalles',style: TextStyle(decoration: TextDecoration.underline,decorationStyle: TextDecorationStyle.solid),)),
            FlatButton(onPressed: () {openFacturas();}, child: Text('Añadir facturas',style: TextStyle(decoration: TextDecoration.underline,decorationStyle: TextDecorationStyle.solid),)),            
          ],
        )                                                 
              ],
            ),)
      ])                                    
  );
  }

    

}
