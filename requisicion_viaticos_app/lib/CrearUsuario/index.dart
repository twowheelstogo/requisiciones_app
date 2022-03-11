import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/Components/Spinner.dart';
import 'package:requisicion_viaticos_app/CrearUsuario/Metodos.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; 

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);
  CreateUser_ createState() => CreateUser_();
}

class CreateUser_ extends State<CreateUser> {

  String dpi_="",email="",pass="";  
  List bandera = [];
  
    void CreateUserName(String pass) async {    
    showDialog(context: context, builder: (_)=>Spinner(),barrierDismissible: false);
    bandera = await CrearUsuario_(dpi_,pass);
    final _snackbar = SnackBar(content: Text(bandera[1]));

    Navigator.of(context).pop(true);

    if (bandera[0]) {
      ScaffoldMessenger.of(context).showSnackBar(_snackbar);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(_snackbar);
      Navigator.pop(context);
      //  Navigator.pushNamed(context, Main);
    }
    //
  }
    
  @override  
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final date = new DateTime.now();
    final year = date.year;
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
                  child: Container(
                    child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: size.height*0.15,),
                Image.asset("assets/mrb-logo.png",width: 150,),
                SizedBox(height: 10,),
                Text('Generaración de Credenciales',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
            SizedBox(height: 80,),            
                inputTextField(1,"Ingrese su número de DPI",TextInputType.number,"ej. 2544985550101",false),
                //  SizedBox(height: 15,),
                // inputTextField(2,"Ingrese correo electronico",TextInputType.emailAddress,"correo@gmail.com",false),
                 SizedBox(height: 15,),
                inputTextField(3,"Ingrese contraseña",TextInputType.visiblePassword,"******",true),
            SizedBox(height: 20,),            
            Container(
              width: size.width*0.9,
              child: OutlineButton(onPressed: () async{
                final key = utf8.encode(pass);
                final bytes = utf8.encode("foobar");
                final hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
                final digest = hmacSha256.convert(bytes);                
                CreateUserName(digest.toString());
               },
              borderSide: BorderSide(color:Color.fromRGBO(56, 56, 56, 1)),
              textColor: Color.fromRGBO(56, 56, 56, 1),
              child: Text("Generar Credenciales"),
              ),
            ),   
                SizedBox(height: 15,), 
                Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                   padding: const EdgeInsets.all(10),
                   child: backMain())),                           
              ],
            ),
          ),
                  ),
        ),

      ),
    );
  }

  
    Widget backMain(){
    return GestureDetector(
      child: Text("Regresar", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue,fontSize:17)),
      onTap: ()  {
         Navigator.pop(context);
      },
    );
  }
  
   Widget inputTextField(int opcion,String mensaje, TextInputType tipo,String hintText,bool flag){
    return TextFormField(
    obscureText: flag,
     style: TextStyle(color: Colors.black),
     cursorColor: Colors.black,
      keyboardType: tipo,     
        onChanged: (value){
          setState(() {
            if(opcion == 1){
              dpi_ = value;
              print(opcion);
            }else if(opcion == 2){
              email = value;
            }else{
              pass = value;
            }            
          });
        },
        decoration: InputDecoration(
            hintText: hintText,
            labelText: mensaje,
            labelStyle: Theme.of(context).textTheme.bodyText2,
            border: OutlineInputBorder()),
      );
  }

}