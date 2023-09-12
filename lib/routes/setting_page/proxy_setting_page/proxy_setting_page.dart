import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/global/global.dart';
import 'package:meread/utils/notification_util.dart';

class ProxySettingPage extends StatefulWidget {
  const ProxySettingPage({super.key, this.needLeading = true});

  final bool needLeading;

  @override
  State<ProxySettingPage> createState() => _ProxySettingPageState();
}

class _ProxySettingPageState extends State<ProxySettingPage> {
  bool isProxy = prefs.getBool('isProxy') ?? false;

  final addressController = TextEditingController();
  final portController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressController.text = prefs.getString('proxyAdress') ?? '';
    portController.text = prefs.getString('proxyPort') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.needLeading ? null : const SizedBox.shrink(),
        leadingWidth: widget.needLeading ? null : 0,
        title: Text(AppLocalizations.of(context)!.proxySettings),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SwitchListTile(
              value: isProxy,
              onChanged: (bool value) async {
                String proxyAddress = prefs.getString('proxyAdress') ?? '';
                String proxyPort = prefs.getString('proxyPort') ?? '';
                if (proxyAddress.isEmpty || proxyPort.isEmpty) {
                  showToastOrSnackBar(
                      context, AppLocalizations.of(context)!.fillProxyFirst);
                } else {
                  await prefs.setBool('isProxy', value);
                  setState(() {
                    isProxy = value;
                  });
                }
              },
              title: Text(AppLocalizations.of(context)!.netWorkProxy),
              subtitle:
                  Text(AppLocalizations.of(context)!.useNetworkProxyParseFeeds),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: TextField(
                controller: addressController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.proxyAddress,
                  prefixText: 'http://',
                ),
                onChanged: (String value) async {
                  prefs.setString('proxyAdress', value);
                  if (value.isEmpty) {
                    prefs.setBool('isProxy', false);
                    setState(() {
                      isProxy = false;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: TextField(
                controller: portController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.proxyPort,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (String value) {
                  prefs.setString('proxyPort', value);
                  if (value.isEmpty) {
                    prefs.setBool('isProxy', false);
                    setState(() {
                      isProxy = false;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
