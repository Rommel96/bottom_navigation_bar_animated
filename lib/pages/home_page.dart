import 'package:bottom_navigation_bar_animated/widgets/bottom_bar_animated.dart';
import 'package:bottom_navigation_bar_animated/widgets/sub_menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  ValueNotifier<double> _heightSubMenu = ValueNotifier<double>(0.0);
  ValueNotifier<bool> _isVisibleBar = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBody: true,
      body: Center(
        child: ValueListenableBuilder(
            valueListenable: _selectedIndex,
            builder: (_, index, __) {
              _heightSubMenu.value = index == 2
                  ? (height - kBottomNavigationBarHeight * 4)
                  : height;
              return Stack(
                children: [
                  IndexedStack(
                    index: index,
                    children: [
                      Container(
                        color: Colors.pink,
                      ),
                      Container(
                        color: Colors.blueGrey,
                      ),
                      Container(
                        color: Colors.green,
                      ),
                      Container(
                        color: Colors.brown,
                      ),
                      Container(
                        color: Colors.greenAccent,
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    bottom: kBottomNavigationBarHeight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          _isVisibleBar.value = !_isVisibleBar.value;
                        },
                        child: ValueListenableBuilder(
                            valueListenable: _isVisibleBar,
                            builder: (_, value, __) {
                              return Icon(value
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_drop_up);
                            }),
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _heightSubMenu,
                    builder: (_, heigthSubMenu, __) {
                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        top: heigthSubMenu,
                        left: 0,
                        right: 0,
                        bottom: kBottomNavigationBarHeight,
                        child: index == 2
                            ? GestureDetector(
                                onVerticalDragUpdate:
                                    (DragUpdateDetails details) {
                                  if (details.primaryDelta > 5)
                                    _heightSubMenu.value = height;
                                },
                                child: SubMenu(
                                  height:
                                      (height - kBottomNavigationBarHeight * 4),
                                ),
                              )
                            : const SizedBox.shrink(),
                      );
                    },
                  )
                ],
              );
            }),
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _isVisibleBar,
        builder: (_, value, __) {
          return value
              ? BottomBarAnimated(
                  valueChanged: (index) => _selectedIndex.value = index,
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
