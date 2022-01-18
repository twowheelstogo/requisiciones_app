import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:requisicion_viaticos_app/VisualizarRequisiciones/index.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:requisicion_viaticos_app/Components/Spinner.dart';
import 'package:requisicion_viaticos_app/Solicitud_requisicion/Metodos.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/index.dart';
import 'dart:convert';

class CalendarModal extends StatefulWidget {
  
    final Map<String,String> Diccionario;  
    final List<String> Agencias;  
    final String Desayuno,Almuerzo,Cena,Gasolina,Hospedaje;
  

  const CalendarModal(this.Diccionario,this.Agencias,this.Desayuno,this.Almuerzo,this.Cena,this.Gasolina,this.Hospedaje,{Key ? key}) : super(key: key);
  
  @override
  _CalendarModalState createState() => _CalendarModalState();
}

class _CalendarModalState extends State<CalendarModal> {
  String _initDate ="";
  String _endDate ="";
  String selectedValue = "";
  String ID_USUARIO = "";
  String ID_USUARIO2 = "";
  String Hospedaje = "",Desayuno= "",Almuerzo = "",Cena = "", Gasolina = "";
  bool _selected = false;
  TextEditingController Monto = TextEditingController();
  
  var _suggestionTextFieldControler = new TextEditingController();

  String dropdownvalue = 'Seleccione una opción';   
  String ID_AIRTABLE = "";
  
   @override
  void initState() {      
    _CalendarModalState();
    super.initState();
  }
  

 Future<String> getConstant(String msg) async {
    final prefs = await SharedPreferences.getInstance();
    String DPI = '';
    final res = prefs.getString(msg);
    DPI = '$res';
    return DPI;
  }

  _CalendarModalState() {       
   getConstant("DPI").then((val) => setState(() {
        ID_USUARIO = val;             
        }));

  getConstant("IdAIRTABLE").then((val) => setState(() { 
        ID_USUARIO2 = val;             
        }));
  }  
 
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args){
    if(args.value is PickerDateRange){
      setState(() {
        _initDate = DateFormat("yyyy-MM-dd").format(args.value.startDate).toString();
        _endDate = DateFormat("yyyy-MM-dd").format(args.value.endDate??args.value.startDate).toString();
        _selected =true;
      });
    }
  }

  void CrearRequisicionViaticos() async{
    
    if(_initDate.length > 0 && _endDate.length > 0 && ID_AIRTABLE.length > 0)
    {
    showDialog(context: context, builder: (_)=>Spinner(),barrierDismissible: false);  
    final Res = await ListadoAgencias().crearTarifario();
    final Decoded = json.decode(Res.body);

    if(Res.statusCode == 200)
    {
    final Response = await ListadoAgencias().crearRequisicion(_initDate, _endDate,0,ID_AIRTABLE,ID_USUARIO2,Decoded["records"][0]["fields"]["ID"],
    widget.Desayuno,widget.Almuerzo,widget.Cena,widget.Gasolina,widget.Hospedaje 
    );  
    Navigator.of(context).pop(true);

    if(Response.statusCode == 200)
    {
         final _snackbar = SnackBar(content: Text('Requisición generada exitosamente.'));                  
         ScaffoldMessenger.of(context).showSnackBar(_snackbar);
         Monto.clear();
         _initDate = "";
         _endDate = "";         
         ID_AIRTABLE = "";
    }        
    else
  {
        final _snackbar = SnackBar(content: Text('Ha ocurrido un error, intente nuevamente.'));
         ScaffoldMessenger.of(context).showSnackBar(_snackbar);
  }
    }

      else
  {
        Navigator.of(context).pop(true);
        final _snackbar = SnackBar(content: Text('Ha ocurrido un error, intente nuevamente.'));
         ScaffoldMessenger.of(context).showSnackBar(_snackbar);
  }

    }    
    else{
      final _snackbar = SnackBar(content: Text('Debe de ingresar todos los campos.'));
         ScaffoldMessenger.of(context).showSnackBar(_snackbar);
    }
    
  }
  

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return     
    Container(
      padding: EdgeInsets.all(8),
      height: size.height*0.8,
      child:       
      SingleChildScrollView( child:
      Column(
        children: [                    
          ExpansionTile(title: Text("Generar nueva solicitud de requisición de víaticos",style: TextStyle(fontSize: 17),textAlign: TextAlign.center,),
          initiallyExpanded: true,
          children: [
              SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: 20,),
                Container( alignment: Alignment.topLeft,height: 19,
              child: Text('Ingrese región a visitar',style: TextStyle(fontSize: 15,color: Colors.black),textAlign: TextAlign.left,),),                
                Autocomplete(                      
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }else{
                    List<String> matches = <String>[];
                    matches.addAll(widget.Agencias);
                    matches.retainWhere((s){
                      return s.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                    return matches;
                }
              },
              onSelected: (String selection) {
                  setState(() {
                    ID_AIRTABLE = widget.Diccionario[selection].toString();
                  });
                  print(widget.Diccionario[selection].toString());
              },
            ),
            // SizedBox(height: 20,),
            // Container( alignment: Alignment.topLeft,height: 19,
            //   child: Text('Ingrese Monto de víaticos',style: TextStyle(fontSize: 15,color: Colors.black),textAlign: TextAlign.left,),),
            //   Container(
            //           width: MediaQuery.of(context).size.width * 0.9,
            //         child: TextFormField(                      
            //         controller: Monto,
            //         style: TextStyle(color: Colors.black),   
            //         inputFormatters: [
            //   ThousandsFormatter(allowFraction: true)
            //     ],
            //   keyboardType: TextInputType.number,       
            //       )
            //       ),
              SizedBox(height: 30),
              
          Text('Seleccione la fecha de inicio y de fin del viaje',style: TextStyle(fontSize: 13,color: Colors.black),                                    ),
          Divider(height: 20,  thickness: 1,color: Colors.grey),
          SfDateRangePicker(
            onSelectionChanged: _onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.range,
          ),            
          Requsion_('Crear nueva requisición',0,size,Colors.green),               
              ],),
            )                                
          ],),              
          SizedBox(height: 20,),    
          ExpansionTile(title: Text("Control de requisiciones de víacticos",style: TextStyle(fontSize: 17),textAlign: TextAlign.center,),
          children: [            
          Requsion_('Ir a historial de requisiciones',1,size,Colors.black),
          Requsion_('Ir a requisiciones de los ultimos 30 días',2,size,Colors.black)])
        ],
      ),)
    );
  }

  Widget Requsion_(String Mensajes, int opcion,final size,Color color_)
  {
    return  Container(                    
                            alignment: Alignment.center,                            
                            child: 
                            ButtonTheme(
                                  
                                  minWidth: MediaQuery.of(context).size.width * 0.9,          
                        child:    OutlineButton(                                      
                                 borderSide: BorderSide(color: color_,width: 1),                                                           
                                onPressed: ()  { 
                                    if(opcion == 0)
                                    {
                                        CrearRequisicionViaticos();
                                    }else if(opcion == 1){

                                      Navigator.push<void>(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) => VisualizarRequisiciones(widget.Diccionario,ID_USUARIO),
                                        ),
                                      );
                                    }
                                    else{
                                      Navigator.push<void>(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) => VisualizarRequisicionesRecientes(widget.Diccionario,ID_USUARIO),
                                        ),
                                      );
                                    }
                                 },
                                child: Text(
                                  Mensajes,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ))),
                          );
  }  
}