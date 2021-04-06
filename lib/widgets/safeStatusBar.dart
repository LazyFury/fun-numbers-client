import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SafeStatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(color: Colors.grey[100]),
      height: MediaQuery.of(context).padding.top,
    );
  }
}

class SafeAreaBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(color: Colors.grey[100]),
      height: MediaQuery.of(context).padding.bottom,
    );
  }
}
