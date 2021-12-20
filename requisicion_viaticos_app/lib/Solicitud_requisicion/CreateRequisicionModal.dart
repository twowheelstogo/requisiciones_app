import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:requisicion_viaticos_app/VisualizarRequisiciones/index.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:requisicion_viaticos_app/Components/Spinner.dart';
import 'package:requisicion_viaticos_app/Solicitud_requisicion/Metodos.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class CalendarModal extends StatefulWidget {
  @override
  _CalendarModalState createState() => _CalendarModalState();
}

class _CalendarModalState extends State<CalendarModal> {
  String _initDate ="";
  String _endDate ="";
  String selectedValue = "";
  bool _selected = false;
  TextEditingController Monto = TextEditingController();
  List<String> Agencias = [];  
  Map<String,String> Diccionario = {};
  var _suggestionTextFieldControler = new TextEditingController();

  String dropdownvalue = 'Seleccione una opción';   
  String ID_AIRTABLE = "";
  
   @override
  void initState() {      
    _CalendarModalState();
    super.initState();
  }

  Future<List> ObtenerAgencias() async {
        showDialog(
        context: context,
        builder: (context) => Spinner(),
        barrierDismissible: false);
    
    final lst = await ListadoAgencias().Agencias();             
     Navigator.of(context).pop(true);      
        
    return lst;
}


Future<String> getDPI() async {    
    String DPI = '';    
    return DPI;
  }

  _CalendarModalState() {

   getDPI().then((val) => setState(() {
              ObtenerAgencias().then((val2) => setState(() {
          Agencias = val2[0];
          Diccionario = val2[1];          
        }));


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
          children: [
            Column(children: [                   
          //aqui va
            SingleChildScrollView(child: 
            AutoCompleteTextField(                        
            controller: _suggestionTextFieldControler,
            suggestions: Agencias,
            style: TextStyle(fontSize: 17),
            decoration: InputDecoration(              
              labelText: 'Ingrese agencia',                    
              labelStyle: TextStyle(fontSize: 15,color: Colors.black),     
            ),
            itemFilter: (item,query)
            {
              return item.toString().toLowerCase().startsWith(query.toLowerCase());
            },
            itemSorter: (a,b) {
              return a.toString().compareTo(b.toString());
            },
            itemSubmitted: (item) {
              _suggestionTextFieldControler.text = item.toString();   
              print('AQUIIIIIIIIII');
            },            
            itemBuilder: (context,item){
              return Container(
                padding: EdgeInsets.all(20),
                child: Row(children: [
                  Text(item.toString(),style: TextStyle(color: Colors.black),)
                ],),
              );
            },
            ),),
               Container(
            width: MediaQuery.of(context).size.width * 0.9,
          child: TextFormField(           
            decoration: InputDecoration(                    
            labelText: 'Ingrese Monto de víaticos',                     
            labelStyle: TextStyle(fontSize: 15,color: Colors.black),                                    
          ),
          controller: Monto,
          style: TextStyle(color: Colors.black),   
           inputFormatters: [
    ThousandsFormatter(allowFraction: true)
      ],
     keyboardType: TextInputType.number,       
        )),
            SizedBox(height: 40,),
            Text('Seleccione la fecha de inicio y de fin del viaje',style: TextStyle(fontSize: 13,color: Colors.black),                                    ),
          Divider(height: 20,  thickness: 1,color: Colors.grey),
          SfDateRangePicker(
            onSelectionChanged: _onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.range,
          ),            
          Requsion_('Crear nueva requisición',0,size,Colors.green),   
          SizedBox(height: 5,),                
          ],)                                 
          ],),              
          SizedBox(height: 20,),    
          ExpansionTile(title: Text("Control de requisiciones de víacticos",style: TextStyle(fontSize: 17),textAlign: TextAlign.center,),
          children: [            
          Requsion_('Ir a historial de requisiciones',1,size,Colors.black),
          Requsion_('Ir a requisiciones de los ultimos 30 días',1,size,Colors.black)])
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
                                        //openModal();
                                    }else{

                                      Navigator.push<void>(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) => VisualizarRequisiciones(),
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
