import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RefreshRateSettingPage extends StatefulWidget {
  const RefreshRateSettingPage({super.key, this.needLeading = true});

  final bool needLeading;

  @override
  State<RefreshRateSettingPage> createState() => _RefreshRateSettingPageState();
}

class _RefreshRateSettingPageState extends State<RefreshRateSettingPage> {
  List<DisplayMode> _modes = [];
  DisplayMode? _activeMode;

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.needLeading ? null : const SizedBox.shrink(),
        leadingWidth: widget.needLeading ? null : 0,
        title: Text(AppLocalizations.of(context)!.screenRefreshRate),
      ),
      body: ListView.builder(
        itemCount: _modes.length,
        itemBuilder: (context, index) {
          return RadioListTile(
            value: _modes[index],
            groupValue: _activeMode,
            onChanged: (value) async {
              await FlutterDisplayMode.setPreferredMode(_modes[index]);
              setState(() {
                _activeMode = _modes[index];
              });
            },
            title: Text(
              index == 0
                  ? "自动"
                  : "${_modes[index].height}x${_modes[index].width}  ${_modes[index].refreshRate.toStringAsFixed(0)}Hz",
            ),
          );
        },
      ),
    );
  }

  Future<void> initData() async {
    FlutterDisplayMode.supported.then((value) {
      setState(() {
        _modes = value;
      });
    });
    FlutterDisplayMode.active.then((value) {
      setState(() {
        _activeMode = value;
      });
    });
  }
}
