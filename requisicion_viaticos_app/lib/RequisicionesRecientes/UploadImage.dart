import 'dart:io';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/firebase_api.dart';
import 'package:requisicion_viaticos_app/Components/SpinnerImage.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Metodos.dart';
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
   UploadTask? task;
   List _gasto =
  ["Seleccione tipo de gasto","Hospedaje","Comida","Gasolina"];
  List<DropdownMenuItem<String>> _dropDownMenuItems = [];
  String _current = "";
  
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
    super.initState();
  }


  @override
    
  final picker = ImagePicker();

  Future pickImage(context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });

    await uploadFile(context);
  }

  Future uploadFile(context) async { 
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
    setState(() {
      Bandera = true;
    });
    Navigator.of(context).pop(true);    
    ScaffoldMessenger.of(context).showSnackBar(_snackbar);
    
  }

  @override
  Widget build(BuildContext context)  {
    final fileName = _imageFile != null ? basename(_imageFile!.path) : 'No File Selected';         

    return Column(      
        children: [              
              Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: new DropdownButton(                 
                value: _current,
                items: _dropDownMenuItems,
                onChanged: (value) {changedDropDownItem(value.toString());},
              ),)
            ,
                Container(                                                
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child:
                            //inicia condicion
                           Bandera == true
                              ? 
                              //si
                              FlatButton(onPressed: () {VisualizaImagen(context);}, child: Text('Vista previa'))
                              : 
                              //no
                              FlatButton(
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.blue,
                              size: 50,
                            ),
                            onPressed: () async{ await pickImage(context);},
                          ),
                          //fin condicion
                        ),
                      ),
                
              ],      
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