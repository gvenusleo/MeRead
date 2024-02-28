import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/common/global.dart';
import 'package:meread/ui/widgets/list_item_card.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('aboutApp'.tr),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(720),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Theme.of(context).colorScheme.primary.withAlpha(10),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/meread.png',
                    width: MediaQuery.of(context).size.width * 0.3,
                    // height: 72,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text('MeRead'.tr, style: const TextStyle(fontSize: 24)),
              ),
              Center(
                child: Text(
                  applicationVersion,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 36),
              ListItemCard(
                trailing: const Icon(Icons.source_outlined),
                title: 'sourceAddress'.tr,
                onTap: () {
                  launchUrl(
                    Uri.parse('https://github.com/gvenusleo/MeRead'),
                    mode: LaunchMode.externalApplication,
                  );
                },
                bottomRadius: false,
              ),
              const Divider(
                indent: 18,
                endIndent: 18,
              ),
              ListItemCard(
                trailing: const Icon(Icons.person_outline),
                title: 'contactAuthor'.tr,
                onTap: () {
                  launchUrl(
                    Uri.parse('https://jike.city/gvenusleo'),
                    mode: LaunchMode.externalApplication,
                  );
                },
                topRadius: false,
              ),
              const Spacer(),
              Center(
                child: Text(
                  'Released under the GUN GPL-3.0 License.\nCopyright © 2022-${DateTime.now().year} liuyuxin',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
