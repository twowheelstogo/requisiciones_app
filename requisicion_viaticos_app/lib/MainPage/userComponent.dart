import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:requisicion_viaticos_app/Config/routes.dart';
import 'package:getwidget/getwidget.dart';

class UserComponent extends StatefulWidget {
  @override
  _UserComponentState createState() => _UserComponentState();
}

class _UserComponentState extends State<UserComponent> {
  
  String urlFoto = "";
  String Nombre = "";
  String DPI = "";
  String ID = "";

  void initState() {    
    _UserComponentState();
    super.initState();
  }

   _UserComponentState() {
        
    getConstant("usuario").then((val) => setState(() {
          Nombre = val;         
        }));
    
     getConstant("urlFoto").then((val) => setState(() {
          urlFoto = val;          
        })); 

    getConstant("DPI").then((val) => setState(() {
          DPI = val;
        })); 
         
  }

  void _onSelected(String opt) async {
    switch (opt) {
      case 'SIGNOUT':        
        signOut();
        Navigator.pushNamed(context, LogIn);
        break;
      default:
        break;
    }
  }

  void signOut() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    prefs.remove("usuario");    
    prefs.remove("DPI");
    prefs.remove("IdAIRTABLE");   
    prefs.remove("urlFoto"); 
    prefs.remove('Diccionario') ;
  }
 
 
  Future<String> getConstant(String msg) async {
    final prefs = await SharedPreferences.getInstance();
    String DPI = '';
    final res = prefs.getString(msg);
    DPI = '$res';
    return DPI;
  }



  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        child: userIcon(urlFoto),
        onSelected: _onSelected,
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
                child: ListTile(
                  dense: true,
                  title: Text(
                    Nombre,
                    //style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                value: 'PROFILE'),
            PopupMenuItem<String>(
                child: ListTile(
                  dense: true,
                  leading: Icon(Icons.exit_to_app),
                  title: Text(
                    'Cerrar Sesión',
                    //style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                value: 'SIGNOUT'),
          ];
        });
  }

   Widget userIcon(String photourl) {
    //authModel.user.urlFoto;
    return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: 
        photourl.length > 0 ?
        GFAvatar(backgroundImage: NetworkImage(photourl),shape: GFAvatarShape.circle,) 
        : Center(child: CircularProgressIndicator(),)
        );
  }
}
