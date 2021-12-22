import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Facturas/UploadImage.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Metodos.dart';
import 'dart:io';
import 'dart:io' as io;

class Imagen extends StatefulWidget {

  File ? _imageFile;
  Imagen(this._imageFile,{Key ? key}) : super(key: key);

  @override
  Imagen_ createState() => Imagen_();
}

class Imagen_ extends State<Imagen> {      

   @override
  Widget build(BuildContext context) { 
    return 
    SingleChildScrollView(child: 
    Column(children: [
      SizedBox(height: 50,),
      Container(        
        child: Image.file(widget._imageFile!,
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.width * 0.9,
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: FlatButton(child: Text('Regresar'),onPressed: (){Navigator.pop(context);},),
      )
    ],),
    );
  }

}
