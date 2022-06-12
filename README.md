# mnemonic_label

https://en.wikipedia.org/wiki/Mnemonics_(keyboard)

```dart
ElevatedButton(
  onPressed: ...
  child: const Mnemonic('_OK'),
)
```

```dart
MergeSemantics(
  child: Row(
    children: [
      Checkbox(...),
      const Mnemonic('I _Agree'),
    ],
  ),
)
```

```dart
Mnemonic(
  '_Increase',
  semanticsAction: SemanticsAction.increase,
)
```

![screenshot](https://github.com/ubuntu-flutter-community/mnemonic_label/raw/main/example/screenshot.png)
