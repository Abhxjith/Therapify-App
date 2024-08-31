import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Text('User Profile Page Content Here'),
      ),
    );
  }
}
