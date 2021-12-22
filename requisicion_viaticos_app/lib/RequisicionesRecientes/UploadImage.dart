import 'dart:io';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/firebase_api.dart';
import 'package:requisicion_viaticos_app/Components/SpinnerImage.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Metodos.dart';
import 'package:intl/intl.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Imagen.dart';

class UploadingImageToFirebaseStorage extends StatefulWidget {
  
  RequisicionesFormato historial;  
  UploadingImageToFirebaseStorage(this.historial,{Key ? key}) : super(key: key);
  @override
  _UploadingImageToFirebaseStorageState createState() =>
      _UploadingImageToFirebaseStorageState();
}

class _UploadingImageToFirebaseStorageState
    extends State {
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
  DateTime _dateTime = DateTime.now();

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
    super.initState();
  }


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
      final _snackbar = SnackBar(content: Text('Ha ocurrido al cargar la imagen, intente de nuevo.'));
      ScaffoldMessenger.of(context).showSnackBar(_snackbar);
      return;
    }
        
    final fileName = basename(_imageFile!.path);
    final destination = 'Facturas/$fileName';
        
    task = FirebaseApi.uploadFile(destination, _imageFile!);
    setState(() {});

    if (task == null) 
    {
      final _snackbar = SnackBar(content: Text('Ha ocurrido al cargar la imagen, intente de nuevo.'));
      Navigator.of(context).pop(true);      
      ScaffoldMessenger.of(context).showSnackBar(_snackbar);
      return;
    }    
    
    final snapshot = await task!.whenComplete(() {});    
    final urlDownload = await snapshot.ref.getDownloadURL();
    final _snackbar = SnackBar(content: Text('Imagen cargada exitosamente.'));

    if(Opcion == 1)
    {
    setState(() {
      Bandera = true;
    });}
    else{
      setState(() {
      Bandera2 = true;
    });}    

    Navigator.of(context).pop(true);    
    ScaffoldMessenger.of(context).showSnackBar(_snackbar);
    
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
 

  @override
  Widget build(BuildContext context)  {    
    final fileName = _imageFile != null ? basename(_imageFile!.path) : 'No File Selected';         
    return Column(      
        children: [ 
          SizedBox(height: 20,),                              
            Container( alignment: Alignment.center,height: 19,width: MediaQuery.of(context).size.width * 0.9,
              child: Text('Detalles de víaticos',style: TextStyle(fontSize: 18,color: Colors.black,),textAlign: TextAlign.center,),),                
              SizedBox(height: 20,),              
                  Inicio(context),
                  SizedBox(height: 20,),                    
            Container( alignment: Alignment.topLeft,height: 19,width: MediaQuery.of(context).size.width * 0.9,
              child: Text('Seleccione Fecha de factura',style: TextStyle(fontSize: 15,color: Colors.black),textAlign: TextAlign.left,),),      
                FechaFactura(context),  
                SizedBox(height: 35,),                                
                Container(                                                
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child:                           
                              Column(children: [
                                SeleccionarImagen(context,'Factura','Obligatorio*',Colors.red,Bandera)   ,
                                SizedBox(height: 25,),       
                                SeleccionarImagen(context,'Factura','Opcional',Colors.black,Bandera2)   
                              ],)                                                       
                          //fin condicion
                        ),
                      ),                
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

  Widget FechaFactura(context)
  {
    return Container(
            width: MediaQuery.of(context).size.width * 0.9,
          child:                                             
          TextField(
              onTap: () async {
                     await _selectDate(context);
                  }, 
                  style: TextStyle(color: Colors.black),                              
              controller: _date_,
              readOnly: true,
            ) 
        );
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