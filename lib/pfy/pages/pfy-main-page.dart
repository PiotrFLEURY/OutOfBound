import 'package:OutOfBounds/pfy/LocationProvider.dart';
import 'package:OutOfBounds/pfy/pages/current-location-page.dart';
import 'package:OutOfBounds/pfy/pages/settings-page.dart';
import 'package:OutOfBounds/pfy/pages/starting-location-page.dart';
import 'package:OutOfBounds/pfy/widgets/Header.dart';
import 'package:OutOfBounds/pfy/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class PfyMainPage extends StatefulWidget {
  @override
  _PfyMainPageState createState() => _PfyMainPageState();
}

const IMAGES = [
  "assets/images/mansion.png",
  "assets/images/map.png",
  "assets/images/gear.png"
];

class _PfyMainPageState extends State<PfyMainPage> {
  var _selectedIndex;
  PageController _pageController;
  AnimatedNavBarController _animatedNavBarController;
  double _currentPageValue;
  GlobalKey<ScaffoldState> _scaffoldKey;
  Location _location;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 1;
    _pageController = PageController(
      initialPage: _selectedIndex,
    );
    _currentPageValue = 1.0;
    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page;
      });
    });
    _scaffoldKey = GlobalKey();
    _animatedNavBarController = AnimatedNavBarController(
      initialItem: _selectedIndex,
    );
    initLocation();
    _location = Location()..changeSettings(interval: INTERVAL_MILLIS);
    notificationService.initNotifications(context);
  }

  @override
  Widget build(BuildContext context) {
    var headerHeight = MediaQuery.of(context).size.height / 4;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          drawer: buildDrawer(context),
          body: Stack(
            children: <Widget>[
              Consumer<LocationProvider>(
                builder: (context, locationProvider, _) =>
                    StreamBuilder<LocationData>(
                        stream: _location.onLocationChanged,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            locationProvider.onLocationChanged(snapshot.data);
                          }
                          return Container();
                        }),
              ),
              Padding(
                padding: EdgeInsets.only(top: headerHeight * .8),
                child: buildPages(),
              ),
              Header(
                height: headerHeight,
              ),
              buildMenuIcon(),
              Positioned(
                key: Key('headerIndicator'),
                top: headerHeight - 32,
                left: MediaQuery.of(context).size.width / 2 - 32,
                child: Container(
                  height: 64,
                  width: 64,
                  child: Material(
                    borderRadius: BorderRadius.circular(48.0),
                    elevation: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        IMAGES[_selectedIndex],
                        height: 48.0,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedNavBar(
                  controller: _animatedNavBarController,
                  items: <AnimatedNavBarItem>[
                    AnimatedNavBarItem(
                      image: AssetImage(IMAGES[0]),
                      text: "Starting location",
                    ),
                    AnimatedNavBarItem(
                      image: AssetImage(IMAGES[1]),
                      text: "Current location",
                    ),
                    AnimatedNavBarItem(
                      image: AssetImage(IMAGES[2]),
                      text: "Settings",
                    ),
                  ],
                  onTap: (index) => selectIndex(index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/pfy/profile");
            },
            child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("Profile"),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuIcon() {
    return InkWell(
      onTap: () {
        _openDrawer();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.menu,
          size: 24,
          color: Colors.black.withAlpha(150),
        ),
      ),
    );
  }

  void _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  Widget buildPages() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) => selectIndex(index),
      children: <Widget>[
        Transform.scale(
          scale: firstPageScale(),
          child: StartingLocationPage(),
        ),
        Transform.scale(
          scale: secondPageScale(),
          child: ActualLocationPage(),
        ),
        Transform.scale(
          scale: thirdPageScale(),
          child: SettingsPage(),
        ),
      ],
    );
  }

  double firstPageScale() {
    return _currentPageValue < 1 ? 1 - _currentPageValue : 0.0;
  }

  double secondPageScale() {
    return _currentPageValue > 1
        ? (1 - _currentPageValue % 1)
        : (_currentPageValue);
  }

  double thirdPageScale() {
    return _currentPageValue > 1 ? 1 - (2 - _currentPageValue) : 0.0;
  }

  void selectIndex(index) async {
    int gap = (_selectedIndex - index).abs();

    if (gap > 1) {
      _pageController.jumpToPage(index);
    } else {
      await _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
    }

    _animatedNavBarController.jumpToItem(index);

    setState(() {
      _selectedIndex = index;
    });
  }

  void initLocation() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }
}
