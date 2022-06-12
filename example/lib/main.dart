import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:mnemonic_label/mnemonic_label.dart';

void main() {
  runApp(const MaterialApp(
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _enabled = true;
  var _slider = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mnemonics'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Press and hold'),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Alt'),
                  ),
                ),
                Text('to see mnemonics.'),
              ],
            ),
            MergeSemantics(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _enabled,
                    onChanged: (v) => setState(() => _enabled = v!),
                  ),
                  const Mnemonic('_Enabled'),
                ],
              ),
            ),
            MnemonicTheme(
              data: const MnemonicThemeData(
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationThickness: 4,
                ),
              ),
              child: ElevatedButton(
                onPressed: _enabled ? () {} : null,
                child: const Mnemonic('_Button'),
              ),
            ),
            MergeSemantics(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Mnemonic(
                    '_Decrease',
                    semanticsAction: SemanticsAction.decrease,
                  ),
                  Slider(
                    value: _slider,
                    onChanged:
                        _enabled ? (v) => setState(() => _slider = v) : null,
                  ),
                  const Mnemonic(
                    '_Increase',
                    semanticsAction: SemanticsAction.increase,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
