import 'package:bottom_navigation_bar_animated/controllers/position_controller.dart';
import 'package:bottom_navigation_bar_animated/data/item_model.dart';
import 'package:bottom_navigation_bar_animated/widgets/item_bottom_bar.dart';
import 'package:bottom_navigation_bar_animated/widgets/my_custom_painter.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

class BottomBarAnimated extends StatefulWidget {
  const BottomBarAnimated({Key key, this.valueChanged}) : super(key: key);
  final ValueChanged valueChanged;

  @override
  _BottomBarAnimatedState createState() => _BottomBarAnimatedState();
}

class _BottomBarAnimatedState extends State<BottomBarAnimated>
    with TickerProviderStateMixin {
  BoxPositionController _controller;
  final int _initialIndex = 0;
  final Color _unSelectColor = Colors.transparent;
  final Color _selectedColor = Colors.black;
  //final EdgeInsets _boxPadding = EdgeInsets.only(left: 13, right: 10);

  double _selectedItemWidthMax = 0;
  double _customDrawingForWidth = 0;

  List<Rect> selectedItemsRects = List<Rect>();

  List<GlobalKey> titlesKeys = List<GlobalKey>();
  List<GlobalKey> iconsKeys = List<GlobalKey>();
  List<double> titleWidths = List<double>();
  List<double> iconsWidths = List<double>();

  @override
  void initState() {
    itemsList.forEach((_) {
      titlesKeys.add(GlobalKey());
      iconsKeys.add(GlobalKey());
    });
    _initController();
    super.initState();
  }

  _initController() {
    if (_controller != null) {
      _controller.removeListener(_valueControllerPositionChange);
    }
    _controller = BoxPositionController(initPosition: 0);
    _controller.defaultAnimationDuration = const Duration(milliseconds: 500);

    // TODO remove vsync from here
    _controller.vsync = this;

    _controller.addListener(_valueControllerPositionChange);
    if (_initialIndex != null) {
      _controller.lastPosition = _initialIndex;
    }
  }

  _updateDrawInfoToPaint() {
    titleWidths.clear();
    iconsWidths.clear();
    selectedItemsRects.clear();

    titlesKeys.forEach((key) {
      RenderBox renderBox = key.currentContext.findRenderObject();
      titleWidths.add(renderBox.size.width);
    });
    iconsKeys.forEach((key) {
      RenderBox renderBox = key.currentContext.findRenderObject();
      iconsWidths.add(math.max(1, renderBox.size.width));
    });
    _calculateRectsForBoxContainer();
    double currentWidgetWidth = MediaQuery.of(context).size.width;
    if (_customDrawingForWidth != currentWidgetWidth) {
      setState(() {
        _customDrawingForWidth = currentWidgetWidth;
      });
    }
  }

  void _calculateRectsForBoxContainer() {
    _selectedItemWidthMax = 0;
    for (var index = 0; index < itemsList.length; index++) {
      _selectedItemWidthMax =
          math.max(_selectedItemWidthMax, _itemWidth(index));
    }
    _selectedItemWidthMax += 0;

    for (var index = 0; index < itemsList.length; index++) {
      selectedItemsRects.add(_rectForSelectedItem(index));
    }
  }

  Rect _rectForSelectedItem(int index) {
    double shrinkedItemWidth =
        (MediaQuery.of(context).size.width - _selectedItemWidthMax) /
            (itemsList.length - 1);
    double paddingForEmptySpace =
        (_selectedItemWidthMax - _itemWidth(index)) / 2;

    return Rect.fromLTWH(
        shrinkedItemWidth * index + paddingForEmptySpace,
        (kBottomNavigationBarHeight * 0.8 - kBottomNavigationBarHeight * 0.6) /
            2,
        _selectedItemWidthMax - 2 * paddingForEmptySpace,
        kBottomNavigationBarHeight * 0.6);
  }

  double _itemWidth(int index) => iconsWidths[index] + 6 + titleWidths[index];

  void _valueControllerPositionChange() {
    if (_controller.targetPosition != null &&
            (_controller.absolutePosition <= _controller.targetPosition &&
                _controller.targetPosition - _controller.lastPosition < 0) ||
        (_controller.absolutePosition >= _controller.targetPosition &&
            _controller.targetPosition - _controller.lastPosition > 0)) {
      _controller.lastPosition = _controller.targetPosition;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_valueControllerPositionChange);
  }

  @override
  Widget build(BuildContext context) {
    final double unselectedItemWidth =
        (MediaQuery.of(context).size.width - _selectedItemWidthMax) /
            (itemsList.length - 1);

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _updateDrawInfoToPaint());

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: kBottomNavigationBarHeight,
      ),
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Positioned(
              top: 6,
              child: CustomPaint(
                painter: _buildPainterSelected(),
                child: Container(
                  height: kBottomNavigationBarHeight * 0.95,
                ),
              ),
            ),
            Row(
              children: itemsList.map((item) {
                final index = itemsList.indexOf(item);
                return ItemBoxBar(
                  item: item,
                  boxWidth: unselectedItemWidth,
                  boxSelectedWidth: _selectedItemWidthMax,
                  iconKey: iconsKeys[index],
                  titleKey: titlesKeys[index],
                  titleWidth: titleWidths.length > 0 ? titleWidths[index] : 0,
                  iconWidth: iconsWidths.length > 0 ? iconsWidths[index] : 0,
                  selectProgress: _controller.itemSelectedProgress(index).abs(),
                  onPressed: () {
                    _controller.lastPosition = _controller.targetPosition;
                    _controller.targetPosition = index;
                    _controller.animateToPosition(index);
                    widget.valueChanged(index);
                  },
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }

  MyCustomPainter _buildPainterSelected() {
    if (selectedItemsRects.length == 0) {
      return null;
    }

    Rect lastRect = selectedItemsRects[_controller.lastPosition];
    if (_controller.selectionNotGoingAnywhere) {
      return _painterSelected(lastRect, _selectedColor);
    }

    Rect targetRect = selectedItemsRects[_controller.targetPosition];
    Rect mergedRect =
        Rect.lerp(lastRect, targetRect, _controller.progressToTargetPosition);

    Color mergedColor = Color.lerp(
        _unSelectColor, _selectedColor, _controller.progressToTargetPosition);

    return _painterSelected(mergedRect, mergedColor);
  }

  MyCustomPainter _painterSelected(Rect rect, Color color) {
    //double y = rect.top + rect.height / 2 + rect.height * 0.15;
    return MyCustomPainter(
      // startX: rect.left + _boxPadding.left,
      // startY: y,
      // endX: rect.left + rect.width - _boxPadding.right - 15,
      // endY: y,
      // radius: rect.height / 2,
      color: color,
      rect: rect,
    );
  }
}
