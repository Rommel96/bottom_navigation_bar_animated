import 'package:flutter/material.dart';

class SubMenu extends StatelessWidget {
  const SubMenu({Key key, this.height}) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: height,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text("Use Camera"),
          ),
          ListTile(
            leading: Icon(Icons.collections),
            title: Text("Choose from Gallery"),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Write a Story"),
          ),
        ],
      ),
    );
  }
}
