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
        appBar: PlatformAppBar(
          title: Text("Backdrop Example"),
          leading: BackdropToggleButton(),
          material: (_, __) => MaterialAppBarData(elevation: 0.0),
          trailingActions: <Widget>[
            BackdropToggleButton(
              icon: AnimatedIcons.list_view,
            )
          ],
        ),
        backLayer: Center(
          child: Text("Back Layer"),
        ),
        subHeader: BackdropSubHeader(
          title: Text("Sub Header"),
        ),
        frontLayer: Center(
          child: Text("Front Layer"),
        ),
      ),
    );
  }
}
