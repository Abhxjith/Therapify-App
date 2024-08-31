import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Text('History Page Content Here'),
      ),
    );
  }
}
