import 'package:flutter/material.dart';

class ItemBottomBar {
  final IconData iconData;
  final String title;

  const ItemBottomBar({
    @required this.iconData,
    this.title,
  });
}

const List<ItemBottomBar> itemsList = [
  ItemBottomBar(
    iconData: Icons.home,
    title: "Home",
  ),
  ItemBottomBar(
    iconData: Icons.store,
    title: "Store",
  ),
  ItemBottomBar(
    iconData: Icons.add,
    title: "",
  ),
  ItemBottomBar(
    iconData: Icons.explore,
    title: "Explore",
  ),
  ItemBottomBar(
    iconData: Icons.person,
    title: "Profile",
  ),
];
