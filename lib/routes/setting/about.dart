import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 24, 0, 8),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/meread.png'),
              ),
            ),
            const Center(
              child: Text(
                '悦读 App',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'V 0.2.3',
                style: TextStyle(fontSize: 16),
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
                  child: const Text('联系作者'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () async {
                    await launchUrl(
                      Uri.parse("https://github.com/gvenusleo/meread"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: const Text('开源地址'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '© 2022 - 2023 悦读. All rights reserved.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
