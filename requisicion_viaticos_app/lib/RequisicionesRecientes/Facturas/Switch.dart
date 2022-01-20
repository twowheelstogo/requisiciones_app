import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Facturas/ModalFacturas.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Facturas/UploadFile.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Facturas/UploadImage.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Metodos.dart';
import 'dart:io';
import 'dart:io' as io;
import 'package:getwidget/getwidget.dart';

class Switch_ extends StatefulWidget {
  RequisicionesFormato historial;  
  Switch_(this.historial,{Key ? key}) : super(key: key);
 @override
  _Switch_ createState() => _Switch_();
}

class _Switch_ extends State<Switch_> {

    @override
  Widget build(BuildContext context) 
  {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.attach_file), text: "Factura electronica",),
              Tab(icon: Icon(Icons.add_a_photo_outlined), text: "Factura fisica"),
            ],
          ),          
        ),
        body: TabBarView(
          children: [            
            Container( child: SingleChildScrollView(child:  UploadFile(widget.historial),)),
            Container( child: SingleChildScrollView(child: Facturas(widget.historial),) ),
          ],
        ),
      ),
    );
  }
}
