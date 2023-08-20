import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/global/global.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.about),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 24, 0, 8),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/meread.png'),
              ),
            ),
            Center(
              child: Text(
                AppLocalizations.of(context)!.meRead,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                applicationVersion,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    await launchUrl(
                      Uri.parse("https://jike.city/gvenusleo"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.contactAuthor),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () async {
                    await launchUrl(
                      Uri.parse("https://github.com/gvenusleo/meread"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.sourceAddress,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '© 2022 - 2023 ${AppLocalizations.of(context)!.meRead}. All rights reserved.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
