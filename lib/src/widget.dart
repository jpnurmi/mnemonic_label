import 'dart:async';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'info.dart';
import 'theme.dart';

class Mnemonic extends StatefulWidget {
  const Mnemonic(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsAction,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final SemanticsAction? semanticsAction;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  @override
  State<Mnemonic> createState() => _MnemonicState();
}

class _MnemonicState extends State<Mnemonic> {
  var _mnemonic = const MnemonicInfo();
  var _mnemonicVisible = false;

  @override
  void initState() {
    super.initState();
    _initMnemonic();
  }

  void _initMnemonic() {
    final wasNotEmpty = _mnemonic.character.isNotEmpty;
    setState(() => _mnemonic = MnemonicInfo.parse(widget.data));
    if (wasNotEmpty != _mnemonic.character.isNotEmpty) {
      if (_mnemonic.character.isNotEmpty) {
        HardwareKeyboard.instance.addHandler(_handleKeyEvent);
      } else {
        HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
      }
    }
  }

  @override
  void didUpdateWidget(covariant Mnemonic oldWidget) {
    if (widget.data != oldWidget.data) {
      _initMnemonic();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    if (_mnemonic.character.isNotEmpty) {
      HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    }
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.altLeft) {
      if (event is KeyDownEvent) {
        final delay = MnemonicTheme.delayOf(context);
        Timer(delay, () {
          final renderObject = context.findRenderObject();
          _showMnemonic(_isAltPressed &&
              renderObject is _RenderMnemonicSemantics &&
              renderObject.isEnabled != false);
        });
      } else {
        _showMnemonic(false);
      }
    } else if (event is! KeyUpEvent && event.character == _mnemonic.character) {
      final renderObject = context.findRenderObject();
      if (renderObject is _RenderMnemonicSemantics) {
        renderObject.onSemanticsAction();
      }
    }
    return false;
  }

  bool get _isAltPressed => HardwareKeyboard.instance.logicalKeysPressed
      .contains(LogicalKeyboardKey.altLeft);

  void _showMnemonic(bool visible) {
    if (_mnemonicVisible == visible) return;
    setState(() => _mnemonicVisible = visible);
  }

  @override
  Widget build(BuildContext context) {
    return _MmemonicSemantics(
      label: _mnemonic.text,
      action: widget.semanticsAction ?? SemanticsAction.tap,
      child: Text.rich(
        _mnemonic.toTextSpan(
          style: _mnemonicVisible ? MnemonicTheme.styleOf(context) : null,
        ),
        style: widget.style,
        strutStyle: widget.strutStyle,
      ),
    );
  }
}

extension _MnemonicSpan on MnemonicInfo {
  TextSpan toTextSpan({TextStyle? style}) {
    if (index < 0 || style == null) {
      return TextSpan(text: text);
    }
    return TextSpan(
      children: [
        if (index > 0) TextSpan(text: text.substring(0, index)),
        TextSpan(text: text.substring(index, index + 1), style: style),
        if (index + 1 < text.length) TextSpan(text: text.substring(index + 1)),
      ],
    );
  }
}

class _MmemonicSemantics extends SingleChildRenderObjectWidget {
  const _MmemonicSemantics(
      {super.child, required this.label, required this.action});

  final String label;
  final SemanticsAction action;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMnemonicSemantics(label, action);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderMnemonicSemantics renderObject) {
    renderObject
      ..label = label
      ..action = action;
  }
}

class _RenderMnemonicSemantics extends RenderProxyBox {
  _RenderMnemonicSemantics(this.label, this._action);

  SemanticsAction get action => _action;
  SemanticsAction _action;
  set action(SemanticsAction value) {
    if (value == _action) return;
    _action = value;
    markNeedsSemanticsUpdate();
  }

  bool? get isEnabled => _enabled;

  String label;
  int? _parentId;
  bool? _enabled;

  void onSemanticsAction() {
    if (_enabled == false) return;
    if (_parentId == null) {
      debugPrint('''
Mnemonic was unable to find a parent SemanticNode that has $action.

Try specifying a different semantics action for the Mnemonic. For example:

    Mnemonic(
      'Scroll _Up',
      semanticsAction: SemanticsAction.scrollUp,
    ),

Or if the target widget is not an ancestor, try using MergeSemantics to make the
target widget's semantics visible to Mnemonic. For example:

    MergeSemantics(
      child: Row(
        children: [
          Checkbox(...),
          const Mnemonic('_Checkbox'),
        ],
      ),
    )
''');
      return;
    }
    PlatformDispatcher.instance.onSemanticsAction
        ?.call(_parentId!, action, null);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isSemanticBoundary = true;
  }

  @override
  void assembleSemanticsNode(SemanticsNode node, SemanticsConfiguration config,
      Iterable<SemanticsNode> children) {
    _parentId = null;
    _enabled = null;

    var parent = node.parent;
    while (parent != null) {
      if (parent.hasFlag(SemanticsFlag.hasEnabledState)) {
        _enabled = parent.hasFlag(SemanticsFlag.hasEnabledState)
            ? parent.hasFlag(SemanticsFlag.isEnabled)
            : null;
        if (_enabled == false) break;
      }
      if (parent.getSemanticsData().hasAction(_action)) {
        _parentId = parent.id;
        break;
      }
      parent = parent.parent;
    }
    if (node.parent == null) {
      scheduleMicrotask(markNeedsSemanticsUpdate);
    }
    super.assembleSemanticsNode(node, config, children);
  }
}
