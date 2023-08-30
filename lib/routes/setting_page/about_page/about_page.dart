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
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 18),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/meread.png',
                          width: 48,
                          height: 48,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Badge(
                        offset: const Offset(18, 0),
                        label: Text(
                          applicationVersion,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.onPrimary,
                        child: Text(
                          AppLocalizations.of(context)!.meRead,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  /* 开源地址 */
                  ListTile(
                    leading: const Icon(Icons.source_outlined),
                    iconColor: Theme.of(context).textTheme.bodyLarge!.color,
                    title: Text(
                      AppLocalizations.of(context)!.openSourceAddress,
                    ),
                    subtitle: Text(
                      AppLocalizations.of(context)!.viewSourceCode,
                    ),
                    onTap: () async {
                      await launchUrl(
                        Uri.parse("https://github.com/gvenusleo/meread"),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                  /* 开源许可 */
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    iconColor: Theme.of(context).textTheme.bodyLarge!.color,
                    title:
                        Text(AppLocalizations.of(context)!.openSourceLicenses),
                    subtitle: Text(
                      AppLocalizations.of(context)!.viewOpenSourceLicenses,
                    ),
                    onTap: () => showLicensePage(
                      context: context,
                      applicationName: AppLocalizations.of(context)!.meRead,
                      applicationVersion: applicationVersion,
                      applicationIcon: Container(
                        width: 64,
                        height: 64,
                        margin: const EdgeInsets.only(bottom: 8, top: 8),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          image: DecorationImage(
                            image: AssetImage('assets/meread.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      applicationLegalese:
                          '© 2022 - 2023 ${AppLocalizations.of(context)!.meRead}. All Rights Reserved.',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 18),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/avatar.png',
                          width: 48,
                          height: 48,
                        ),
                      ),
                      const SizedBox(width: 18),
                      const Text(
                        'liuyuxin',
                        style: TextStyle(fontSize: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  /* 联系作者 */
                  ListTile(
                    leading: const Icon(Icons.person_outlined),
                    iconColor: Theme.of(context).textTheme.bodyLarge!.color,
                    title: Text(AppLocalizations.of(context)!.contactAuthor),
                    subtitle: Text(
                      AppLocalizations.of(context)!
                          .authorContactAndMoreInformation,
                    ),
                    onTap: () async {
                      await launchUrl(
                        Uri.parse("https://jike.city/gvenusleo"),
                        mode: LaunchMode.externalApplication,
                      );
                    },
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
