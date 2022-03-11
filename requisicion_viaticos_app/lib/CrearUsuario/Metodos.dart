import 'package:http/http.dart' as http;
import 'package:requisicion_viaticos_app/Config/constants.dart';
import 'dart:convert';

 Future<List> CrearUsuario_(String NombreUsuario,String pass) async {
    bool bandera = false;
    String Mensaje = "";    
    final Response = await getAuthUserInfo(NombreUsuario);
    final Decoded = json.decode(Response.body);

    if (Response.statusCode == 200) {
      if (Decoded["records"].length > 0) {                
        var ID_AIRTABLE = Decoded["records"][0]["id"];    
        final Response2 = await crearUsuarioFinal(ID_AIRTABLE,pass);        
        if(Response2.statusCode != 200)
        {
          bandera = true;
          Mensaje = "Ha ocurrido un error, intente nuevamente.";
        }else{
            Mensaje = "Credenciales generadas exitosamente.";
        }

      } else {
        bandera = true;
        Mensaje = "Credenciales incorrectas.";
      }
    } else {
      bandera = true;
      Mensaje = "Ha ocurrido un error, intente nuevamente.";
    }
    return [bandera, Mensaje];
  }

   Future<http.Response> crearUsuarioFinal(String ID,String pass) async
   {       
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };
    
    Map<String, dynamic> body = {
      "CONTRASEÑA" : pass
    };

     final bodyEncoded = json.encode({
      "records": [
        {"id": ID, "fields": body}        
      ]
    });

     String url = urlApi + 'COLABORADORES';
    print(bodyEncoded);
    try {
      final response = await http.patch(Uri.parse(url),headers: headers,body: (bodyEncoded));
      return response;
    }on http.ClientException catch (e) {
      throw(e.message);
    }
  }

   Future<http.Response> getAuthUserInfo(String NombreUsuario) async {
    String url = urlApi +
        "COLABORADORES?filterByFormula=AND({No_DOCUMENTO}='" +
        NombreUsuario +
        "')";
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }