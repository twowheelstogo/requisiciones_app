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
    final String Desayuno,Almuerzo,Cena,Gasolina_diesel,Gasolina_super,Gasolina_regular,Hospedaje,Costo_Vas,Costo_Pralin;
  
  const CalendarModal(this.Diccionario,this.Agencias,this.Desayuno,this.Almuerzo,this.Cena,this.Gasolina_diesel,this.Gasolina_super,this.Gasolina_regular,this.Hospedaje,this.Costo_Vas,this.Costo_Pralin,{Key ? key}) : super(key: key);
  
  @override
  _CalendarModalState createState() => _CalendarModalState();
}

class _CalendarModalState extends State<CalendarModal> {
  
  DateRangePickerSelectionMode _selectionMode =
      DateRangePickerSelectionMode.multiRange;
  DateRangePickerController _controller = DateRangePickerController();
  
  String ID_USUARIO = "";
  String ID_USUARIO2 = "";
  String Hospedaje = "",Desayuno= "",Almuerzo = "",Cena = "", Gasolina = "";
  double precioGasolina = 0;
  bool _selected = false;
  bool bandera_hospedaje = false, bandera_gasolina = false, bandera_comida = false;
  TextEditingController Monto = TextEditingController();    
  int _radioValue = -1;    
  List ArrayDates = [];
  var _suggestionTextFieldControler = new TextEditingController();
  String dropdownvalue = 'Seleccione una opción';   
  String ID_AIRTABLE = "";  
  String TipoGasolina = "";
  
   @override
  void initState() {      
    _CalendarModalState();
      Monto.text = "0";
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

   void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
        setState(() {
           precioGasolina = double.parse(widget.Gasolina_regular); 
        TipoGasolina = "REGULAR";
        });               
          break;
        case 1:
        setState(() {
              precioGasolina = double.parse(widget.Gasolina_super);                  
        TipoGasolina = "SUPER";  
        });          
          break;
        case 2:
        setState(() {
           precioGasolina = double.parse(widget.Gasolina_diesel);          
        TipoGasolina = "DIESEL";
        });               
          break;
      }
    });
  }
   
  void CrearRequisicionViaticos() async{
    
    if(!bandera_gasolina && !bandera_hospedaje && !bandera_comida)
    {
      final _snackbar = SnackBar(content: Text('Debe de seleccionar los gastos que necesite.'));
      ScaffoldMessenger.of(context).showSnackBar(_snackbar);
    }
    else{
    
    bool bandera = !bandera_gasolina ? true : (bandera_gasolina && precioGasolina > 0 && Monto.text != "0") ? true : false;    
    
    if(ArrayDates.length > 0 && ID_AIRTABLE.length > 0 && bandera)
    {
    showDialog(context: context, builder: (_)=>Spinner(),barrierDismissible: false);  
    final Res = await ListadoAgencias().crearTarifario();
    final Decoded = json.decode(Res.body);

    if(Res.statusCode == 200)
    {        
    ArrayDates.sort((a,b) {
    return a.compareTo(b);
    });

    String _initDate = ArrayDates[0];
    int total = ArrayDates.length > 0 ? ArrayDates.length - 1 : 0;
    String _endDate = ArrayDates[total];

    final Response = await ListadoAgencias().crearRequisicion(_initDate, _endDate,0,ID_AIRTABLE,ID_USUARIO2,Decoded["records"][0]["fields"]["ID"],
    widget.Desayuno,widget.Almuerzo,widget.Cena,precioGasolina.toString(),widget.Hospedaje,
    bandera_comida,bandera_gasolina,bandera_hospedaje, Monto.text,ArrayDates.length
    );  
    Navigator.of(context).pop(true);

    if(Response.statusCode == 200)
    {
      if(bandera_gasolina)
      {
        final Lista = Response.body;
      final Decoded = json.decode(Lista);
      bool Response3 = await ListadoAgencias().RegistrosActividades(ArrayDates,TipoGasolina,Decoded["records"][0]["id"].toString(),ID_AIRTABLE,double.parse(Monto.text));
      if(Response3)
      {
        final _snackbar = SnackBar(content: Text('Requisición generada exitosamente.'));                  
         ScaffoldMessenger.of(context).showSnackBar(_snackbar);
         Monto.clear();
         _initDate = "";
         _endDate = "";         
         ID_AIRTABLE = "";
          ID_AIRTABLE = "";         
         bandera_comida = false;
         bandera_hospedaje = false;
         bandera_gasolina = false;
        setState(() { });
      }
      else
      {
        final _snackbar = SnackBar(content: Text('Ha ocurrido un error, intente nuevamente 1.'));
         ScaffoldMessenger.of(context).showSnackBar(_snackbar);
      } 
      }
      else
      {
        final _snackbar = SnackBar(content: Text('Requisición generada exitosamente.'));                  
         ScaffoldMessenger.of(context).showSnackBar(_snackbar);
         Monto.clear();
         _initDate = "";
         _endDate = "";         
         ID_AIRTABLE = "";         
         bandera_comida = false;
         bandera_hospedaje = false;
         bandera_gasolina = false;
        setState(() { });
      }
             
    }        
    else
  {
        final _snackbar = SnackBar(content: Text('Ha ocurrido un error, intente nuevamente 2.'));
         ScaffoldMessenger.of(context).showSnackBar(_snackbar);
  }
    }

      else
  {
        Navigator.of(context).pop(true);
        final _snackbar = SnackBar(content: Text('Ha ocurrido un error, intente nuevamente 3.'));
         ScaffoldMessenger.of(context).showSnackBar(_snackbar);
  }

    }    
    else{
      final _snackbar = SnackBar(content: Text('Debe de ingresar todos los campos 4.'));
         ScaffoldMessenger.of(context).showSnackBar(_snackbar);
    }
    }    
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {    
    ArrayDates.clear();
    for(int i =0; i < args.value.length;i++){
      ArrayDates.add(args.value[i].toString());
    }    
    setState(() {      
    });    
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
            
            SizedBox(height: 30),
            // 1 comida, 2 hospedaje, 3 gasolina
            Text('Seleccione los gastos que necesite que se le proporcione'),          
            new Divider(height: 5.0, color: Colors.black),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:
            Container(
            padding: EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Row(children: [
                    Text('Comida'),CheckBox_(1)
                ],),

              Row(children: [
                    Text('Hospedaje'),CheckBox_(2)
                ]),

              Row(children: [
                    Text('Gasolina'),CheckBox_(3)
                ]),
              ],
            )),),

            bandera_gasolina ?         
            Column(                            
              children: [
              SizedBox(height: 20,),
              Text('Seleccione tipo de gasolina'),
              new Divider(height: 5.0, color: Colors.black),
//              SizedBox(height: 20,),
              Container(padding: EdgeInsets.all(25.0), child: 
              ListTitle_(),),
              SizedBox(height: 20,),
            Container( alignment: Alignment.topLeft,height: 19,
              child: Text('Ingrese km proyectados',style: TextStyle(fontSize: 15,color: Colors.black),textAlign: TextAlign.left,),),
              Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(                      
                    controller: Monto,
                    style: TextStyle(color: Colors.black),   
                    inputFormatters: [
              ThousandsFormatter(allowFraction: true)
                ],
              keyboardType: TextInputType.number,       
                  )
                  ),
            ],)          
             : Container(),
              SizedBox(height: 30),
              
          Text('Seleccione las fechas de requisición',style: TextStyle(fontSize: 13,color: Colors.black),                                    ),
          Divider(height: 20,  thickness: 1,color: Colors.grey),
          SfDateRangePicker(
            onSelectionChanged: _onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.multiple,
          ), 
          SizedBox(height: 20),
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
  Widget ListTitle_()
  {
     return   new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: (value) {
                            _handleRadioValueChange(int.parse(value.toString()));
                          },
                        ),
                        new Text(
                          'Regular',
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
                          'Super',
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        new Radio(
                          value: 2,
                          groupValue: _radioValue,
                          onChanged: (value) {
                            _handleRadioValueChange(int.parse(value.toString()));
                          },
                        ),
                        new Text(
                          'Diesel',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    );
      
  }
  Widget CheckBox_(int opcion){
      // 1 comida, 2 hospedaje, 3 gasolina
      return Checkbox(
      checkColor: Colors.white,      
      value: opcion == 1 ? bandera_comida : opcion == 2 ? bandera_hospedaje : bandera_gasolina,
      onChanged: (bool? value) {
        setState(() {
          opcion == 1 ? bandera_comida = value! : opcion == 2 ? bandera_hospedaje = value! : bandera_gasolina = value!;          
        });
      },
    );  
  }
}
