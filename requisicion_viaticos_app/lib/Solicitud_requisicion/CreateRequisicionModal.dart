import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarModal extends StatefulWidget {
  @override
  _CalendarModalState createState() => _CalendarModalState();
}

class _CalendarModalState extends State<CalendarModal> {
  String _initDate ="";
  String _endDate ="";
  bool _selected = false;
 
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args){
    if(args.value is PickerDateRange){
      setState(() {
        _initDate = DateFormat("yyyy-MM-dd").format(args.value.startDate).toString();
        _endDate = DateFormat("yyyy-MM-dd").format(args.value.endDate??args.value.startDate).toString();
        _selected =true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(8),
      height: size.height*0.8,
      child: Column(
        children: [
          SizedBox(height: 15,),
          Text("Solicitud requisición de víaticos",style: TextStyle(fontSize: 20)),
          Divider(height: 20,  thickness: 2,color: Colors.grey,),
          SizedBox(height: 15,),
          Text('Seleccione la fecha de inicio y de fin del viaje'),
          SizedBox(height: 10,),
          SfDateRangePicker(
            onSelectionChanged: _onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.range,
          ),
          Expanded(
              child:Align(
                alignment: Alignment.bottomCenter,
                child: Container(                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center ,
                    crossAxisAlignment: CrossAxisAlignment.center 
                    ,children: [                     
                    TextButton(
                    child: Text("Guardar",style: TextStyle(fontSize: 19),),
                    onPressed: () {print(_initDate); print(_endDate);},
                    ),                                
                  TextButton(
                    child: Text("Cancelar",style: TextStyle(fontSize: 19),),
                    onPressed: () { Navigator.pop(context);},
                  ),
                  ],)
                ),
              ) )
        ],
      ),
    );
  }
}
