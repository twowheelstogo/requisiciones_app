import 'package:http/http.dart' as http;
import 'package:requisicion_viaticos_app/Config/constants.dart';
import 'dart:convert';

 Future<List> CrearUsuario_(String NombreUsuario,String pass) async {  
    List Res = await validateUser(NombreUsuario);          
   
    if(Res[0].toString().length == 0)
    {
        final Response = await crearUsuarioFinal(Res[1].toString(),pass);
          if (Response.statusCode == 200) {
               final Decoded = json.decode(Response.body);  
               if (Decoded["records"].length > 0) {  
                  return [false,"Credenciales generadas exitosamente."];
               } 
               else{
                 return [true,'Ha ocurrido un error, intente nuevamente.'];
               }
          }  
          else{
               return [true,'Ha ocurrido un error, intente nuevamente.'];
          }
    }
    else{
      return [true,Res[0].toString()];
    }

  }

   Future<http.Response> crearUsuarioFinal(String ID,String pass) async
   {       
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };
    
    Map<String, dynamic> body = {
      "CONTRASEÑA" : pass,
      "CAMBIO CONTRASEÑA" : "NO DISPONIBLE"
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

  Future<List> validateUser(String user) async {
    String mensaje = "";
    final Response = await getAuthUserInfo(user);
    final Decoded = json.decode(Response.body);
    var ID = "";

    if (Response.statusCode == 200) {
      if (Decoded["records"].length > 0) { 
        final Response2 = await getDisponibiltyPass(user);       
        if(Response2.statusCode == 200)
        {
          
           final Decoded2 = json.decode(Response2.body);            
           if (Decoded2["records"].length > 0) { 
             ID = Decoded2["records"][0]["id"]; 
             mensaje = "";
           }
           else{
             mensaje = "Notifique a su encargado para poder cambiar su contraseña nuevamente.";
           }
        }
        else{
          mensaje = "Ha ocurrido un error, intente de nuevo.";
        }
      }
      else{
        mensaje = "No de DPI incorrecto.";
      }
    }
    else{
      mensaje = "Ha ocurrido un error, intente de nuevo.";
    }

    return [mensaje,ID];
  }

   Future<http.Response> getAuthUserInfo(String NombreUsuario) async {
    String url = urlApi +
        "COLABORADORES?filterByFormula=AND(({No_DOCUMENTO}=" +
        NombreUsuario + "))";
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }

Future<http.Response> getDisponibiltyPass(String NombreUsuario) async {
    String url = urlApi +
        "COLABORADORES?filterByFormula=AND(({No_DOCUMENTO}=" +
        NombreUsuario +
        "),({CAMBIO CONTRASEÑA} = 'DISPONIBLE'))";
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }
