import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:requisicion_viaticos_app/config/constants.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class ObtenerAgenciasSucursal {

    Future<http.Response> crearDetalles(
      String ORIGEN,String DESTINO,String Actividades,double KILOMETROS,double PASAJE,
      String LecturaInicial,String LecturaFinal,
      String ID_FINAL
   ) async{     
       
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };
    
    Map<String, dynamic> body = {
      "ORIGEN": ORIGEN,
      "DESTINO": DESTINO,
      "ACTIVIDAD REALIZADA": Actividades,
      "KILOMETROS RECORRIDOS": KILOMETROS,
      "PASAJE UTILIZADO": PASAJE,
      "LECTURA ODOMETRO INICIAL":LecturaInicial,
      "LECTURA ODOMETRO FINAL":LecturaFinal,
      "BANRURAL_CATALOGOS_AGENCIA" : [ID_FINAL]
    };

    final bodyEncoded = json.encode({
      "records": [
        {"fields": body}
      ]
    });

    String url = urlApi + 'DETALLES_ACTIVIDADES';
    print(bodyEncoded);
    try {
      final response = await http.post(Uri.parse(url),headers: headers,body: (bodyEncoded));
      return response;
    }on http.ClientException catch (e) {
      throw(e.message);
    }
  }
  
  
    Future<http.Response> ObtenerAgencias(String Paginacion) async {

     String url = urlApi +
        "BANRURAL_CATALOGOS_AGENCIA" + Paginacion;
      
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }


  Future<List> Agencias() async
  {    
    List<String> Agencias = [];
    Map<String,String> Diccionario = {};    
    //String ID_AIRTABLE   = await getConstant("IdAIRTABLE");

    bool Bandera = false;
    String paginacion = "";    
    do
    {    
    final Response = await ObtenerAgencias(paginacion);
    if(Response.statusCode == 200)
    {
      final Decoded = json.decode(Response.body);

      for(var i = 0; i < Decoded["records"].length; i++)
      {        
        final ID_AIRTABLE = Decoded["records"][i]["fields"]["ID"];
        final NOMBRE = Decoded["records"][i]["fields"]["NOMBRE"];            

        if(!Diccionario.containsKey(NOMBRE.toString()))
        {
          Diccionario[NOMBRE.toString()] = ID_AIRTABLE.toString();
          Agencias.add(NOMBRE.toString());                                     
        }                                           
      }

      if(Decoded["offset"] != null)
      {
        paginacion = '?offset=${Decoded["offset"]}';
      }
      else{
        Bandera = true;
      }
    }
    }
    while(Bandera != true);
       
    return [Agencias,Diccionario];    
  }


}