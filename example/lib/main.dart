import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      title: 'Backdrop Demo',
      home: BackdropScaffold(
        title: Text("Backdrop Example"),
        backLayer: Center(
          child: Text("Back Layer"),
        ),
        frontLayer: Center(
          child: Text("Front Layer"),
        ),
        iconPosition: BackdropIconPosition.leading,
        actions: <Widget>[
          BackdropToggleButton(
            icon: AnimatedIcons.list_view,
          ),
        ],
      ),
    );
  }
}
