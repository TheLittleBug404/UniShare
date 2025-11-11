import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_share/utils/utils/utils.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// Widget extends from the [ExpansionTile] to customize the expansionTile
class CustomExpansionTile extends StatefulWidget {
  /// holds the title, children, et., of the expansionTile
  const CustomExpansionTile({
    super.key,
    this.headerBackgroundColor,
    required this.subtitle,
    required this.title,
    this.backgroundColor,
    this.onExpansionChanged,
    required this.children2,
    this.initiallyExpanded = false,
    required this.iconLeading,
  });

  /// Holds the header name of expansion tile
  final Widget title;
  final Widget subtitle;

  /// Holds information of expand or collapse change
  final ValueChanged<bool>? onExpansionChanged;

  /// Children widget of the [CustomExpansionTile]
  final List<Widget> children2;

  /// [CustomExpansionTile]s background color
  final Color? backgroundColor;

  /// Holds the [CustomExpansionTile] title's background color
  final Color? headerBackgroundColor;
  final Widget iconLeading;

  /// Holds the information of initially expand/collapse
  final bool? initiallyExpanded;

  @override
  ExpansionTileState createState() => ExpansionTileState();
}

class ExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween = CurveTween(
    curve: Curves.easeOut,
  );
  static final Animatable<double> _easeInTween = CurveTween(
    curve: Curves.easeIn,
  );
  static final Animatable<double> _halfTween = Tween<double>(
    begin: 0.0,
    end: 0.5,
  );

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  // ignore: unused_field
  late Animation<Color?> _borderColor;
  // ignore: unused_field
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  // ignore: unused_field
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  get i => null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor = _controller.drive(
      _backgroundColorTween.chain(_easeOutTween),
    );

    _isExpanded = PageStorage.of(context).readState(context) == null
        ? widget.initiallyExpanded!
        : false;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {
            /// Expansion tile's state 'expand/Collapse' changed
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null) {
      widget.onExpansionChanged!(_isExpanded);
    }
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return Container(
      decoration: Utils.boxDecoraton(
        Get.isDarkMode ? Colors.black.withValues(alpha: 0.8) : Colors.white,
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
            data: IconThemeData(color: _iconColor.value),
            child: ListTile(
              onTap: _handleTap,
              dense: true,
              title: widget.title,
              leading: Container(
                padding: const EdgeInsets.only(right: 12.0),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      width: 1.0,
                      color: Get.isDarkMode ? Colors.white54 : Colors.black26,
                    ),
                  ),
                ),
                child: IconButton(
                  icon: widget.iconLeading,
                  onPressed: () {
                    //Get.to(EventoDetallePage(meet: widget.lm[widget.index]));
                  },
                ),
              ),
              subtitle: widget.subtitle,
              trailing: Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 5),
                child: RotationTransition(
                  turns: _iconTurns,
                  child: Icon(
                    Icons.expand_more,
                    color: widget.children2.isNotEmpty
                        ? Colors.grey
                        : Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          ClipRect(
            child: Align(heightFactor: _heightFactor.value, child: child),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween.end = Colors.transparent;
    _headerColorTween
      ..begin = theme.textTheme.titleMedium!.color
      ..end = theme.colorScheme.secondary;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.colorScheme.secondary;
    _backgroundColorTween.end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children2),
    );
  }
}
