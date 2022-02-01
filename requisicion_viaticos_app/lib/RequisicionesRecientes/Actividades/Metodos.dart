import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:requisicion_viaticos_app/config/constants.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ActividadesDetalles with ChangeNotifier {
  final String ID;
  final String Fecha;
  final String PEAJES;
  final String LUGAR_ORIGEN;
  final String LUGAR_DESTINO;
  final String ACTIVIDAD_REALIZADA;
  final String KILOMETROS_RECORRIDOS;
  final String LECTURA_ODOMETRO_INICIAL;
  final String LECTURA_ODOMETRO_FINAL;  
  final String ID_AIRTABLE;

  ActividadesDetalles({
    required this.ID,  
    required this.Fecha,
    required this.PEAJES,
    required this.LUGAR_ORIGEN,
    required this.LUGAR_DESTINO,
    required this.ACTIVIDAD_REALIZADA,
    required this.KILOMETROS_RECORRIDOS,
    required this.LECTURA_ODOMETRO_INICIAL,
    required this.LECTURA_ODOMETRO_FINAL,
    required this.ID_AIRTABLE
  });
}

class ObtenerAgenciasSucursal {

    Future<http.Response> crearDetalles(
      String ORIGEN,String DESTINO,String Actividades,double KILOMETROS,String PASAJE,
      String LecturaInicial,String LecturaFinal,      
      String ID_AIRTABLE,double costo
   ) async{     
       
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };
    
    Map<String, dynamic> body = {
      "LUGAR DE ORIGEN": ORIGEN,
      "LUGAR DE DESTINO": DESTINO,
      "ACTIVIDAD REALIZADA": Actividades,
      "KILOMETROS RECORRIDOS": KILOMETROS,
      "PEAJES": PASAJE,
      "LECTURA ODOMETRO INICIAL":LecturaInicial,
      "LECTURA ODOMETRO FINAL":LecturaFinal,
      "PASAJE UTILIZADO" : costo
    };

    final bodyEncoded = json.encode({
      "records": [
        {"id": ID_AIRTABLE, "fields": body}        
      ]
    });

    String url = urlApi + 'DETALLES_ACTIVIDADES';
    print(bodyEncoded);
    try {
      final response = await http.patch(Uri.parse(url),headers: headers,body: (bodyEncoded));
      return response;
    }on http.ClientException catch (e) {
      throw(e.message);
    }
  }

  Future <List<ActividadesDetalles> > ObtenerActividades_(String ID) async
  {
    List<ActividadesDetalles> Historial_ = [];
    final Response = await ObtenerActividades(ID);
    if(Response.statusCode == 200)
    {
      final Decoded = json.decode(Response.body);
      if(Decoded.length > 0)
      {
        final tmp = Decoded["records"];
        
        for(int i = 0; i < tmp.length;i++)
        {
          String ID = tmp[i]["fields"]["REQUISICION_VIATICOS"][0];         
          String Fecha = tmp[i]["fields"]["FECHA"];
          String PEAJES = tmp[i]["fields"]["PEAJES"] == null ? '' : tmp[i]["fields"]["PEAJES"];
          String LUGAR_ORIGEN = tmp[i]["fields"]["LUGAR DE ORIGEN"] == null ? '' : tmp[i]["fields"]["LUGAR DE ORIGEN"];
          String LUGAR_DESTINO = tmp[i]["fields"]["LUGAR DE DESTINO"] == null ? '' : tmp[i]["fields"]["LUGAR DE DESTINO"];
          String ACTIVIDAD_REALIZADA = tmp[i]["fields"]["ACTIVIDAD REALIZADA"] == null ? '' : tmp[i]["fields"]["ACTIVIDAD REALIZADA"];
          String KILOMETROS_RECORRIDOS = tmp[i]["fields"]["KILOMETROS RECORRIDOS"] == null ? '' : tmp[i]["fields"]["KILOMETROS RECORRIDOS"].toString();
          String LECTURA_ODOMETRO_INICIAL = tmp[i]["fields"]["LECTURA ODOMETRO INICIAL"] == null ? '' : tmp[i]["fields"]["LECTURA ODOMETRO INICIAL"];
          String LECTURA_ODOMETRO_FINAL = tmp[i]["fields"]["LECTURA ODOMETRO FINAL"] == null ? '' : tmp[i]["fields"]["LECTURA ODOMETRO FINAL"];
          String ID_AIRTABLE = tmp[i]["fields"]["ID"];       

          Historial_.add(ActividadesDetalles(ID: ID, Fecha: Fecha, PEAJES: PEAJES, 
          LUGAR_ORIGEN: LUGAR_ORIGEN, 
          LUGAR_DESTINO: LUGAR_DESTINO, 
          ACTIVIDAD_REALIZADA: ACTIVIDAD_REALIZADA,
          KILOMETROS_RECORRIDOS: KILOMETROS_RECORRIDOS, 
          LECTURA_ODOMETRO_INICIAL: LECTURA_ODOMETRO_INICIAL, 
          LECTURA_ODOMETRO_FINAL: LECTURA_ODOMETRO_FINAL,
          ID_AIRTABLE: ID_AIRTABLE
          ));          
        }
      }
    }
    return Historial_;
  }
  
  Future<http.Response> ObtenerActividades(String ID) async {
     String url = urlApi +
        "DETALLES_ACTIVIDADES?filterByFormula=AND(({REQUISICION_VIATICOS}='" + ID + "'))&sort%5B0%5D%5Bfield%5D=FECHA";
      
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };    
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }      
}