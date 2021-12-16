import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/Components/drawer.dart';
import 'package:requisicion_viaticos_app/MainPage/userComponent.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  MainPage_ createState() => MainPage_();
}

class MainPage_ extends State<MainPage> {

  final today = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
       
      drawer: DrawerComponent(),
      appBar: new AppBar(
            toolbarHeight: 62,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            title: Image.asset(
              "assets/mrb-logo.png",
              width: 70,
            ),
            elevation: 0,
            actions: [UserComponent()],
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
                      Text(
                        Convertir(
                            DateFormat.yMMMMEEEEd().format(today).toString()),
                        style: Theme.of(context).textTheme.headline5,
                      )
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
}