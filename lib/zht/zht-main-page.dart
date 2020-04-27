import 'package:OutOfBounds/zht/LocationProvider.dart';
import 'package:OutOfBounds/zht/SettingProvider.dart';
import 'package:flutter/material.dart';
import 'package:OutOfBounds/zht/pages/StartPositionPage.dart';
import 'package:OutOfBounds/zht/pages/ActualPosition.dart';
import 'package:OutOfBounds/zht/pages/SettingsPage.dart';
import 'package:provider/provider.dart';

const WIDTH = 100.0;
const HEIGHT = 36.0;
const TEXT_SIZE = 7.5;
const ICON_SIZE= 12.0;
 
class ZhtMainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}
class MyAppState extends State<ZhtMainPage> {

 int whoSelected = 0;
  final itemsChoice = [
    StartPosition(),
    ActualPosition(),
    SettingsPage(),
  ];

  Alignment aligne = Alignment.bottomLeft;
  Color newColorsStarting =  Color.fromARGB(255, 128, 128, 128);
  Color newColorsCurrent =  Color.fromARGB(255, 128, 128, 128);
  Color newColorsSettings =  Color.fromARGB(255, 128, 128, 128);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingProvider(),
        )
      ],
      child: new Scaffold(
        body : itemsChoice[whoSelected],
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(6.0),
          child:Container(
            alignment: Alignment.bottomCenter,
            height: 50.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              border:Border.all(width: 1.0, color: Colors.grey)
            ),
            child: Stack( 
              children: <Widget>[
                AnimatedAlign(
                  alignment: aligne,
                  duration: Duration(milliseconds: 400),     
                  child: Container(
                    width: WIDTH,
                    height: HEIGHT,
                    margin: EdgeInsets.only(bottom:5.0), 
                    decoration:BoxDecoration(color:Colors.orange,borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Row( 
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container( 
                      padding: EdgeInsets.only(bottom:4.0),      
                      alignment: Alignment.bottomLeft,
                      child:FlatButton.icon(    
                        label: Text("Starting location",style: new TextStyle(fontSize:TEXT_SIZE,color:newColorsStarting)),
                        icon:Icon(Icons.location_city, color:newColorsStarting,size: ICON_SIZE,),
                        onPressed: (){
                          setState(() {
                            whoSelected=0;
                            aligne= Alignment.bottomLeft;
                            newColorsStarting=Colors.white;
                            newColorsCurrent=Colors.grey;
                            newColorsSettings=Colors.grey;
                          });
                        }
                      ),
                    ),
                    Container( 
                      padding: EdgeInsets.only(bottom:4.0),     
                      alignment: Alignment.bottomCenter,
                      child: FlatButton.icon(          
                        label: Text("Current Location",style: new TextStyle(fontSize:TEXT_SIZE,color:newColorsCurrent)),
                        icon:Icon(Icons.my_location, color:newColorsCurrent,size: ICON_SIZE,),
                        onPressed: (){
                          setState(() {
                            whoSelected=1;
                            aligne= Alignment.bottomCenter ;
                            newColorsStarting=Colors.grey;
                            newColorsCurrent=Colors.white;
                            newColorsSettings=Colors.grey;
                          });
                        }
                      )
                    ),
                    Container( 
                      padding: EdgeInsets.only(bottom:4.0),
                      alignment: Alignment.bottomRight,
                      child: FlatButton.icon(    
                        label: Text("Settings",style: new TextStyle(fontSize:TEXT_SIZE,color:newColorsSettings)),
                        icon:Icon(Icons.settings, color:newColorsSettings,size: ICON_SIZE,),
                          onPressed: (){
                            setState(() {
                              whoSelected=2;         
                              aligne= Alignment.bottomRight;
                              newColorsStarting=Colors.grey;
                              newColorsCurrent=Colors.grey;
                              newColorsSettings=Colors.white;
                            });
                          }
                        )
                      ),
                    ], 
                  ),                  
                ],
              ),
            ),
          ),
        )
      );     
    }
  }
