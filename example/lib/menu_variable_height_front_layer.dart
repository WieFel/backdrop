import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/// Showcase for a Material Backdrop acting as a menu.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    _TallPage(),
    ...List.generate(9, (i) => _ShortPage(i + 1)),
  ];

  final _nav = List.generate(
      10,
      (i) => ListTile(
          title: Text('Menu: open page #$i',
              style: TextStyle(color: Colors.white))));

  double get _heightFactor => _currentIndex == 0 ? 1 : (.1 * _currentIndex);

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Backdrop Demo',
      home: BackdropScaffold(
          appBar: BackdropAppBar(title: Text("AppBar is OK 👍")),
          frontLayer: _pages[_currentIndex],
          stickyFrontLayer: true,
          backLayerScrim: Colors.red.withOpacity(0.5),
          frontLayerScrim: Colors.green.withOpacity(0.5),
          frontLayerActiveFactor: _heightFactor,
          subHeader: BackdropSubHeader(title: Text('Subheader')),
          backLayer: BackdropNavigationBackLayer(
              items: _nav,
              onTap: (int position) =>
                  {setState(() => _currentIndex = position)},
              separatorBuilder: (_, __) => _MyDivider())));
}

class _MyDivider extends StatelessWidget {
  const _MyDivider();

  @override
  Widget build(BuildContext context) =>
      Divider(indent: 16, endIndent: 16, color: Colors.white);
}

/// When the front layer doesn't have much content, its height while revealed
/// is configurable via [BackdropScaffold.frontLayerActiveFactor].
class _ShortPage extends StatelessWidget {
  final int index;

  _ShortPage(this.index);

  @override
  Widget build(BuildContext context) => Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            Text("Page #$index is open with desired height."),
            const Flexible(child: FractionallySizedBox(heightFactor: 0.1)),
            Text("It looks better! 😄"),
            const Flexible(child: FractionallySizedBox(heightFactor: 0.1)),
            Text("But Page #0 still needs to be tall."),
          ]));
}

/// A front layer with a lot of content should reveal to show as much as possible.
class _TallPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
      children: List.generate(
          20,
          (index) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text("Tall page #0, lots of content 👍"))));
}
