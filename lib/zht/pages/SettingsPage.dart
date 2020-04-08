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


  @override
  Widget build(BuildContext context){


  return Consumer<SettingProvider>(
        builder: (context, _provider, _) {
                      return Scaffold(
               backgroundColor: Colors.green,
             body: Center(
               
               child: Column( 
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             
            children : [
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
                      _provider.meters = value;
                      print(_provider.meters);
                    });               
                    },
                textInputAction: TextInputAction.done
            ),
             
            
                   
            ],
          ),
        ),
        
      );
        }
    
    );
  }
}