import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:requisicion_viaticos_app/Components/Spinner.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Actividades/A%C3%B1adirActividades.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Actividades/Metodos.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Actividades/VerActividades.dart';
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

  void openVerActividades(){
    showModalBottomSheet(context: context,
        isScrollControlled: true,
          builder: (context) {
      return 
      FractionallySizedBox(
        heightFactor: 0.9,
        child: VerActividades(this.historial)
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
                Text('Monto víaticos: Q ' + double.parse(historial.Monto).toStringAsFixed(2) ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500)),SizedBox(height: 5,),                
                Text('Depreciacion: Q ' + double.parse(historial.DEPRECIACION.toString()).toStringAsFixed(2),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                Text('Liquidado: Q ' + double.parse(historial.LIQUIDADO.toString()).toStringAsFixed(2),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),                                
                SizedBox(height: 5,),   
                 Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(onPressed: () {openDetalles(historial.ID_Tarifario);}, child: Text('Ver Facturas',style: TextStyle(decoration: TextDecoration.underline,decorationStyle: TextDecorationStyle.solid),)),
            FlatButton(onPressed: () {openFacturas();}, child: Text('Añadir facturas',style: TextStyle(decoration: TextDecoration.underline,decorationStyle: TextDecorationStyle.solid),)),                        
          ],
        ),                
                 Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(onPressed: () {openVerActividades();}, child: Text('Ver Actividades',style: TextStyle(decoration: TextDecoration.underline,decorationStyle: TextDecorationStyle.solid),)),            
            FlatButton(onPressed: () {Alerta(context);}, child: Text('Finalizar proceso',style: TextStyle(decoration: TextDecoration.underline,decorationStyle: TextDecorationStyle.solid),)),            
          ],
        )                                                                                                  
              ],
            ),)
      ])                                    
  );
  }

  void Alerta(context)
  {
     showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Confirmación de finalización",textAlign: TextAlign.center,
                  style: TextStyle(decoration: TextDecoration.underline,decorationStyle: TextDecorationStyle.solid),
                  ),
                  content: Text("¿Desea finalizar el proceso de requisición?",style: TextStyle(color: Colors.black,fontSize: 16),textAlign: TextAlign.center,),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,    
                      children: [
                        FlatButton(
                      onPressed: () async{
                        showDialog(context: context, builder: (_)=>Spinner(),barrierDismissible: false);                        
                        Navigator.of(ctx).pop();                        
                        final Response = await ObtenerAgenciasSucursal().FinalizarProceso(historial.ID);                 
                        if(Response.statusCode == 200)
                        {
                          Navigator.of(context).pop(true);          
                            Navigator.pop(context);     
                            showToast('Proceso finalizado exitosamente.');                         
                        }
                        else{
                      Navigator.of(context).pop(true);  
                      showToast('Ha ocurrido un error, intente de nuevo.');        
                    }    
                      },
                      child: Text("Finalizar",textAlign: TextAlign.start,),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("Cancelar",textAlign: TextAlign.center,),
                    ),
                      ],
                    )                    
                  ],
                ),);
  }


   void showToast(String mensaje) => Fluttertoast.showToast(
    msg: mensaje,
    fontSize: 16,
  );

    

}
