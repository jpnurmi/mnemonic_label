import 'package:flutter/services.dart';

class MnemonicInfo {
  const MnemonicInfo({this.index = -1, this.text = '', this.character = ''});

  factory MnemonicInfo.parse(String text) => _parseMnemonic(text);

  final int index;
  final String text;
  final String character;
}

MnemonicInfo _parseMnemonic(String text) {
  bool isWhitespace(int i) {
    return TextLayoutMetrics.isWhitespace(text.codeUnitAt(i));
  }

  bool isMnemonic(int i) {
    return i + 1 < text.length &&
        text[i] == '_' &&
        text[i + 1] != '_' &&
        !isWhitespace(i + 1);
  }

  bool isEscape(int i) {
    return i + 1 < text.length && text[i] == '_' && text[i + 1] == '_';
  }

  var idx = -1;
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; ++i) {
    if (isMnemonic(i)) {
      idx = buffer.length;
      buffer.write(text.substring(i + 1));
      break;
    }
    if (isEscape(i)) ++i;
    buffer.write(text[i]);
  }

  text = buffer.toString();

  return MnemonicInfo(
    index: idx,
    text: text,
    character: idx >= 0 && idx < text.length ? text[idx].toLowerCase() : '',
  );
}
