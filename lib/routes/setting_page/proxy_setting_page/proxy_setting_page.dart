import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/provider/network_proxy_provider.dart';
import 'package:meread/utils/notification_util.dart';
import 'package:provider/provider.dart';

class ProxySettingPage extends StatefulWidget {
  const ProxySettingPage({super.key, this.needLeading = true});

  final bool needLeading;

  @override
  State<ProxySettingPage> createState() => _ProxySettingPageState();
}

class _ProxySettingPageState extends State<ProxySettingPage> {
  final addressController = TextEditingController();
  final portController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressController.text = context.read<NetWorkProxyProvider>().proxyAddress;
    portController.text = context.read<NetWorkProxyProvider>().proxyPort;
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
              value: context.watch<NetWorkProxyProvider>().isProxy,
              onChanged: (bool value) async {
                if (context.read<NetWorkProxyProvider>().proxyAddress.isEmpty ||
                    context.read<NetWorkProxyProvider>().proxyPort.isEmpty) {
                  showToastOrSnackBar(
                      context, AppLocalizations.of(context)!.fillProxyFirst);
                } else {
                  context.read<NetWorkProxyProvider>().changeIsProxy(value);
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
                onChanged: (String value) {
                  context
                      .read<NetWorkProxyProvider>()
                      .changeProxyAddress(value);
                  if (value.isEmpty) {
                    context.read<NetWorkProxyProvider>().changeIsProxy(false);
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
                  context.read<NetWorkProxyProvider>().changeProxyPort(value);
                  if (value.isEmpty) {
                    context.read<NetWorkProxyProvider>().changeIsProxy(false);
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
