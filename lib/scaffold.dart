import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/scheduler.dart';

/// This class is an InheritedWidget that exposes state of [BackdropScaffold]
/// [BackdropScaffoldState] to be accessed from anywhere below the widget tree.
///
/// It can be used to explicitly call backdrop functionality like fling,
/// concealBackLayer, revealBackLayer, etc.
///
/// Example:
/// ```dart
/// Backdrop.of(context).fling();
/// ```
class Backdrop extends InheritedWidget {
  /// Holds the state of this widget.
  final BackdropScaffoldState data;

  /// Creates a [Backdrop] instance.
  Backdrop({Key key, @required this.data, @required Widget child})
      : super(key: key, child: child);

  /// Provides access to the state from everywhere in the widget tree.
  static BackdropScaffoldState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Backdrop>().data;

  @override
  bool updateShouldNotify(Backdrop old) => true;
}

/// Implements the basic functionality of backdrop.
///
/// This class internally uses [Scaffold]. It allows to set a back layer and a
/// front layer and manage the switching between the two. The implementation is
/// inspired by the
/// [material backdrop component](https://material.io/components/backdrop/).
///
/// Usage example:
/// ```dart
/// Widget build(BuildContext context) {
///   return MaterialApp(
///     title: 'Backdrop Demo',
///     home: BackdropScaffold(
///       appBar: BackdropAppBar(
///         title: Text("Backdrop Example"),
///         actions: <Widget>[
///           BackdropToggleButton(
///             icon: AnimatedIcons.list_view,
///           )
///         ],
///       ),
///       backLayer: Center(
///         child: Text("Back Layer"),
///       ),
///       frontLayer: Center(
///         child: Text("Front Layer"),
///       ),
///     ),
///   );
/// }
/// ```
///
/// See also:
///  * [Scaffold], which is the plain scaffold used in material apps.
class BackdropScaffold extends StatefulWidget {
  /// Deprecated. Use [animationController].
  ///
  /// Can be used to customize the behaviour of the backdrop animation.
  @Deprecated("See animationController. This was deprecated after v0.5.1")
  final AnimationController controller;

  /// Can be used to customize the behaviour of the backdrop animation.
  final AnimationController animationController;

  /// Deprecated. Use [BackdropAppBar.title].
  ///
  /// The widget assigned to the [Scaffold]'s [AppBar.title].
  final Widget title;

  /// Content that should be displayed on the back layer.
  final Widget backLayer;

  /// The widget that is shown on the front layer.
  final Widget frontLayer;

  /// The widget shown at the top of the front layer.
  ///
  /// When the front layer is minimized (back layer revealed), the entire [subHeader] will be visible unless
  /// [headerHeight] is specified.
  final Widget subHeader;

  /// If true, the scrim applied to the front layer while minimized (back layer revealed) will not
  /// cover the [subHeader].  See [frontLayerScrim].
  ///
  /// Defaults to true.
  final bool subHeaderAlwaysActive;

  /// Deprecated. Use [BackdropAppBar.actions].
  ///
  /// Actions passed to [AppBar.actions].
  final List<Widget> actions;

  /// Defines the front layer's height when minimized (back layer revealed)).
  /// Defaults to measured height of [subHeader] if provided, else 32.
  ///
  /// To automatically use the difference of the screen height and back layer's height,
  /// see [stickyFrontLayer].  Note [headerHeight] is ignored if it is less
  /// than the available size and [stickyFrontLayer] is `true`.
  ///
  /// To vary the front layer's height when active (back layer concealed),
  /// see [frontLayerActiveFactor].
  final double headerHeight;

  /// Defines the [BorderRadius] applied to the front layer.
  ///
  /// Defaults to
  /// ```dart
  /// const BorderRadius.only(
  ///     topLeft: Radius.circular(16),
  ///     topRight: Radius.circular(16),
  /// )
  /// ```
  final BorderRadius frontLayerBorderRadius;

  /// A flag indicating whether the front layer should stick to the height of
  /// the back layer when being opened.
  ///
  /// This parameter has no effect if the back layer's measured height
  /// is greater than or equal to the screen height.
  final bool stickyFrontLayer;

  /// Flag indicating whether the back layer should be revealed at the beginning
  /// or not. Setting [revealBackLayerAtStart] to `true` reveals the back layer
  /// at start. This property has no effect if a custom [animationController]
  /// is set.
  ///
  /// Defaults to `false`.
  final bool revealBackLayerAtStart;

  /// The animation curve passed to [Tween.animate] when triggering
  /// the backdrop animation.
  ///
  /// Defaults to [Curves.ease].
  final Curve animationCurve;

  /// The reverse animation curve passed to [Tween.animate].
  ///
  /// If not set, [animationCurve.flipped] is used.
  final Curve reverseAnimationCurve;

  /// Background [Color] for the back layer.
  ///
  /// Defaults to `Theme.of(context).primaryColor`.
  final Color backLayerBackgroundColor;

  /// Background [Color] for the front layer.
  ///
  /// If null, the color is handled automatically according to the theme.
  final Color frontLayerBackgroundColor;

  /// Fraction of the available height the front layer will occupy,
  /// when active (back layer concealed).  Clamped to (0, 1).
  ///
  /// Note the front layer will not fully conceal the back layer when
  /// this value is less than 1.  A scrim will cover the
  /// partially concealed back layer; see [backLayerScrim].
  ///
  /// Defaults to 1.
  final double frontLayerActiveFactor;

  /// Deprecated.  Use [frontLayerScrim] instead.
  @Deprecated('Replace with frontLayerScrim.')
  final Color inactiveOverlayColor;

  /// Deprecated.  Use [frontLayerScrim] instead.
  @Deprecated('Replace with frontLayerScrim.  Use Color#withOpacity, or pass'
      'the opacity value in the Color constructor.')
  final double inactiveOverlayOpacity;

  /// Defines the scrim color for the front layer when minimized
  /// (revealing the back layer) and animating.  Defaults to [Colors.white70].
  ///
  /// See [subHeaderAlwaysActive] to leave the [subHeader] outside the scrim.
  final Color frontLayerScrim;

  /// Defines the scrim color for the back layer when partially concealed
  /// (with [frontLayerActiveFactor] less than 1).
  ///
  /// Defaults to [Colors.black54].
  final Color backLayerScrim;

  /// Will be called when [backLayer] has been concealed.
  final VoidCallback onBackLayerConcealed;

  /// Will be called when [backLayer] has been revealed.
  final VoidCallback onBackLayerRevealed;

  // ------------- PROPERTIES TAKEN OVER FROM SCAFFOLD ------------- //

  /// A key to use when building the [Scaffold].
  final GlobalKey<ScaffoldState> scaffoldKey;

  /// See [Scaffold.appBar].
  final PlatformAppBar appBar;

  /// [MaterialScaffoldData] passed to PlatformScaffold underlying the
  /// [BackdropScaffold] implementation.
  final MaterialScaffoldData materialScaffoldData;

  /// [CupertinoPageScaffoldData] passed to PlatformScaffold underlying the
  /// [BackdropScaffold] implementation.
  final CupertinoPageScaffoldData cupertinoPageScaffoldData;

  /// Creates a backdrop scaffold to be used as a material widget.
  BackdropScaffold({
    Key key,
    @Deprecated("See animationController. This was deprecated after v0.5.1")
        this.controller,
    this.animationController,
    @Deprecated("Replace by use of BackdropAppBar. See BackdropAppBar.title."
        "This feature was deprecated after v0.2.17.")
        this.title,
    this.scaffoldKey,
    this.appBar,
    this.backLayer,
    this.frontLayer,
    this.subHeader,
    this.subHeaderAlwaysActive = true,
    @Deprecated("Replace by use of BackdropAppBar. See BackdropAppBar.actions."
        "This feature was deprecated after v0.2.17.")
        this.actions = const <Widget>[],
    this.headerHeight,
    this.frontLayerBorderRadius = const BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
    ),
    this.stickyFrontLayer = false,
    this.revealBackLayerAtStart = false,
    this.animationCurve = Curves.ease,
    this.reverseAnimationCurve,
    this.frontLayerBackgroundColor,
    double frontLayerActiveFactor = 1,
    this.backLayerBackgroundColor,
    @Deprecated('See frontLayerScrim. This was deprecated after v0.4.7.')
        this.inactiveOverlayColor = const Color(0xFFEEEEEE),
    @Deprecated('See frontLayerScrim. This was deprecated after v0.4.7.')
        this.inactiveOverlayOpacity = 0.7,
    this.frontLayerScrim = Colors.white70,
    this.backLayerScrim = Colors.black54,
    this.onBackLayerConcealed,
    this.onBackLayerRevealed,
    this.materialScaffoldData,
    this.cupertinoPageScaffoldData,
  })  : assert(inactiveOverlayOpacity >= 0.0 && inactiveOverlayOpacity <= 1.0),
        frontLayerActiveFactor = frontLayerActiveFactor.clamp(0, 1).toDouble(),
        super(key: key);

  @override
  BackdropScaffoldState createState() => BackdropScaffoldState();
}

/// This class is used to represent the internal state of [BackdropScaffold].
/// It provides access to the functionality for triggering backdrop. As well it
/// offers ways to retrieve the current state of the [BackdropScaffold]'s front-
/// or back layers (concealed/revealed).
///
/// An instance of this class is automatically created with the use of
/// [BackdropScaffold] and can be accessed using `Backdrop.of(context)` from
/// within the widget tree below [BackdropScaffold].
class BackdropScaffoldState extends State<BackdropScaffold>
    with SingleTickerProviderStateMixin {
  bool _shouldDisposeAnimationController = false;
  AnimationController _animationController;
  ColorTween _backLayerScrimColorTween;

  /// Key for accessing the [ScaffoldState] of [BackdropScaffold]'s internally
  /// used [Scaffold].
  GlobalKey<ScaffoldState> scaffoldKey;
  double _backPanelHeight = 0;
  double _subHeaderHeight = 0;

  /// Deprecated. Use [animationController] instead.
  ///
  /// [AnimationController] used for the backdrop animation.
  @Deprecated("Replace by the use of `animationController`."
      "This feature was deprecated after v0.5.1.")
  AnimationController get controller => _animationController;

  /// [AnimationController] used for the backdrop animation.
  ///
  /// Defaults to
  /// ```dart
  /// AnimationController(
  ///         vsync: this, duration: Duration(milliseconds: 200), value: 1)
  /// ```
  AnimationController get animationController => _animationController;

  @override
  void initState() {
    super.initState();
    // initialize scaffoldKey
    scaffoldKey = widget.scaffoldKey ?? GlobalKey<ScaffoldState>();
    // initialize _controller
    _animationController = widget.animationController ??
        widget.controller ??
        AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 200),
          value: widget.revealBackLayerAtStart ? 0 : 1,
        );
    if (widget.animationController == null && widget.controller == null) {
      _shouldDisposeAnimationController = true;
    }

    _backLayerScrimColorTween = _buildBackLayerScrimColorTween();

    _animationController.addListener(() => setState(() {
          // This is intentionally left empty. The state change itself takes
          // place inside the AnimationController, so there's nothing to update.
          // All we want is for the widget to rebuild and read the new animation
          // state from the AnimationController.
          // see https://github.com/flutter/flutter/pull/55414/commits/72d7d365be6639271a5e88ee3043b92833facb79
        }));
  }

  @override
  void didUpdateWidget(covariant BackdropScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.backLayerScrim != widget.backLayerScrim) {
      _backLayerScrimColorTween = _buildBackLayerScrimColorTween();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_shouldDisposeAnimationController) _animationController.dispose();
  }

  /// Deprecated. Use [isBackLayerConcealed] instead.
  ///
  /// Whether the back layer is concealed or not.
  @Deprecated("Replace by the use of `isBackLayerConcealed`."
      "This feature was deprecated after v0.3.2.")
  bool get isTopPanelVisible => isBackLayerConcealed;

  /// Whether the back layer is concealed or not.
  bool get isBackLayerConcealed =>
      animationController.status == AnimationStatus.completed ||
      animationController.status == AnimationStatus.forward;

  /// Deprecated. Use [isBackLayerRevealed] instead.
  ///
  /// Whether the back layer is revealed or not.
  @Deprecated("Replace by the use of `isBackLayerRevealed`."
      "This feature was deprecated after v0.3.2.")
  bool get isBackPanelVisible => isBackLayerRevealed;

  /// Whether the back layer is revealed or not.
  bool get isBackLayerRevealed =>
      animationController.status == AnimationStatus.dismissed ||
      animationController.status == AnimationStatus.reverse;

  /// Toggles the backdrop functionality.
  ///
  /// If the back layer was concealed, it is animated to the "revealed" state
  /// by this function. If it was revealed, this function will animate it to
  /// the "concealed" state.
  void fling() {
    FocusScope.of(context)?.unfocus();
    if (isBackLayerConcealed) {
      revealBackLayer();
    } else {
      concealBackLayer();
    }
  }

  /// Deprecated. Use [revealBackLayer] instead.
  ///
  /// Animates the back layer to the "revealed" state.
  @Deprecated("Replace by the use of `revealBackLayer`."
      "This feature was deprecated after v0.3.2.")
  void showBackLayer() => revealBackLayer();

  /// Animates the back layer to the "revealed" state.
  void revealBackLayer() {
    if (isBackLayerConcealed) {
      animationController.animateBack(-1);
      widget.onBackLayerRevealed?.call();
    }
  }

  /// Deprecated. Use [concealBackLayer] instead.
  ///
  /// Animates the back layer to the "concealed" state.
  @Deprecated("Replace by the use of `concealBackLayer`."
      "This feature was deprecated after v0.3.2.")
  void showFrontLayer() => concealBackLayer();

  /// Animates the back layer to the "concealed" state.
  void concealBackLayer() {
    if (isBackLayerRevealed) {
      animationController.animateTo(1);
      widget.onBackLayerConcealed?.call();
    }
  }

  double get _headerHeight {
    // if defined then use it
    if (widget.headerHeight != null) return widget.headerHeight;

    // if no subHeader then 32
    if (widget.subHeader == null) return 32;

    // if subHeader then height of subHeader
    return _subHeaderHeight;
  }

  Animation<RelativeRect> _getPanelAnimation(
      BuildContext context, BoxConstraints constraints) {
    double backPanelHeight, frontPanelHeight;
    final availableHeight = constraints.biggest.height - _headerHeight;
    if (widget.stickyFrontLayer && _backPanelHeight < availableHeight) {
      // height is adapted to the height of the back panel
      backPanelHeight = _backPanelHeight;
      frontPanelHeight = -_backPanelHeight;
    } else {
      // height is set to fixed value defined in widget.headerHeight
      backPanelHeight = availableHeight;
      frontPanelHeight = -backPanelHeight;
    }
    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(0, backPanelHeight, 0, frontPanelHeight),
      end: RelativeRect.fromLTRB(
          0, availableHeight * (1 - widget.frontLayerActiveFactor), 0, 0),
    ).animate(CurvedAnimation(
        parent: animationController,
        curve: widget.animationCurve,
        reverseCurve:
            widget.reverseAnimationCurve ?? widget.animationCurve.flipped));
  }

  Widget _buildInactiveLayer(BuildContext context) {
    return Offstage(
      offstage: animationController.status == AnimationStatus.completed,
      child: FadeTransition(
        opacity: Tween<double>(begin: 1, end: 0).animate(animationController),
        child: GestureDetector(
          onTap: () => fling(),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: <Widget>[
              // if subHeaderAlwaysActive then do not apply frontLayerScrim for area with _subHeaderHeight
              widget.subHeader != null && widget.subHeaderAlwaysActive
                  ? Container(height: _subHeaderHeight)
                  : Container(),
              Expanded(
                child: Container(
                    color: widget.frontLayerScrim ??
                        widget.inactiveOverlayColor
                            .withOpacity(widget.inactiveOverlayOpacity)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackPanel() {
    return Stack(
      children: [
        FocusScope(
          canRequestFocus: isBackLayerRevealed,
          child: Material(
            color: widget.backLayerBackgroundColor ??
                Theme.of(context).primaryColor,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: _MeasureSize(
                    onChange: (size) =>
                        setState(() => _backPanelHeight = size.height),
                    child: widget.backLayer ?? Container(),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_hasBackLayerScrim) _buildBackLayerScrim(),
      ],
    );
  }

  Widget _buildFrontPanel(BuildContext context) {
    return Material(
      color: widget.frontLayerBackgroundColor,
      elevation: 1,
      borderRadius: widget.frontLayerBorderRadius,
      child: ClipRRect(
        borderRadius: widget.frontLayerBorderRadius,
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // subHeader
                _MeasureSize(
                  onChange: (size) =>
                      setState(() => _subHeaderHeight = size.height),
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.subtitle1,
                    child: widget.subHeader ?? Container(),
                  ),
                ),
                // frontLayer
                Flexible(child: widget.frontLayer),
              ],
            ),
            _buildInactiveLayer(context),
          ],
        ),
      ),
    );
  }

  Future<bool> _willPopCallback(BuildContext context) async {
    if (isBackLayerRevealed) {
      concealBackLayer();
      return null;
    }
    return true;
  }

  ColorTween _buildBackLayerScrimColorTween() => ColorTween(
        begin: Colors.transparent,
        end: widget.backLayerScrim,
      );

  Widget _buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _willPopCallback(context),
      child: PlatformScaffold(
        key: scaffoldKey,
        backgroundColor: widget.backLayerBackgroundColor,
        material: (_, __) => widget.materialScaffoldData,
        cupertino: (_, __) => widget.cupertinoPageScaffoldData,
        appBar: widget.appBar,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  _buildBackPanel(),
                  PositionedTransition(
                    rect: _getPanelAnimation(context, constraints),
                    child: _buildFrontPanel(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Container _buildBackLayerScrim() => Container(
      color: _backLayerScrimColorTween.evaluate(animationController),
      height: _backPanelHeight);

  bool get _hasBackLayerScrim =>
      isBackLayerConcealed && widget.frontLayerActiveFactor < 1;

  @override
  Widget build(BuildContext context) {
    return Backdrop(
      data: this,
      child: Builder(
        builder: (context) => _buildBody(context),
      ),
    );
  }
}

/// Widget to get size of child widget
/// Credit: https://stackoverflow.com/a/60868972/2554745
class _MeasureSize extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onChange;

  const _MeasureSize({
    Key key,
    @required this.onChange,
    @required this.child,
  }) : super(key: key);

  @override
  _MeasureSizeState createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  final widgetKey = GlobalKey();
  Size oldSize;

  void _notify() {
    final context = widgetKey.currentContext;
    if (context == null) return;

    final newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onChange(newSize);
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) => _notify());
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        SchedulerBinding.instance.addPostFrameCallback((_) => _notify());
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Container(
          key: widgetKey,
          child: widget.child,
        ),
      ),
    );
  }
}
