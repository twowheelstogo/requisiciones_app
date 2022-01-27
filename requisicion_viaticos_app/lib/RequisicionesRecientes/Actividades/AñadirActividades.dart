import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:requisicion_viaticos_app/Components/Spinner.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Actividades/Metodos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddActividades extends StatefulWidget {
  const AddActividades({Key? key}) : super(key: key);
  AddActividades_ createState() => AddActividades_();
}

class AddActividades_ extends State<AddActividades> {

  String Origen = "",Destino = "", Actividad = "", Kilometros = "",Pasaje = "",LecturaInicial = "",LecturaFinal = "";
  TextEditingController _date_ = TextEditingController();    
  DateTime _dateTime = DateTime.now();  
  Map<String,String> Diccionario = {};  
  List<String> Agencias = [];  
  String ID_AIRTABLE = "";

  AddActividades_ (){
          getConstant("IdAIRTABLE").then((val) => setState(() {
          ID_AIRTABLE = val;          

          ObtenerAgencias().then((val2) => setState(() {            
            Agencias = val2[0];
            Diccionario=val2[1];                                                          
            }));
        }));    
  }

    void initState() {    
    AddActividades_();
    super.initState();
  }

  
     Future<String> getConstant(String msg) async {
    final prefs = await SharedPreferences.getInstance();
    String DPI = '';
    final res = prefs.getString(msg);
    DPI = '$res';
    return DPI;
  }


  Future<List> ObtenerAgencias() async {
        showDialog(
        context: context,
        builder: (context) => Spinner(),
        barrierDismissible: false);
    
    final lst = await ObtenerAgenciasSucursal().Agencias();             
     Navigator.of(context).pop(true);              
    return lst;
}

  Future<void> CrearDetalles(context,String Origen,String  Destino,String Actividad,String Kilometros,String Pasaje,String LecturaInicial,String LecturaFinal) async{
    if(Origen.length > 0 && Destino.length > 0 &&   Actividad.length > 0 &&  Kilometros.length > 0 && Pasaje.length > 0 && LecturaInicial.length > 0 && LecturaFinal.length > 0 && _dateTime != null)
    {
        showDialog(context: context, builder: (_)=>Spinner(),barrierDismissible: false);
    final Response = await ObtenerAgenciasSucursal().crearDetalles(Origen, Destino, Actividad, double.parse(Kilometros), double.parse(Pasaje), LecturaInicial, LecturaFinal, ID_AIRTABLE);        
    if(Response.statusCode == 200)
    {
        Navigator.of(context).pop(true);  
        Navigator.pop(context);
        final _snackbar = SnackBar(content: Text('Detalles agregrados exitosamente.'));        
        ScaffoldMessenger.of(context).showSnackBar(_snackbar);  
    }
    else{
        showToast('Ha ocurrido un error, intente de nuevo.');
        Navigator.of(context).pop(true);  
    }
    
    }
    else{
      showToast('Debe de ingresar todos los campos.');    
    }
  }

   void showToast(String mensaje) => Fluttertoast.showToast(
    msg: mensaje,
    fontSize: 16,
  );

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2101));
        
        if (picked != null && picked != _dateTime)
          setState(() {
            _dateTime = picked;
            _date_.text = DateFormat("yyyy-MM-dd").format(picked);          
          });
    }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: 
    Column(children: [
      SizedBox(height: 30,),      
      Container(child: Text('Ingrese actividades',style: TextStyle(fontSize: 18),),),
      SizedBox(height: 30,),      
      MostrarFecha('Seleccione fecha de actividad',context,_date_),      
      inputTextField(Origen,'Ingrese lugar de origen'),
      SizedBox(height: 18,),
      inputTextField(Destino,'Ingrese lugar de destino'),
      SizedBox(height: 18,),
      inputTextField(Actividad,'Ingrese actividad realizada'),
      inputTextField(LecturaInicial,'Lectura de odometro inicial'),
      SizedBox(height: 18,),
      inputTextField(LecturaFinal,'Lectura de odometro final'),
      SizedBox(height: 18,),
      inputTextField(Kilometros,'Kilometros recorridos'),
      SizedBox(height: 18,),
      inputTextField(Pasaje,'Pasaje utilizado'),
      SizedBox(height: 30,),
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(onPressed: () async{
              await CrearDetalles(context,Origen,Destino, Actividad, Kilometros,Pasaje,LecturaInicial,LecturaFinal);
              }, child: Text('Guardar',style: TextStyle(fontSize: 17),)),            
            FlatButton(onPressed: () {Navigator.pop(context);}, child: Text('Cancelar',style: TextStyle(fontSize: 17),)),            
          ],
        )  
    ],      
    ),);
  }

   Widget MostrarFecha(String Label,context,TextEditingController controlador)
  {
    return 
    Container(
    child:            
    Column(children: [                      
            Container( alignment: Alignment.topLeft,height: 19,width: MediaQuery.of(context).size.width * 0.9,
              child: Text(Label,style: TextStyle(fontSize: 15,color: Colors.black),textAlign: TextAlign.left,),),      
                FechaFactura(context,controlador), 
                SizedBox(height: 35,),              
    ],) );
  }
  

  Widget FechaFactura(context,TextEditingController controlador)
  {
    return Container(
            width: MediaQuery.of(context).size.width * 0.9,
          child:                                             
          TextField(
              onTap: () async {
                     
                    await _selectDate(context);                    
                  }, 
                  style: TextStyle(color: Colors.black),                              
              controller: controlador,
              readOnly: true,
            ) 
        );
  }

   Widget inputTextField(String variable,String mensaje){
    return 
     Container(
      alignment: Alignment.center,width: MediaQuery.of(context).size.width * 0.9,
      child:     
    TextFormField(
     style: TextStyle(color: Colors.black),
     cursorColor: Colors.black,
      keyboardType:TextInputType.text,     
        onChanged: (value){
          setState(() {
            variable =value;
          });
        },
        decoration: InputDecoration(            
            labelText: mensaje,
            labelStyle: Theme.of(context).textTheme.bodyText2,
            //border: OutlineInputBorder()
        ))
      );
  }

}
