import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Actividades/A%C3%B1adirActividades.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Actividades/Metodos.dart';

class ActividadesCard extends StatelessWidget {
  
  String Fecha;  
  String ID;
  ActividadesDetalles lstActivas;

  ActividadesCard(@required this.Fecha,@required this.ID,@required this.lstActivas,{Key ? key}):super(key:key);  
   
  @override
  Widget build(BuildContext context) {

    void openCalendar(){
    showModalBottomSheet(context: context,
           isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
          builder: (context) {
      return  FractionallySizedBox(
        heightFactor: 1,
        child: AddActividades(ID,lstActivas)
      );            
    });
  }  
  
    return Padding(
      padding: const EdgeInsets.only(bottom:5,top:5),
      child: Container(                
        padding: EdgeInsets.all(6),
        width:  MediaQuery.of(context).size.width * 0.95,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          color: Colors.black
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [                
                Text("Fecha: ${DateFormat("yyyy-MM-dd").format(DateTime.parse(this.Fecha))}",style: TextStyle(color: Colors.white)),                
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [                
                Row(children: [
                  IconButton(onPressed: () {  openCalendar();}, icon: Icon(Icons.create_rounded,color: Colors.white))  ,                                                 
                ],)                
              ],
            ),             
          ],
        ),
      ),
    );
  }
  
}
