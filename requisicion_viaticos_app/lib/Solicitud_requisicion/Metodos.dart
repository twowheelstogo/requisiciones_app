import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:requisicion_viaticos_app/config/constants.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ListadoAgencias{
  
   Future<http.Response> crearRequisicion(String Inicio, String Fin,double Monto,String ID_AGENCIA,String ID_USUARIO)async{
       
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };

    

    Map<String, dynamic> body = {
      "FECHA_INICIO_VIAJE" : Inicio,
      "FECHA_RETORNO_VIAJE" : Fin,
      "MONTO_VIATICOS" : Monto,
      "AGENCIA" : [ID_AGENCIA],
      "STATUS" : "PENDIENTE",      
      "COLABORADORES": [ID_USUARIO]
    };

    final bodyEncoded = json.encode({
      "records": [
        {"fields": body}
      ]
    });

     String url = urlApi + 'REQUISICION_VIATICOS';
    print(bodyEncoded);
    try {
      final response = await http.post(Uri.parse(url),headers: headers,body: (bodyEncoded));
      return response;
    }on http.ClientException catch (e) {
      throw(e.message);
    }
  }


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