import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class User {
  String lastName;
  String firstName;
  String age;

  User({this.lastName, this.firstName, this.age});
}

class UserProvider with ChangeNotifier {
  User _user;

  set user(value) {
    _user = value;
    notifyListeners();
  }

  get user => _user;
}

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _age;
  String _lastName;
  String _firstName;

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
          _age = user?.age;
          _lastName = user?.lastName;
          _firstName = user?.firstName;
          return Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => _saveUserData(userProvider),
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: TextEditingController()..text = user?.age,
                  onChanged: (value) => _age = value,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                  decoration: InputDecoration(
                    labelText: "Age",
                  ),
                ),
                TextField(
                  controller: TextEditingController()..text = user?.lastName,
                  onChanged: (value) => _lastName = value,
                  decoration: InputDecoration(
                    labelText: "Last name",
                  ),
                ),
                TextField(
                  controller: TextEditingController()..text = user?.firstName,
                  onChanged: (value) => _firstName = value,
                  decoration: InputDecoration(
                    labelText: "Fisrt name",
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveUserData(UserProvider userProvider) {
    userProvider.user = User(
      age: _age,
      lastName: _lastName,
      firstName: _firstName,
    );
    Navigator.of(context).pop();
  }
}
