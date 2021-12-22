import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/Config/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Future<String> Ruta_() async {
    String RutaActual = "";
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var NombreUsuario = prefs.getString('usuario');
    if (NombreUsuario != null) {
      if (NombreUsuario.toString().length > 0) {
        RutaActual = "/main";
      }
    } else {
      RutaActual = "/auth";
    }
    return RutaActual;
  }

  String Ruta = await Ruta_();
  await Firebase.initializeApp();
  runApp(MyApp(Ruta));
}

class MyApp extends StatelessWidget {
  String Ruta;
  MyApp(this.Ruta, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supervion personal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: this.Ruta,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}