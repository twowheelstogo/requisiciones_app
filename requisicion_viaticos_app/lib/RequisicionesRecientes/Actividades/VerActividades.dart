import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/Components/Spinner.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Actividades/EventCard.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Actividades/Metodos.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Metodos.dart';
import 'package:shared_preferences/shared_preferences.dart';


class VerActividades extends StatefulWidget {

  RequisicionesFormato historial;
  
  VerActividades(this.historial,{Key ? key}):super(key:key);

  @override
  VerActividades_ createState() => VerActividades_();
}

class VerActividades_ extends State<VerActividades> {    
  String DPI = "";
  List<ActividadesDetalles> lstActivas = [];

   VerActividades_()
  {
        getConstant("DPI").then((val) => setState(() {
          DPI = val;
          Activas().then((val2) => setState(() {
          lstActivas = val2;                        
          }));          
        }));              
        }

   Future< List<ActividadesDetalles> > Activas() async
  {
    showDialog(context: context, builder: (_)=>Spinner(),barrierDismissible: false);
    List<ActividadesDetalles> lst = [];
    lst = await ObtenerAgenciasSucursal().ObtenerActividades_(widget.historial.ID);
    Navigator.of(context).pop(true);     
    return lst;
  }

  
  Future<String> getConstant(String msg) async {
    final prefs = await SharedPreferences.getInstance();
    String DPI = '';
    final res = prefs.getString(msg);
    DPI = '$res';
    return DPI;
  }

  void initState() {    
    VerActividades_();
    super.initState();
  }

          
  @override
  Widget build(BuildContext context) {
    return  Column(children: [
      SizedBox(height: 40,),
      Text('Actividades',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
      SizedBox(height: 20,),
      lstActivas.length > 0 ?           
        Column(children: [for(var tmp in lstActivas) ActividadesCard(tmp.Fecha,tmp.ID_AIRTABLE,tmp)],)
        : Container(alignment:Alignment.topCenter ,child: Column(children: [SizedBox(height: MediaQuery.of(context).size.width * 0.5,) ,Text('Sin actividades.',style:TextStyle(fontSize: 17))],))  
                 
    ],);
  }

}