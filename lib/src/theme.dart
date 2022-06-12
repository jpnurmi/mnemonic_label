import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'theme_data.dart';

/// Controls the default style and delay of mnemonics in a widget subtree.
///
/// The mnemonic theme is honored by [Mnemonic] widgets.
class MnemonicTheme extends InheritedTheme {
  /// Creates a mnemonic theme that controls the style and delay of mnemonics in
  /// descendant widgets.
  const MnemonicTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Creates a mnemonic theme that controls the style and delay of mnemonics in
  /// descendant widgets, and merges in the current mnemonic theme, if any.
  static Widget merge({
    Key? key,
    required MnemonicThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return MnemonicTheme(
          key: key,
          data: _getInheritedMnemonicThemeData(context).merge(data),
          child: child,
        );
      },
    );
  }

  /// The style and delay to use for mnemonics in this subtree.
  final MnemonicThemeData data;

  /// The data from the closest instance of this class that encloses the given
  /// context, if any.
  ///
  /// If there is no ambient mnemonic theme, defaults to
  /// [MnemonicThemeData.fallback]. The returned [MnemonicThemeData] is concrete
  /// (all values are non-null; see [MnemonicThemeData.isConcrete]). An
  /// properties on the ambient mnemonic theme that are null get defaulted to
  /// the values specified on [MnemonicThemeData.fallback].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = MnemonicTheme.of(context);
  /// ```
  static MnemonicThemeData of(BuildContext context) {
    final mnemonicThemeData =
        _getInheritedMnemonicThemeData(context).resolve(context);
    return mnemonicThemeData.isConcrete
        ? mnemonicThemeData
        : mnemonicThemeData.copyWith(
            style: mnemonicThemeData.style ??
                const MnemonicThemeData.fallback().style,
            delay: mnemonicThemeData.delay ??
                const MnemonicThemeData.fallback().delay,
          );
  }

  static TextStyle styleOf(BuildContext context) {
    return of(context).style ?? const MnemonicThemeData.fallback().style!;
  }

  static Duration delayOf(BuildContext context) {
    return of(context).delay ?? const MnemonicThemeData.fallback().delay!;
  }

  static MnemonicThemeData _getInheritedMnemonicThemeData(
      BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<MnemonicTheme>();
    return theme?.data ?? const MnemonicThemeData.fallback();
  }

  @override
  bool updateShouldNotify(MnemonicTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MnemonicTheme(data: data, child: child);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    data.debugFillProperties(properties);
  }
}
