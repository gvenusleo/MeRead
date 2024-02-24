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
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          child: Column(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(72),
                  child: Image.asset(
                    'assets/meread.png',
                    width: 72,
                    height: 72,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text('MeRead'.tr, style: const TextStyle(fontSize: 18)),
              ),
              Center(
                child: Text(
                  applicationVersion,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 36),
              ListItemCard(
                icon: const Icon(Icons.source_outlined),
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
                icon: const Icon(Icons.person_outline),
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
