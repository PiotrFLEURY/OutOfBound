import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier {

  User _user;  

  /*Send MAJ*/
  set user(value) {
    _user = value;
    notifyListeners();
  } 
  /*Save data*/
  get user => _user;
}

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
   return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          User user = userProvider.user;
          if (user == null) {
            return Scaffold(
              body:
              Column(
                children: <Widget>[
                  Text("No user found"),
                  RaisedButton(
                    onPressed: () {
                      var _age = Random().nextInt(50).toString();
                      var _lastName ="TEST";
                      var _firstName = Random().nextInt(5).toString();
                      userProvider.user = User(
                        age: _age,
                        lastName: _lastName,
                        firstName: _firstName,
                      );
                    },
                    child: Text("Generate random user"),
                  )
                ],
              ),
            );
          }
          else {
            return Scaffold(
              body: Text(user.lastName),
            );
          }
        },
      ),
    );
  }
}

class User {

  String lastName;
  String firstName;
  String age;  
  
  User({
    this.lastName, 
    this.firstName, 
    this.age
    });
}