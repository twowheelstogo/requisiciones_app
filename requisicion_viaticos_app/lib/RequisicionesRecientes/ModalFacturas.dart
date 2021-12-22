import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/UploadImage.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Metodos.dart';

class Facturas extends StatefulWidget {

  RequisicionesFormato historial;  
  Facturas(this.historial,{Key ? key}) : super(key: key);

  @override
  Facturas_ createState() => Facturas_();
}

class Facturas_ extends State<Facturas> {      

   @override
  Widget build(BuildContext context) { 
    return 
    SingleChildScrollView(child: 
    Column(children: [
      UploadingImageToFirebaseStorage(widget.historial)
    ],),);
  }

}
