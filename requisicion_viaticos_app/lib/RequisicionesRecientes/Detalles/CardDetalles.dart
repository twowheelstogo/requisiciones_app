import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Detalles/Imagenes.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Detalles/Metodos.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

class DetallesCard extends StatefulWidget {
  
  RequisicionesDetallesFormato historial;
  String Mensaje;
  DetallesCard(this.historial ,this.Mensaje,{Key ? key}):super(key:key);

  @override
  Detalles_ createState() => Detalles_();
}


class Detalles_ extends State<DetallesCard> {
    
  String savePath = "";
  bool downloading = true;
  String downloadingStr = "No data";
  static var httpClient = new HttpClient();
        
  @override
  Widget build(BuildContext context) {      
    return Card(    
        shape: RoundedRectangleBorder(
    side: BorderSide(color: Colors.blue.shade400, width: 5),
    borderRadius: BorderRadius.circular(10),
  ),  
    margin: EdgeInsets.all(15),    
    elevation: 10,
    child: Column(
      children: <Widget>[
        
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),          
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Text(
                  "Fecha factura: "+DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.historial.Fecha)).toString()
                  ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                  SizedBox(height: 20,),
                Text(
                  "Monto factura: Q "+ double.parse(widget.historial.MONTO).toString()
                  ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                  SizedBox(height: 20,),
                Text(
                  "Tipo gasto: "+widget.historial.TIPO_GASTO
                  ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                  SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center
                  ,children: [
                  for(var tmp in widget.historial.FOTO_FACTURA) 
                FlatButton(onPressed: () async {
                  if(ValidarTipo(tmp["url"]))
                  {
                    VisualizaImagen(context,tmp["url"]);                  
                  }
                  else{
                    String url = tmp["url"];
                    String filename = url.split('/').last;
                     openFile(url: url,filename: filename.split('Facturas').last);
                  }                                    
                  }, child: Column(children: [                  
                  (ValidarTipo(tmp["url"])) ? 
                  Column(children: [
                    Text(widget.Mensaje),
                  Icon( Icons.photo)
                  ],) :
                  Column(children: [
                    Text('Descargar'),
                  Icon( Icons.photo)
                  ],) 
                ],))  
                ],),
                SizedBox(height: 25,),
              ],
            ),)
      ])                                    
  );
  }

    

  bool ValidarTipo(String url)
  {    
    String extension_ = extension(url).toString().toLowerCase();
    if(extension_ == ".png" || extension_ == ".jpg" || extension_ == ".jpeg" )
    {
      return true;
    }
    else{
      return false;
    }    
  }

  Future openFile({required String url,required String filename}) async {
    // ignore: avoid_print
    
    final file =  await downloadFile(url,filename);
    if(file == null) return;    
     OpenFile.open(file.path);
  }


  Future<File?> downloadFile(String url,String name) async {

    try
    {    
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('/${appStorage.path}/$name');

    final response = await Dio().get(url,options: Options(
      responseType: ResponseType.bytes,
      followRedirects: false,
      receiveTimeout: 0
      ),
    );

    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();

    return file; }
    catch(e){
      return null;
    }
  }

  void VisualizaImagen(context,String url){
    showModalBottomSheet(context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
          builder: (context) {
      return Imagenes(url);
    });
  }


  
    

}
