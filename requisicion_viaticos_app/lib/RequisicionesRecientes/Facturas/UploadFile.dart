import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:requisicion_viaticos_app/Components/SpinnerImage.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Facturas/firebase_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Metodos.dart';
import 'package:uuid/uuid.dart';
import 'package:requisicion_viaticos_app/Components/Spinner.dart';

class UploadFile extends StatefulWidget {
  RequisicionesFormato historial; 
  UploadFile(this.historial,{Key ? key}) : super(key: key);
  @override
  UploadFile_ createState() => UploadFile_();
}

class UploadFile_ extends State<UploadFile> {
  UploadTask? task;
  File? file;
  bool Bandera = false,Mensaje = false;
  String ID1 = "";  
  String URL1 = "";  
  var uuid = Uuid();  
  String path_ = "";
   List _gasto =
  ["Seleccione tipo de gasto","HOSPEDAJE","COMIDA","GASOLINA","OTROS"];
  List<DropdownMenuItem<String>> _dropDownMenuItems = [];
  String _current = "";
  TextEditingController Monto = TextEditingController();  
  TextEditingController _date_ = TextEditingController();  
  TextEditingController _date2_ = TextEditingController(); 
  DateTime _dateTime = DateTime.now();
  DateTime _dateTime2 = DateTime.now();

   void initState() {     
    _dropDownMenuItems = getDropDownMenuItems();
    _current = _dropDownMenuItems[0].value.toString();
    Monto.text = "";
    ID1 = uuid.v1();    
    super.initState();
  }

  List Metodo(){
    List items = [];
    
    return items;
  }

   void changedDropDownItem(String selectedCity) {
    setState(() {
      _current = selectedCity;
    });
  }

   List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String city in _gasto) {
      items.add(new DropdownMenuItem(
          value: city,
          child: new Text(city)
      ));
    }
    return items;
  }  
  
  void showToast(String mensaje) => Fluttertoast.showToast(
    msg: mensaje,
    fontSize: 16,
  );

    Future selectFile(context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) {
        setState(() {
        Mensaje = false;
        });
    }
    else
    {
        final path = result.files.single.path!;
        setState(() => file = File(path));
        setState(() {
        Mensaje = true;
        path_ = path.toString();
        });
        await uploadFile(context);
    }  
  }

  Future uploadFile(context) async { 
    showDialog(context: context, builder: (_)=>Spinner2(task),barrierDismissible: false);
    if (file == null) 
    {
      Navigator.of(context).pop(true);     
      showToast('Ha ocurrido un error, intente nuevemente.');
      //_showScaffold('Ha ocurrido un error, intente nuevemente.');
      //openSnackBarWithAction("Ha ocurrido un error, intente nuevemente.");  
      //    
      return;
    }

    
    String fileName = ID1 + extension(path_);
    final destination = 'Facturas/$fileName';
        
    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) 
    {      
      Navigator.of(context).pop(true);            
      //openSnackBarWithAction("Ha ocurrido un error, intente nuevemente.");
      //_showScaffold('Ha ocurrido un error, intente nuevemente.');
      showToast('Ha ocurrido un error, intente nuevemente.');
      return;
    }    
    
    final snapshot = await task!.whenComplete(() {});    
    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      Bandera = true;
      URL1 = urlDownload;
    });        
    showToast('Archivo cargado exitosamente.');
     print("exito");
    Navigator.of(context).pop(true);  
     //openSnackBarWithAction("Imagen cargada exitosamente.");
     //_showScaffold('Imagen cargrada exitosamente.');             
  }

  Future<void> CrearDetallesLiquidacion(context) async {

    if(_dateTime.toString().length > 0 && _current.length > 0 && Monto.text.toString().length > 0 && URL1.length > 0)
    {
      showDialog(context: context, builder: (_)=>Spinner(),barrierDismissible: false);
    final Response = await RequisicionesRecientes_().crearDetallesLiquidacion(_dateTime.toString(),_current,double.parse(Monto.text.replaceAll(',', '')),URL1,'',widget.historial.ID,widget.historial.ID_Tarifario);        

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

    Future<Null> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2101));
        
        if (picked != null && picked != _dateTime)
          setState(() {
            _dateTime2 = picked;
            _date2_.text = DateFormat("yyyy-MM-dd").format(picked);          
          });
    }

    String MontoDisponible(String tipo)
    {
     String res = (tipo == "HOSPEDAJE" ? 
              'Pendiente por liquidar: Q ${double.parse(widget.historial.DISPONIBLE_HOSPEDAJE).toStringAsFixed(2)}'
              :
              tipo == "COMIDA" ? 
              'Pendiente por liquidar: Q ${double.parse(widget.historial.DISPONIBLE_COMIDA).toStringAsFixed(2)}' :

              tipo == "GASOLINA" ? 
              'Pendiente por liquidar: Q ${double.parse(widget.historial.DISPONIBLE_GASOLINA).toStringAsFixed(2)}' : ''
               );
        return res;
    }

  @override
  Widget build(BuildContext context)  {    
    final fileName = file != null ? basename(file!.path) : 'No se ha seleccionado ningún archivo';         
    return     
    Column(      
        children: [ 
          SizedBox(height: 50,),                              
            Container( alignment: Alignment.center,height: 19,width: MediaQuery.of(context).size.width * 0.9,
              child: Text('Detalles de víaticos',style: TextStyle(fontSize: 18,color: Colors.black,),textAlign: TextAlign.center,),),                
              SizedBox(height: 40,),              
                  Inicio(context),                
                SizedBox(height: 35,),  
                Container( alignment: Alignment.center,width: MediaQuery.of(context).size.width * 0.9,
                child:    
                 Column(children: [
                   MostrarFecha('Seleccione fecha de consumo de factura',context,Bandera,_date_,1)
                         ,ElevatedButton_(
                                  context,
                                  Icons.attach_file,
                                  'Seleccione factura electronica',                                
                                ),                                
                    SizedBox(height: 20,),
                   fileName != null ? Text(fileName.toString(),style: TextStyle(fontWeight: FontWeight.w600),) : Container()
                 ],)                                 
                ),  
                      SizedBox(height: 40,), 
                    Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(onPressed: () async{await CrearDetallesLiquidacion(context);}, child: Text('Guardar',style: TextStyle(fontSize: 17),)),            
            FlatButton(onPressed: () {Navigator.pop(context);}, child: Text('Cancelar',style: TextStyle(fontSize: 17),)),            
          ],
        )                  
              ],      
    );
  }

  Widget Inicio(context)
  {
    return       
    Column(children: [
  Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: new DropdownButton(                 
                value: _current,
                items: _dropDownMenuItems,
                onChanged: (value) {changedDropDownItem(value.toString());},
              ),),    
              SizedBox(height: 20,),              
                                                                                        
               Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text('Ingrese Monto de víaticos',style: TextStyle(fontSize: 15,color: Colors.black),textAlign: TextAlign.left,),),                                    

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

            MontoDisponible(this._current).length > 0 ?
            Column(children: [
              SizedBox(height: 10),
            Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: 
                Text(MontoDisponible(this._current),style: TextStyle(fontSize: 15,color: Colors.red),textAlign: TextAlign.left,),
            )
            ],)  : Container()         
    ],);
  }

  Widget FechaFactura(context,TextEditingController controlador,int Opcion)
  {
    return Container(
            width: MediaQuery.of(context).size.width * 0.9,
          child:                                             
          TextField(
              onTap: () async {
                     if(Opcion == 1)
                     {
                        await _selectDate(context);
                     }
                     else{
                       await _selectDate2(context);
                     }
                  }, 
                  style: TextStyle(color: Colors.black),                              
              controller: controlador,
              readOnly: true,
            ) 
        );
  }

  Widget MostrarFecha(String Label,context,bool bandera,TextEditingController controlador,int Opcion)
  {
    return 
    Container(
    child:            
    Column(children: [                      
            Container( alignment: Alignment.topLeft,height: 19,width: MediaQuery.of(context).size.width * 0.9,
              child: Text(Label,style: TextStyle(fontSize: 15,color: Colors.black),textAlign: TextAlign.left,),),      
                FechaFactura(context,controlador,Opcion), 
                SizedBox(height: 35,),              
    ],) );
  }
  
  Widget ElevatedButton_(context,IconData icon, String text)
    {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue.shade400,
          minimumSize: Size.fromHeight(50),
        ),
        child: ButtonWidget(icon,text,context),
        onPressed: () async {await selectFile(context);},
      );
    }

    Widget ButtonWidget(IconData icon, String text,context)
    {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28),
          SizedBox(width: 16),
          Text(
            text,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      );
    }
}