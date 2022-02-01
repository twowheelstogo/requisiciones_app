import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:requisicion_viaticos_app/Components/Spinner.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Actividades/Metodos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddActividades extends StatefulWidget {
  final String ID;
  final ActividadesDetalles lstActivas;
  const AddActividades(this.ID,this.lstActivas,{Key? key}) : super(key: key);
  AddActividades_ createState() => AddActividades_();
}

class AddActividades_ extends State<AddActividades> {
  TextEditingController Origen = TextEditingController();
  String Destino = "";
  String Actividad = "";
  TextEditingController Kilometros = TextEditingController();
  TextEditingController LecturaInicial = TextEditingController();
  TextEditingController LecturaFinal = TextEditingController();  
  TextEditingController _date_ = TextEditingController();    
  DateTime _dateTime = DateTime.now();    
  List<String> Agencias = [];  
  String ID_AIRTABLE = "",ID = "";  
  int _radioValue = -1;     
  late TextEditingController? Destino_ ;
  List<DropdownMenuItem<String>> _dropDownMenuItems = [];  
  List actividades_ =
  ["Seleccione actividad realizada","Traslado de equipo por cierre","Evento especial","Instalación de equipo de computo","Mantenimiento de equipo de computo"]; 

  AddActividades_ (){
          
          getConstant("IdAIRTABLE").then((val) => setState(() {
          ID = val;                      

          getConstantList('Lista Agencias').then((val3) => setState(() {            
            Agencias = val3;                                                       
            }));
        }));    
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String city in actividades_) {
      items.add(new DropdownMenuItem(
          value: city,
          child: new Text(city)
      ));
    }
    return items;
  }  

  void _handleRadioValueChange(int value) {   
    setState(() {
      _radioValue = value;    
    });
  }

  void changedDropDownItem(String selectedActivity) {
    setState(() {
      Actividad = selectedActivity;
    });
  }

    void initState() {    
    AddActividades_();
    _dropDownMenuItems = getDropDownMenuItems();    
    _date_.text = widget.lstActivas.Fecha;
    Origen.text = widget.lstActivas.LUGAR_ORIGEN;  
    Destino_ = TextEditingController(text: widget.lstActivas.LUGAR_DESTINO);    
    Actividad = widget.lstActivas.ACTIVIDAD_REALIZADA.length == 0 ? _dropDownMenuItems[0].value.toString() : widget.lstActivas.ACTIVIDAD_REALIZADA;
    LecturaInicial.text = widget.lstActivas.LECTURA_ODOMETRO_INICIAL;
    LecturaFinal.text = widget.lstActivas.LECTURA_ODOMETRO_FINAL;
    Kilometros.text = widget.lstActivas.KILOMETROS_RECORRIDOS;    
    ID_AIRTABLE = widget.lstActivas.LUGAR_DESTINO;
    _radioValue = widget.lstActivas.PEAJES == 'vas' ? 0 : widget.lstActivas.PEAJES == 'Palin-Escuintla' ? 1 : -1;        
    super.initState();
  }  
     Future<String> getConstant(String msg) async {
    final prefs = await SharedPreferences.getInstance();
    String DPI = '';
    final res = prefs.getString(msg);
    DPI = '$res';
    return DPI;
  }

  Future<List<String>> getConstantList(String msg) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> DPI = [];
    DPI = prefs.getStringList(msg)!;    
    return DPI;
  }

  Future<void> CrearDetalles(context,String Origen,String  Destino,String Actividad,String Kilometros,String Pasaje,String LecturaInicial,String LecturaFinal) async{
    print('ORIGEN: ${Origen} || DESTINO: ${Destino} || Actividad: ${Actividad} || Km: ${Kilometros.length} || Pasaje: ${Pasaje} || Lectura Inicial: ${LecturaInicial} || Lectura Final: ${LecturaFinal}');
    if(Origen.length > 0 && Destino.length > 0 &&  ( Actividad.length > 0 && Actividad != 'Seleccione actividad realizada') &&  Kilometros.length > 0 && _radioValue >= 0 && LecturaInicial.length > 0 && LecturaFinal.length > 0)
    {
    showDialog(context: context, builder: (_)=>Spinner(),barrierDismissible: false);
    final Response = await ObtenerAgenciasSucursal().crearDetalles(Origen, Destino, Actividad, double.parse(Kilometros),Pasaje, LecturaInicial, LecturaFinal, widget.ID);        
    if(Response.statusCode == 200)
    {
        Navigator.of(context).pop(true);          
        Navigator.pop(context);     
        showToast('Detalles agregrados exitosamente.');                         
    }
    else{
        Navigator.of(context).pop(true);  
        showToast('Ha ocurrido un error, intente de nuevo.');        
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
      SizedBox(height: 50,),      
      Container(child: Text('Ingrese actividades',style: TextStyle(fontSize: 18),),),
      SizedBox(height: 30,),      
      MostrarFecha('Fecha de actividad',context,_date_),      
      TextFieldDinamico__(Origen,'Ingrese lugar de origen'),
      SizedBox(height: 30,),
        AutoComplete_(),            
      SizedBox(height: 18,),
       Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: new DropdownButton(                 
                value: Actividad,                
                items: _dropDownMenuItems,
                style: TextStyle(fontSize: 14,color: Colors.black),
                onChanged: (value) {changedDropDownItem(value.toString());},
              ),),  
      TextFieldDinamico__(LecturaInicial,'Lectura de odometro inicial'),
      SizedBox(height: 18,),
      TextFieldDinamico__(LecturaFinal,'Lectura de odometro final'),
      SizedBox(height: 18,),
      TextFieldMonto(),
      SizedBox(height: 20,),
      Container( alignment: Alignment.topLeft,height: 19,
      width: MediaQuery.of(context).size.width * 0.9,
        child: 
        Text('Seleccione peaje',style: TextStyle(fontSize: 14,color: Colors.black),textAlign: TextAlign.left,),),                      
      ListTitle_(),
      SizedBox(height: 30,),
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(onPressed: () async{
              await CrearDetalles(context,Origen.text,Destino, Actividad, Kilometros.text,_radioValue == 0 ? 'vas' : 'Palin-Escuintla',LecturaInicial.text,LecturaFinal.text);
              }, child: Text('Guardar',style: TextStyle(fontSize: 17),)),            
            FlatButton(onPressed: () {Navigator.pop(context);}, child: Text('Cancelar',style: TextStyle(fontSize: 17),)),            
          ],
        )  
    ],      
    ),);
  }

  Widget TextFieldMonto()
  {
     return 
     Column(children: [
     Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text('Ingrese Kilometros recorridos',style: TextStyle(fontSize: 15,color: Colors.black),textAlign: TextAlign.left,),),                                    
               Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(                      
                    controller: Kilometros,
                    style: TextStyle(color: Colors.black),   
                    inputFormatters: [
              ThousandsFormatter(allowFraction: true)
                ],
              keyboardType: TextInputType.number,       
                  )             
            )],);
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
            enabled: false, 
              onTap: () async {
                     
                    await _selectDate(context);                    
                  }, 
                  style: TextStyle(color: Colors.black),                              
              controller: controlador,
              readOnly: true,
            ) 
        );
  }

  Widget AutoComplete_()
  {
    return Container(
     alignment: Alignment.center,width: MediaQuery.of(context).size.width * 0.9,
     child: Column(children: [
       Container( alignment: Alignment.topLeft,height: 19,
        child: 
        Text('Ingrese lugar de destino',style: TextStyle(fontSize: 14,color: Colors.black),textAlign: TextAlign.left,),),                
         Autocomplete(                      
              optionsBuilder: (Destino_) {                
                if (Destino_.text == '') {
                  return const Iterable<String>.empty();
                }else{
                    List<String> matches = <String>[];
                    matches.addAll(Agencias);
                    matches.retainWhere((s){
                      return s.toLowerCase().contains(Destino_.text.toLowerCase());
                    });
                    return matches;
                }
              },
              onSelected: (String selection) {
                  setState(() {
                    Destino = selection;
                  });                  
              },
            ),
     ],), 
    );
  }

     Widget TextFieldDinamico__(
      TextEditingController controlador, String Label) {
    return SingleChildScrollView(child: 
    Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child:TextField(
      controller: controlador,
      decoration: InputDecoration(                    
                      labelText:Label,                     
                      labelStyle: TextStyle(fontSize: 14,color: Colors.black),                                    
                ),    
     ) ),);
  } 

  Widget ListTitle_()
  {
     return   new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: (value) {
                            _handleRadioValueChange(int.parse(value.toString()));
                          },
                        ),
                        new Text(
                          'vas',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Radio(
                          value: 1,
                         groupValue: _radioValue,
                          onChanged: (value) {
                            _handleRadioValueChange(int.parse(value.toString()));
                          },
                        ),
                        new Text(
                          'Palin-Escuintla',
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),                      
                      ],
                    );
      
  }

}
