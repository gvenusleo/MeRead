import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/helpers/constant_helper.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(720),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.primary.withAlpha(10),
                      spreadRadius: 10,
                      blurRadius: 10,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/meread.png',
                  height: Get.mediaQuery.size.width / 3,
                ),
              ),
              Text(
                'MeRead'.tr,
                style: const TextStyle(fontSize: 36),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
                child: Text(
                  'appInfo'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Text(
                'Version ${ConstantHelp.appVersion}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 88, vertical: 88),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton.outlined(
                          onPressed: () {
                            launchUrlString(ConstantHelp.githubUrl);
                          },
                          icon: const Icon(Icons.code_rounded),
                          iconSize: 36,
                        ),
                        const SizedBox(height: 6),
                        Text('openSource'.tr),
                      ],
                    ),
                    const SizedBox(width: 36),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton.outlined(
                          onPressed: () {
                            launchUrlString(ConstantHelp.authorSite);
                          },
                          icon: const Icon(Icons.person_rounded),
                          iconSize: 36,
                        ),
                        const SizedBox(height: 6),
                        Text('contactAuthor'.tr),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                'Released under the GUN GPL-3.0 License\n'
                'Copyright © 2022-${DateTime.now().year} liuyuxin',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
