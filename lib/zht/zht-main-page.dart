import 'package:OutOfBounds/zht/LocationProvider.dart';
import 'package:OutOfBounds/zht/SettingProvider.dart';
import 'package:flutter/material.dart';
import 'package:OutOfBounds/zht/pages/StartPositionPage.dart';
import 'package:OutOfBounds/zht/pages/ActualPosition.dart';
import 'package:OutOfBounds/zht/pages/SettingsPage.dart';
import 'package:provider/provider.dart';

const WIDTH = 106.5;
const HEIGHT = 50.0;
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
  Alignment Aligne = Alignment.bottomLeft;
  Color new_colors_starting =  Color.fromARGB(255, 128, 128, 128);
  Color new_colors_current =  Color.fromARGB(255, 128, 128, 128);
  Color new_colors_settings =  Color.fromARGB(255, 128, 128, 128);

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
        body: Column(    
          children: <Widget>[
            Container(
              height:483.0,
              child: itemsChoice[whoSelected],
            ),  
            Row(       
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,  
              children: <Widget>[
                Container(
                  width: 320.0,
                  height: HEIGHT,
                  child: 
                  Stack(                  
                    children: <Widget>[
                      Align(
                        alignment: Aligne,
                        child:Padding(
                          padding: EdgeInsets.all(5.0),
                          child:AnimatedContainer( 
                            duration : Duration(milliseconds: 800),
                            decoration:BoxDecoration(color:Colors.orange,borderRadius: BorderRadius.circular(10), ),
                            width: WIDTH-10,
                            height: HEIGHT-10,
                            curve: Curves.linear,
                          ),
                        ) ,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child:Container( 
                          width: WIDTH,
                          height: HEIGHT,
                          child: OutlineButton.icon(    
                            label: Text("Starting location",style: new TextStyle(fontSize:TEXT_SIZE,color:new_colors_starting)),
                            icon:Icon(Icons.location_city, color:new_colors_starting,size: ICON_SIZE,),
                            onPressed: (){
                              setState(() {
                                whoSelected=0;
                                Aligne= Alignment.bottomLeft;
                                new_colors_starting=Colors.white;
                                new_colors_current=Colors.grey;
                                new_colors_settings=Colors.grey;
                              });
                            }
                          )
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child:Container( 
                          width: WIDTH,
                          height: HEIGHT,
                          child: OutlineButton.icon(    
                            label: Text("Current Location",style: new TextStyle(fontSize:TEXT_SIZE,color:new_colors_current)),
                            icon:Icon(Icons.my_location, color:new_colors_current,size: ICON_SIZE,),
                            onPressed: (){
                              setState(() {
                                whoSelected=1;
                                Aligne= Alignment.bottomCenter;
                                new_colors_starting=Colors.grey;
                                new_colors_current=Colors.white;
                                new_colors_settings=Colors.grey;
                              });
                            }
                          )
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child:Container( 
                          width: WIDTH,
                          height: HEIGHT,
                          child: OutlineButton.icon(    
                            label: Text("Settings",style: new TextStyle(fontSize:TEXT_SIZE,color:new_colors_settings)),
                            icon:Icon(Icons.settings, color:new_colors_settings,size: ICON_SIZE,),
                            onPressed: (){
                              setState(() {
                                whoSelected=2;
                                Aligne= Alignment.bottomRight;
                                new_colors_starting=Colors.grey;
                                new_colors_current=Colors.grey;
                                new_colors_settings=Colors.white;
                              });
                            }
                          )
                        ),
                      ),
                    ]
                  ),
                ),
              ]
            ),
          ],
        ),
      )
    );
  }
}