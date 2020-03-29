import 'package:flutter/material.dart';

class AnimatedNavBarController with ChangeNotifier {
  int initialItem;
  int _currentItem;

  AnimatedNavBarController({
    this.initialItem = 0,
  }) : _currentItem = initialItem;

  get currentItem => _currentItem;

  void jumpToItem(int index) {
    _currentItem = index;
    notifyListeners();
  }
}

class AnimatedNavBarItem {
  ImageProvider image;
  String text;

  AnimatedNavBarItem({
    @required this.image,
    @required this.text,
  });
}

final AnimatedNavBarController _defaultController = AnimatedNavBarController();

class AnimatedNavBar extends StatefulWidget {
  AnimatedNavBar({
    @required this.items,
    @required this.onTap,
    AnimatedNavBarController controller,
    this.selectedItemColor = Colors.white,
    this.selectedItemBackgroundColor = Colors.orange,
    this.defaultItemColor = Colors.grey,
  })  : assert(items.length >= 2),
        this.controller = controller ?? _defaultController;

  final List<AnimatedNavBarItem> items;
  final ValueChanged onTap;
  final AnimatedNavBarController controller;
  final Color selectedItemColor;
  final Color selectedItemBackgroundColor;
  final Color defaultItemColor;

  @override
  _AnimatedNavBarState createState() => _AnimatedNavBarState();
}

const NAVBAR_PADDING = 16.0;

class _AnimatedNavBarState extends State<AnimatedNavBar> {
  int _currentItem;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.controller.currentItem;
    widget.controller?.addListener(() {
      setState(() {
        _currentItem = widget.controller.currentItem;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(NAVBAR_PADDING),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        elevation: 8.0,
        child: Container(
          height: 48.0,
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              buildSelector(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(widget.items.length, (index) {
                  var item = widget.items[index];
                  bool isCurrentItem = index == _currentItem;

                  var color = isCurrentItem
                      ? widget.selectedItemColor
                      : widget.defaultItemColor;
                  return Expanded(
                    key: Key("AnimatedNavBarItem#$index"),
                    flex: 1,
                    child: InkWell(
                      onTap: () => _onItemTapped(index),
                      child: buildNavbarItem(color, item.image, item.text),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Builder buildSelector() {
    var screenSize = MediaQuery.of(context).size;
    var navBarWidth = screenSize.width - (NAVBAR_PADDING * 2);
    const itemHorizontalPadding = 4.0;
    var itemWidth =
        navBarWidth / widget.items.length - (itemHorizontalPadding * 2);
    var selectorWidth = itemWidth + itemHorizontalPadding;

    return Builder(
      builder: (context) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInCirc,
          transform: Matrix4.translationValues(
            (_currentItem * (selectorWidth + itemHorizontalPadding / 2))
                .toDouble(),
            0,
            0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 4.0, horizontal: itemHorizontalPadding),
            child: Material(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.orange,
              child: Container(
                width: selectorWidth,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildNavbarItem(Color color, ImageProvider image, String text) {
    return Container(
      height: 48.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: image,
                height: 24,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    widget.controller?._currentItem = index;
    setState(() {
      _currentItem = index;
    });
    widget.onTap(index);
  }
}
