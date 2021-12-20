import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:requisicion_viaticos_app/VisualizarRequisiciones/index.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class CalendarModal extends StatefulWidget {
  @override
  _CalendarModalState createState() => _CalendarModalState();
}

class _CalendarModalState extends State<CalendarModal> {
  String _initDate ="";
  String _endDate ="";
  bool _selected = false;
  TextEditingController Monto = TextEditingController();

  List _cities =
  ["Seleccione una agencia","Cluj-Napoca", "Bucuresti", "Timisoara", "Brasov", "Constanta"]; 
  List<DropdownMenuItem<String>> _dropDownMenuItems = [];
  String _currentCity = '';

   @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCity = _dropDownMenuItems[0].value!;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String city in _cities) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: city,
          child: new Text(city)
      ));
    }
    return items;
  }

 
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args){
    if(args.value is PickerDateRange){
      setState(() {
        _initDate = DateFormat("yyyy-MM-dd").format(args.value.startDate).toString();
        _endDate = DateFormat("yyyy-MM-dd").format(args.value.endDate??args.value.startDate).toString();
        _selected =true;
      });
    }
  }

   void changedDropDownItem(String selectedCity) {    
     print(selectedCity);
    setState(() {
      _currentCity = selectedCity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return     
    Container(
      padding: EdgeInsets.all(8),
      height: size.height*0.8,
      child:       
      SingleChildScrollView( child:
      Column(
        children: [                    
          ExpansionTile(title: Text("Generar nueva solicitud de requisición de víaticos",style: TextStyle(fontSize: 17),textAlign: TextAlign.center,),
          children: [
            Column(children: [
             SizedBox(height: 15,),
          Text('Seleccione la fecha de inicio y de fin del viaje'),
          SizedBox(height: 10,),
          SfDateRangePicker(
            onSelectionChanged: _onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.range,
          ),
           Container(
            width: MediaQuery.of(context).size.width * 0.9,
          child: TextFormField(           
            decoration: InputDecoration(                    
            labelText: 'Ingrese Monto de víaticos',                     
            labelStyle: TextStyle(fontSize: 15,color: Colors.black),                                    
          ),
          controller: Monto,
          style: TextStyle(color: Colors.black),   
           inputFormatters: [
    ThousandsFormatter(allowFraction: true)
  ],
     keyboardType: TextInputType.number,       
        )),  
        SizedBox(height: 20,),                
          DropdownButton(
              hint: Text('Seleccione una agencia'),
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 36,
              isExpanded: true,
              value: _currentCity,
              items: _dropDownMenuItems,
              onChanged: (newValue) {
                changedDropDownItem(newValue.toString());
              },
               
            ),    
            SizedBox(height: 20,),                    
          Requsion_('Crear nueva requisición',0,size,Colors.green),   
          SizedBox(height: 5,),                
          ],)                                 
          ],),              
          SizedBox(height: 20,),                
          Requsion_('Visualizar historial de requisiciones',1,size,Colors.black),
          Requsion_('Visualizar requisiciones de los ultimos 30 días',1,size,Colors.black)                 
        ],
      ),)
    );
  }

  Widget Requsion_(String Mensajes, int opcion,final size,Color color_)
  {
    return  Container(                    
                            alignment: Alignment.center,                            
                            child: 
                            ButtonTheme(
                                  
                                  minWidth: MediaQuery.of(context).size.width * 0.9,          
                        child:    OutlineButton(                                      
                                 borderSide: BorderSide(color: color_,width: 1),                                                           
                                onPressed: ()  { 
                                    if(opcion == 0)
                                    {
                                        //openModal();
                                    }else{

                                      Navigator.push<void>(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) => VisualizarRequisiciones(),
                                        ),
                                      );
                                    }
                                 },
                                child: Text(
                                  Mensajes,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ))),
                          );
  }  


}
