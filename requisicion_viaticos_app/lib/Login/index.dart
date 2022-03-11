import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/Components/Spinner.dart';
import 'package:requisicion_viaticos_app/Login/Metodos.dart';
import 'package:requisicion_viaticos_app/MainPage/index.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; 
import 'package:requisicion_viaticos_app/CrearUsuario/index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  LoginPageState_ createState() => LoginPageState_();
}

class LoginPageState_ extends State<LoginPage> {

  String _userId="", pass = "";  
  List bandera = [];

     void SignIn() async { 

final key = utf8.encode(pass);
                final bytes = utf8.encode("foobar");
                final hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
                final digest = hmacSha256.convert(bytes);      
    showDialog(context: context, builder: (_)=>Spinner(),barrierDismissible: false);
    bandera = await Autenticacion().Autenticar(_userId,digest.toString());
    final _snackbar = SnackBar(content: Text(bandera[1]));


    Navigator.of(context).pop(true);

    if (bandera[0]) {
      ScaffoldMessenger.of(context).showSnackBar(_snackbar);
    } else {
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => MainPage(),
        ),
      );
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
                Text('Inicio de Sesión',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
            SizedBox(height: 90,),
                inputTextField(1,"Ingrese su número de DPI",TextInputType.number,"ej. 2544985550101",false),
                SizedBox(height: 10,),
                inputTextField(3,"Ingrese contraseña",TextInputType.visiblePassword,"******",true),
            SizedBox(height: 20,),                        
            Container(
              width: size.width*0.9,
              child: OutlineButton(onPressed: () async{ SignIn();},
              borderSide: BorderSide(color:Color.fromRGBO(56, 56, 56, 1)),
              textColor: Color.fromRGBO(56, 56, 56, 1),
              child: Text("INICIAR SESIÓN"),
              ),
            ),
               SizedBox(height: 20,), 
                Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                   padding: const EdgeInsets.all(10),
                   child: createUser())),            
               SizedBox(height: 20,), 
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text('© ${year.toString()} Derechos reservados Grupo MRB'),
                )
            )
              ],
            ),
          ),
                  ),
        ),

      ),
    );
  }

    Widget createUser(){
    return GestureDetector(
      child: Text("Generar Credenciales", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue,fontSize:17)),
      onTap: ()  {
         Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => CreateUser(),
        ),
      );
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
              _userId = value;
              print(opcion);
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