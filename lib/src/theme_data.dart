import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Defines the style and delay mnemonics.
///
/// Used by [MnemonicTheme] to control the style and delay of mnemonics in a
/// widget subtree.
///
/// To obtain the current mnemonic theme, use [MnemonicTheme.of]. To convert a
/// mnemonic theme to a version with all the fields filled in, use
/// [MnemonicThemeData.fallback].
@immutable
class MnemonicThemeData with Diagnosticable {
  /// Creates a mnemonic theme data.
  const MnemonicThemeData({this.style, this.delay});

  /// Creates a mnemonic theme with some reasonable default values.
  ///
  /// The [style] is underlined, and the [delay] is 300 ms.
  const MnemonicThemeData.fallback()
      : style = const TextStyle(
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.solid),
        delay = const Duration(milliseconds: 300);

  /// Creates a copy of this mnemonic theme but with the given fields replaced
  /// with the new values.
  MnemonicThemeData copyWith({TextStyle? style, Duration? delay}) {
    return MnemonicThemeData(
      style: style ?? this.style,
      delay: delay ?? this.delay,
    );
  }

  /// Returns a new mnemonic theme that matches this mnemonic theme but with
  /// some values replaced by the non-null parameters of the given mnemonic
  /// theme. If the given mnemonic theme is null, simply returns this mnemonic
  /// theme.
  MnemonicThemeData merge(MnemonicThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      style: other.style,
      delay: other.delay,
    );
  }

  /// Called by [MnemonicTheme.of] to convert this instance to a
  /// [MnemonicThemeData] that fits the given [BuildContext].
  ///
  /// This method gives the ambient [MnemonicThemeData] a chance to update
  /// itself, after it's been retrieved by [MnemonicTheme.of], and before being
  /// returned as the final result.
  ///
  /// The default implementation returns this [MnemonicThemeData] as-is.
  MnemonicThemeData resolve(BuildContext context) => this;

  /// Whether all the properties of this object are non-null.
  bool get isConcrete => style != null && delay != null;

  /// The text style for mnemonics.
  final TextStyle? style;

  /// The delay for showing mnemonics.
  final Duration? delay;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MnemonicThemeData &&
        other.style == style &&
        other.delay == delay;
  }

  @override
  int get hashCode => Object.hash(style, delay);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    style?.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Duration>('delay', delay));
  }
}
