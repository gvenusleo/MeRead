/// 可展开的 Card
/// 修改自 [ExpansionTile]

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class ExpansionCardController {
  ExpansionCardController();

  _ExpansionCardState? _state;

  bool get isExpanded {
    assert(_state != null);
    return _state!._isExpanded;
  }

  void expand() {
    assert(_state != null);
    if (!isExpanded) {
      _state!._toggleExpansion();
    }
  }

  void collapse() {
    assert(_state != null);
    if (isExpanded) {
      _state!._toggleExpansion();
    }
  }

  static ExpansionCardController of(BuildContext context) {
    final _ExpansionCardState? result =
        context.findAncestorStateOfType<_ExpansionCardState>();
    if (result != null) {
      return result._cardController;
    }
    throw Error();
  }

  static ExpansionCardController? maybeOf(BuildContext context) {
    return context
        .findAncestorStateOfType<_ExpansionCardState>()
        ?._cardController;
  }
}

class ExpansionCard extends StatefulWidget {
  const ExpansionCard({
    super.key,
    required this.title,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.controller,
    this.onTap,
  });

  final Widget title;
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget> children;
  final Widget? trailing;
  final bool initiallyExpanded;
  final bool maintainState;
  final ExpansionCardController? controller;
  final VoidCallback? onTap;

  @override
  State<ExpansionCard> createState() => _ExpansionCardState();
}

class _ExpansionCardState extends State<ExpansionCard>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);
  final ShapeBorderTween _borderTween = ShapeBorderTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();
  late AnimationController _animationController;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;
  late ExpansionCardController _cardController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _animationController.drive(_easeInTween);
    _iconTurns = _animationController.drive(_halfTween.chain(_easeInTween));
    _isExpanded = PageStorage.maybeOf(context)?.readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) {
      _animationController.value = 1.0;
    }
    assert(widget.controller?._state == null);
    _cardController = widget.controller ?? ExpansionCardController();
    _cardController._state = this;
  }

  @override
  void dispose() {
    _cardController._state = null;
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    final TextDirection textDirection =
        WidgetsLocalizations.of(context).textDirection;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String stateHint =
        _isExpanded ? localizations.expandedHint : localizations.collapsedHint;
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.maybeOf(context)?.writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
    SemanticsService.announce(stateHint, textDirection);
  }

  void _handleTap() {
    _toggleExpansion();
  }

  Widget _buildIcon(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns,
      child: const Icon(Icons.expand_more),
    );
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String onTapHint = _isExpanded
        ? localizations.expansionTileExpandedTapHint
        : localizations.expansionTileCollapsedTapHint;
    String? semanticsHint;
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        semanticsHint = _isExpanded
            ? '${localizations.collapsedHint}\n ${localizations.expansionTileExpandedHint}'
            : '${localizations.expandedHint}\n ${localizations.expansionTileCollapsedHint}';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        break;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Semantics(
          hint: semanticsHint,
          onTapHint: onTapHint,
          child: ListTile(
            onTap: widget.onTap,
            contentPadding: const EdgeInsets.only(left: 16, right: 28),
            title: widget.title,
            leading: IconButton(
              onPressed: _handleTap,
              icon: _buildIcon(context),
            ),
            trailing: widget.trailing,
          ),
        ),
        ClipRect(
          child: Align(
            alignment: expansionTileTheme.expandedAlignment ?? Alignment.center,
            heightFactor: _heightFactor.value,
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final ExpansionTileThemeData defaults = theme.expansionTileTheme;
    _borderTween
      ..begin = expansionTileTheme.collapsedShape ??
          const Border(
            top: BorderSide(color: Colors.transparent),
            bottom: BorderSide(color: Colors.transparent),
          )
      ..end = expansionTileTheme.collapsedShape ??
          Border(
            top: BorderSide(color: theme.dividerColor),
            bottom: BorderSide(color: theme.dividerColor),
          );
    _headerColorTween
      ..begin =
          expansionTileTheme.collapsedTextColor ?? defaults.collapsedTextColor
      ..end = expansionTileTheme.textColor ?? defaults.textColor;
    _iconColorTween
      ..begin =
          expansionTileTheme.collapsedIconColor ?? defaults.collapsedIconColor
      ..end = expansionTileTheme.iconColor ?? defaults.iconColor;
    _backgroundColorTween
      ..begin = expansionTileTheme.collapsedBackgroundColor
      ..end = expansionTileTheme.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final bool closed = !_isExpanded && _animationController.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: expansionTileTheme.childrenPadding ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.children,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _animationController.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
