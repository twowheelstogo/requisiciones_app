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
    Container(
      //height: MediaQuery.of(context).size.width * 1.5,
      child: UploadingImageToFirebaseStorage(widget.historial)
    ),);
  }

}
