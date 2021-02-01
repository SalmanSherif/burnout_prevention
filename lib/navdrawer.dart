import 'package:flutter/material.dart';
import 'package:steadi_1_2/main.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Steadi V1',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Today View'),
            onTap: () => {
              Navigator.pop(context),
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp())),
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Monthly Overview'),
            onTap: () => {
              Navigator.pop(context),
              Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute())),
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {
              Navigator.pop(context),
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp())),
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {
              Navigator.pop(context),
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp())),
            },
          ),
        ],
      ),
    );
  }
}