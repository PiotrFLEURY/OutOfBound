import 'package:OutOfBounds/zht/SettingProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget{
  
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  TextEditingController value = new TextEditingController() ;
  List<bool> _selections = [true, false];

@override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context){


  return Consumer<SettingProvider>(
        builder: (context, _provid, _) {
                      return Scaffold(
               backgroundColor: Colors.green,
             body: Center(
               
               child: Column( 
             mainAxisAlignment: MainAxisAlignment.center,
             
            children : <Widget> [
             new TextField(
                decoration: InputDecoration(
                    hintText: 'Boundary in meters'
                  ),
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],           
                    controller: value,
                    onSubmitted: (String value){
                      setState((){
                      _provid.boundary = value;
                      print(_provid.boundary);
                    });               
                    },
                textInputAction: TextInputAction.done
            ),
            Text("Enable Alert : "),
    
             ToggleButtons(
                borderColor: Colors.black,
                fillColor: Colors.grey,
                borderWidth: 2,
                selectedBorderColor: Colors.black,
                selectedColor: Colors.white,
                borderRadius: BorderRadius.circular(0),
               children: <Widget>[
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'TRUE',
                        style: TextStyle(fontSize: 16),
                    ),
                    ),
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'FALSE',
                        style: TextStyle(fontSize: 16),
                    ),
                    ),
                ],
              isSelected: _selections,
              onPressed: (int index) {
                    if(index == 0) 
                    {_provid.isEnableLocation = true;
                      print("true");
                      }
                    if(index == 1) {
                      _provid.isEnableLocation = false;
                      print("false");}

                setState(() {
                 if(_selections[index] == false)
                   { 
                     _selections[0] = !_selections[0];
                     _selections[1] = !_selections[1];
                      
                   } 
                                     
                });
                
              }, 
             ),
                   
            ],
          ),
        ),
        
      );
        }
    
    );
  }
}