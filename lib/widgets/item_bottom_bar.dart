import 'dart:ui';

import 'package:bottom_navigation_bar_animated/data/item_model.dart';
import 'package:flutter/material.dart';

class ItemBoxBar extends StatelessWidget {
  const ItemBoxBar({
    Key key,
    @required this.item,
    @required this.onPressed,
    @required this.selectProgress,
    this.titleKey,
    this.iconKey,
    this.boxWidth,
    this.boxSelectedWidth,
    this.iconWidth,
    this.titleWidth,
  }) : super(key: key);

  final ItemBottomBar item;
  final double selectProgress;
  final VoidCallback onPressed;
  final GlobalKey titleKey;
  final GlobalKey iconKey;
  final double boxWidth;
  final double boxSelectedWidth;
  final double iconWidth;
  final double titleWidth;

  @override
  Widget build(BuildContext context) {
    final iconPos = _getIconPos();
    final titlePos = _getTitlePos();
    final height = kBottomNavigationBarHeight;
    final isOnlyIcon = item.title.isEmpty;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: _getBoxWidth(),
        height: height ?? 0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: !isOnlyIcon ? iconPos : iconPos + 2,
              child: Container(
                padding: const EdgeInsets.all(4),
                key: iconKey,
                child: Icon(
                  item.iconData,
                  color: selectProgress == 1 ? Colors.white : Colors.black,
                ),
              ),
            ),
            Positioned(
              left: titlePos,
              child: !isOnlyIcon
                  ? Container(
                      key: titleKey,
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        item.title,
                        style: TextStyle(
                          color: selectProgress == 1
                              ? Colors.white
                              : Colors.transparent,
                        ),
                      ),
                    )
                  : Container(
                      key: titleKey,
                    ),
            )
          ],
        ),
      ),
    );
  }

  double _getIconPos() {
    if (boxWidth == null) {
      return 0;
    } else {
      return lerpDouble(_getIconShrinkedPosition(), _getIconSelectedPosition(),
          selectProgress);
    }
  }

  double _getTitlePos() {
    if (boxWidth == null) {
      return iconWidth + 6;
    } else {
      double fadingOffset = 50.0 * (1 - selectProgress);
      return _getIconSelectedPosition() + iconWidth + -fadingOffset;
    }
  }

  double _getBoxWidth() {
    double width = boxWidth ?? iconWidth;
    double selectedWidth = boxSelectedWidth ?? iconWidth + 6 + titleWidth;
    return lerpDouble(width, selectedWidth, selectProgress);
  }

  double _getIconAndTextWidth() => iconWidth + 6 + titleWidth;

  double _getIconSelectedPosition() =>
      (boxSelectedWidth - _getIconAndTextWidth()) / 2;

  double _getIconShrinkedPosition() => (boxWidth - iconWidth) / 2;
}
