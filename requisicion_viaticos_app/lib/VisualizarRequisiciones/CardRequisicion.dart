import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:requisicion_viaticos_app/VisualizarRequisiciones/Metodos.dart';


class PermisosRequestCard extends StatelessWidget {
  
  Historial historial;
  PermisosRequestCard(this.historial ,{Key ? key}):super(key:key);
        

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
                Text('Región: ' +  historial.Agencias.toLowerCase(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),  SizedBox(height: 5,),
                Text('Inicio viaje: ' + DateFormat("yyyy-MM-dd").format(DateTime.parse(historial.Inicio)),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500)),                
                Text('Fin viaje: ' + DateFormat("yyyy-MM-dd").format(DateTime.parse(historial.Fin)),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500)), SizedBox(height: 5,),
                Text('Monto víaticos: Q ' + double.parse(historial.Monto).toStringAsFixed(2) ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500)),SizedBox(height: 5,),                
                Text('Depreciacion: Q ' + double.parse(historial.Depreciacion.toString()).toStringAsFixed(2),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                SizedBox(height:10,), 
                statusComp("${historial.Status}"),                
                SizedBox(height: 15,),                                    
              ],
            ),)
      ])                                    
  );
  }
  
  Widget statusComp(String value){

    return SizedBox(
      width: 150,
      child: Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: colorState(value, 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(2),
          child: Text(value.toLowerCase(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }

  Color colorState(String value, double opacity){
    switch (value) {
      case 'APROBADA':
        return Color.fromRGBO(17, 229, 66, opacity);
      case 'PENDIENTE':
        return Color.fromRGBO(249, 43, 30, opacity);
      default:
        return Color.fromRGBO(86, 86, 86, opacity);
    }
  }


}
