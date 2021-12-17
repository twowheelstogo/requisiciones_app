import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/Components/drawer.dart';
import 'package:requisicion_viaticos_app/MainPage/Resume.dart';
import 'package:requisicion_viaticos_app/MainPage/userComponent.dart';
import 'package:intl/intl.dart';
import 'package:requisicion_viaticos_app/Solicitud_requisicion/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  MainPage_ createState() => MainPage_();
}

class MainPage_ extends State<MainPage> {

  final today = new DateTime.now();
  String Nombre = "";
  String Genero = "";

  void initState() {    
    MainPage_();
    super.initState();
  }

     Future<String> getConstant(String msg) async {
    final prefs = await SharedPreferences.getInstance();
    String DPI = '';
    final res = prefs.getString(msg);
    DPI = '$res';
    return DPI;
  }

  MainPage_ (){
    getConstant("usuario").then((val) => setState(() {
          Nombre = ConvertirNombre(val);
        }));
    getConstant("Genero").then((val) => setState(() {
          Genero = ConvertirNombre(val);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
       
      drawer: DrawerComponent(),
      appBar: new AppBar(            
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            title: Image.asset(
              "assets/mrb-logo.png",
              width: 70,
            ),
            elevation: 0,
            actions: [UserComponent()],
             leading: Builder(
            builder: (context) => IconButton(
                icon: Icon(Icons.menu,size: 35,),
                onPressed: () {
                Scaffold.of(context).openDrawer();
                },
            ),
            ),
          ),
       body: SingleChildScrollView(         
        child: Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        alignment: Alignment.topCenter,
                        child:
                        Column(children: [
                           Text(
                             Genero == 'Masculino' ? 'Bienvenido ${(Nombre)}' : 'Bienvenida ${(Nombre)}',                            
                            style: TextStyle(fontSize: 17),
                                 ),
                                 SizedBox(height: 10,),
                           Text(
                        Convertir(
                            DateFormat.yMMMMEEEEd().format(today).toString()),
                            style: TextStyle(fontSize: 17),
                                 ),
                          Divider(height: 20,  thickness: 3,color: Colors.black,),
                          SizedBox(height: 20,),
                          Container(child: Resume(1,1,0),
                          width: MediaQuery.of(context).size.width * 0.95,
                          )  ,
                                      SizedBox(height: 20,),                        
                          Solicitud()
                        ],)
                            ),                                                
                        ]
                        )
                          )
                            )
                              ),
        )
          );
  }

  String Convertir(String dia) {
    var arr = dia.split(",");
    String nuevaFecha = "";

    switch (arr[0]) {
      case "Monday":
        {
          nuevaFecha = "Lunes, ";
        }
        break;

      case "Tuesday":
        {
          nuevaFecha = "Martes, ";
        }
        break;

      case "Wednesday":
        {
          nuevaFecha = "Miercoles, ";
        }
        break;

      case "Thursday":
        {
          nuevaFecha = "Jueves, ";
        }
        break;

      case "Friday":
        {
          nuevaFecha = "Viernes, ";
        }
        break;

      case "Saturday":
        {
          nuevaFecha = "Sabado, ";
        }
        break;

      case "Sunday":
        {
          nuevaFecha = "Domingo, ";
        }
        break;

      default:
        {
          nuevaFecha = "";
        }
        break;
    }
    var arr2 = arr[1].split(" ");
    nuevaFecha += Mes(arr2[1]) + arr2[2] + ", " + arr[2];
    return nuevaFecha;
  }

  String Mes(String mes) {
    String nuevoMes = "";
    switch (mes) {
      case "January":
        {
          nuevoMes = "Enero ";
        }
        break;

      case "February":
        {
          nuevoMes = "Febrero ";
        }
        break;

      case "March":
        {
          nuevoMes = "Marzo ";
        }
        break;

      case "April":
        {
          nuevoMes = "Abril ";
        }
        break;

      case "May":
        {
          nuevoMes = "Mayo ";
        }
        break;

      case "June":
        {
          nuevoMes = "Junio ";
        }
        break;

      case "Jule":
        {
          nuevoMes = "Julio ";
        }
        break;
      case "August":
        {
          nuevoMes = "Agosto ";
        }
        break;
      case "September":
        {
          nuevoMes = "Septiembre ";
        }
        break;
      case "October":
        {
          nuevoMes = "Octubre ";
        }
        break;
      case "November":
        {
          nuevoMes = "Noviembre ";
        }
        break;
      case "December":
        {
          nuevoMes = "Diciembre ";
        }
        break;
    }
    return nuevoMes;
  }
 
  String ConvertirNombre(String entrada) {
    String tmp = entrada.replaceAll('  ', ' ');
    //print(tmp);
    var tmp2 = tmp.split(' ');
    String tmp3 = "";
    for (var i in tmp2) {
      tmp3 = tmp3 +
          i[0].toUpperCase() +
          i.substring(1, i.length).toLowerCase() +
          " ";
    }
    return tmp3.substring(0, tmp3.length - 1);
  }
}