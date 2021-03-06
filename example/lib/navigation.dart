import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _pages = [Widget1(), Widget2()];

  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      title: 'Backdrop Demo',
      home: BackdropScaffold(
        appBar: PlatformAppBar(
          title: Text("Navigation Example"),
          leading: BackdropToggleButton(),
          material: (_, __) => MaterialAppBarData(elevation: 0.0),
          trailingActions: <Widget>[
            BackdropToggleButton(
              icon: AnimatedIcons.list_view,
            )
          ],
        ),
        stickyFrontLayer: true,
        frontLayer: _pages[_currentIndex],
        backLayer: BackdropNavigationBackLayer(
          items: [
            ListTile(title: Text("Widget 1")),
            ListTile(title: Text("Widget 2")),
          ],
          onTap: (int position) => {setState(() => _currentIndex = position)},
          separatorBuilder: (context, index) => Divider(),
        ),
      ),
    );
  }
}

class Widget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Widget 1"));
  }
}

class Widget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Widget 2"));
  }
}
