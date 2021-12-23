import 'dart:io';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Facturas/firebase_api.dart';
import 'package:requisicion_viaticos_app/Components/SpinnerImage.dart';
import 'package:requisicion_viaticos_app/Components/Spinner.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Metodos.dart';
import 'package:intl/intl.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Facturas/Imagen.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UploadingImageToFirebaseStorage extends StatefulWidget {
  
  RequisicionesFormato historial;  
  UploadingImageToFirebaseStorage(this.historial,{Key ? key}) : super(key: key);
  @override
  _UploadingImageToFirebaseStorageState createState() =>
      _UploadingImageToFirebaseStorageState();
}

class _UploadingImageToFirebaseStorageState
    extends State<UploadingImageToFirebaseStorage> {
   File ? _imageFile;
   bool Bandera = false;
   bool Bandera2 = false;
   UploadTask? task;
   List _gasto =
  ["Seleccione tipo de gasto","HOSPEDAJE","COMIDA","GASOLINA"];
  List<DropdownMenuItem<String>> _dropDownMenuItems = [];
  String _current = "";
  TextEditingController Monto = TextEditingController();  
  TextEditingController _date_ = TextEditingController();  
  TextEditingController _date2_ = TextEditingController();  
  DateTime _dateTime = DateTime.now();
  DateTime _dateTime2 = DateTime.now();
  String ID1 = "";
  String ID2 = "";
  String URL1 = "";
  String URL2 = "";
  var uuid = Uuid();  

  void showToast(String mensaje) => Fluttertoast.showToast(
    msg: mensaje,
    fontSize: 16,
  );


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


  

  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _current = _dropDownMenuItems[0].value.toString();
    Monto.text = "";
    ID1 = uuid.v1();
    ID2 = uuid.v4();
    super.initState();
  }

   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    

  @override      
  final picker = ImagePicker();


  Future pickImage(context,int Opcion) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });

    await uploadFile(context,Opcion);
  }

  Future uploadFile(context,int Opcion) async { 
    showDialog(context: context, builder: (_)=>Spinner2(task),barrierDismissible: false);
    if (_imageFile == null) 
    {
      Navigator.of(context).pop(true);     
      showToast('Ha ocurrido un error, intente nuevemente.');
      //_showScaffold('Ha ocurrido un error, intente nuevemente.');
      //openSnackBarWithAction("Ha ocurrido un error, intente nuevemente.");  
      //    
      return;
    }
        
    String fileName = Opcion == 1 ? ID1 : ID2;
    final destination = 'Facturas/$fileName';
        
    task = FirebaseApi.uploadFile(destination, _imageFile!);
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
        

    if(Opcion == 1)
    {
    setState(() {
      Bandera = true;
      URL1 = urlDownload;
    });}
    else{
      setState(() {
      Bandera2 = true;
      URL2 = urlDownload;
    });}    

    showToast('Imagen cargada exitosamente.');
     print("exito");
    Navigator.of(context).pop(true);  
     //openSnackBarWithAction("Imagen cargada exitosamente.");
     //_showScaffold('Imagen cargrada exitosamente.');     
        
  }

  Future<void> CrearDetallesLiquidacion(context) async {

    if(_dateTime.toString().length > 0 && _current.length > 0 && Monto.text.toString().length > 0 && URL1.length > 0)
    {
      showDialog(context: context, builder: (_)=>Spinner(),barrierDismissible: false);
    final Response = await RequisicionesRecientes_().crearDetallesLiquidacion(_dateTime.toString(),_current,double.parse(Monto.text.replaceAll(',', '')),URL1,URL2,widget.historial.ID,widget.historial.ID_Tarifario);        

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
 

  @override
  Widget build(BuildContext context)  {    
    final fileName = _imageFile != null ? basename(_imageFile!.path) : 'No File Selected';         
    return     
    Column(      
        children: [ 
          SizedBox(height: 20,),                              
            Container( alignment: Alignment.center,height: 19,width: MediaQuery.of(context).size.width * 0.9,
              child: Text('Detalles de víaticos',style: TextStyle(fontSize: 18,color: Colors.black,),textAlign: TextAlign.center,),),                
              SizedBox(height: 20,),              
                  Inicio(context),                
                SizedBox(height: 35,),                                
                Container(                                                
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child:                           
                              Column(children: [
                                MostrarFecha('Seleccione fecha de consumo de factura',context,Bandera,_date_,1),
                                SeleccionarImagen(context,'Factura parte 1','Obligatorio*',Colors.red,Bandera)   ,
                                SizedBox(height: 25,),                                       
                                SeleccionarImagen(context,'Factura parte 2','Opcional',Colors.black,Bandera2)   
                              ],)                                                       
                          //fin condicion
                        ),
                      ),
                      SizedBox(height: 70,),    
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

  Widget SeleccionarImagen(context,String Label,String Opcion,Color Colorcito,bool Bandera)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
            FlatButton(
                            child: 
                            Column(children: [  
                            Text(Opcion,style: TextStyle(color: Colorcito),),
                            Bandera == true
                              ? 
                            Text('Actualizar $Label') : Text('Tomar foto de $Label')  ,
                            SizedBox(height: 10,),   
                            Icon(
                              Icons.add_a_photo,
                              color: Colors.black,
                              size: 35,
                            ),],),
                            onPressed: () async{ await pickImage(context,Opcion == 'Obligatorio*' ? 1 : 0);},
                          ),
                          Bandera == true
                              ? 
                          FlatButton(onPressed: () {VisualizaImagen(context);}, child: Text('Vista previa')) : Container()
      ],);
  }

  Widget Inicio(context)
  {
    return Column(children: [
  Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: new DropdownButton(                 
                value: _current,
                items: _dropDownMenuItems,
                onChanged: (value) {changedDropDownItem(value.toString());},
              ),),    
              SizedBox(height: 20,),
            Container( alignment: Alignment.topLeft,height: 19,width: MediaQuery.of(context).size.width * 0.9,
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

  Widget FormatoBoton(context,Color Colorcito,String Mensaje)
  {
    return     ButtonTheme(
                                  
                                  minWidth: MediaQuery.of(context).size.width * 0.9,          
                        child:    OutlineButton(                                      
                                 borderSide: BorderSide(color: Colorcito,width: 1),                                                           
                                onPressed: ()  async {  
                                            await CrearDetallesLiquidacion(context);
                                 },
                                child: Text(
                                  Mensaje,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )));
  }

  

  void VisualizaImagen(context){
    showModalBottomSheet(context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
          builder: (context) {
      return Imagen(_imageFile);
    });
  }

   void changedDropDownItem(String selectedCity) {
    setState(() {
      _current = selectedCity;
    });
  }
  
}