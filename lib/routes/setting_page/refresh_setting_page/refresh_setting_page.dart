import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/global/global.dart';

class RefreshSettingPage extends StatefulWidget {
  const RefreshSettingPage({super.key, this.needLeading = true});

  final bool needLeading;

  @override
  State<RefreshSettingPage> createState() => _RefreshSettingPageState();
}

class _RefreshSettingPageState extends State<RefreshSettingPage> {
  bool refreshOnStartup = prefs.getBool('refreshOnStartup') ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.needLeading ? null : const SizedBox.shrink(),
        leadingWidth: widget.needLeading ? null : 0,
        title: Text(AppLocalizations.of(context)!.refreshSettings),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SwitchListTile(
              value: refreshOnStartup,
              onChanged: (value) async {
                setState(() {
                  refreshOnStartup = value;
                });
                await prefs.setBool('refreshOnStartup', value);
              },
              title: Text(AppLocalizations.of(context)!.refreshOnStartup),
              subtitle:
                  Text(AppLocalizations.of(context)!.refreshOnStartupInfo),
            ),
          ],
        ),
      ),
    );
  }
}
