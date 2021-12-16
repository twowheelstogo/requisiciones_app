import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/Components/Spinner.dart';
import 'package:requisicion_viaticos_app/Login/Metodos.dart';
import 'package:requisicion_viaticos_app/MainPage/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  LoginPageState_ createState() => LoginPageState_();
}

class LoginPageState_ extends State<LoginPage> {

  String _userId="";
  List bandera = [];

     void SignIn() async {    
    showDialog(context: context, builder: (_)=>Spinner(),barrierDismissible: false);
    bandera = await Autenticacion().Autenticar(_userId);
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
            SizedBox(height: 100,),
                inputTextField(),
            SizedBox(height: 20,),            
            Container(
              width: size.width*0.9,
              child: OutlineButton(onPressed: () async{ SignIn();},
              borderSide: BorderSide(color:Color.fromRGBO(56, 56, 56, 1)),
              textColor: Color.fromRGBO(56, 56, 56, 1),
              child: Text("INICIAR SESIÓN"),
              ),
            ),
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

   Widget inputTextField(){
    return TextFormField(
     style: TextStyle(color: Colors.black),
     cursorColor: Colors.black,
      keyboardType:TextInputType.number,     
        onChanged: (value){
          setState(() {
            _userId=value;
          });
        },
        decoration: InputDecoration(
            hintText: "eg. 2544985550101",
            labelText: "Ingrese su DPI",
            labelStyle: Theme.of(context).textTheme.bodyText2,
            border: OutlineInputBorder()),
      );
  }

}