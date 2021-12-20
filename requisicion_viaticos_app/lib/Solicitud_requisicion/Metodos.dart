import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:requisicion_viaticos_app/config/constants.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ListadoAgencias{
  
  Future<List> Agencias() async
  {    
    List<String> Agencias = [];
    Map<String,String> Diccionario = {};
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
        Diccionario[NOMBRE.toString()] = ID_AIRTABLE.toString();
        Agencias.add(NOMBRE.toString());
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

}