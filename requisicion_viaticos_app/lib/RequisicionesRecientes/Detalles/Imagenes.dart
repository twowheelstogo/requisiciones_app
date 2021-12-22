import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Facturas/UploadImage.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Metodos.dart';
import 'dart:io';
import 'dart:io' as io;

class Imagenes extends StatefulWidget {

  String _imageFile;
  Imagenes(this._imageFile,{Key ? key}) : super(key: key);

  @override
  Imagenes_ createState() => Imagenes_();
}

class Imagenes_ extends State<Imagenes> {      

   @override
  Widget build(BuildContext context) { 
    return 
    SingleChildScrollView(child: 
    Column(children: [
      SizedBox(height: 50,),
      Container(        
        child: Image.network(widget._imageFile,
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.width * 1.5,
        fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(child: Text('Cargando imagen...'));
            // You can use LinearProgressIndicator or CircularProgressIndicator instead
          },
          errorBuilder: (context, error, stackTrace) =>
              Text('No se ha podido cargar la imagen!'),        
        )
      ),
      Container(
        alignment: Alignment.center,
        child: FlatButton(child: Text('Regresar'),onPressed: (){Navigator.pop(context);},),
      )
    ],),
    );
  }

}
