import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DrawerComponent extends StatefulWidget {
  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
  // Agrega un ListView al drawer. Esto asegura que el usuario pueda desplazarse
  // a través de las opciones en el Drawer si no hay suficiente espacio vertical
  // para adaptarse a todo.
  child: ListView(
    // Importante: elimine cualquier padding del ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        child: Text('Drawer Header'),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
      ListTile(
        title: Text('Item 1'),
        onTap: () {
          // Actualiza el estado de la aplicación
          // ...
        },
      ),
      ListTile(
        title: Text('Item 2'),
        onTap: () {
          // Actualiza el estado de la aplicación
          // ...
        },
      ),
    ],
  ),
);
  }
  
}