import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/ui/viewmodels/setting/language/language_controller.dart';
import 'package:meread/ui/widgets/item_card.dart';

class LanguageSettingView extends StatelessWidget {
  const LanguageSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(LanguageController());
    return Scaffold(
      appBar: AppBar(
        title: Text('languageSettings'.tr),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
          child: ItemCard(
            title: 'languageSettings'.tr,
            item: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (String language in ['system', 'zh_CN', 'en_US']) ...[
                    InkWell(
                      onTap: () => c.updateLanguage(language),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: c.language.value == language
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            {
                                  'system': 'systemLanguage'.tr,
                                  'zh_CN': '简体中文',
                                  'en_US': 'English',
                                }[language] ??
                                '',
                            style: TextStyle(
                              fontSize: 16,
                              color: c.language.value == language
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    language == 'en_US'
                        ? const SizedBox.shrink()
                        : const SizedBox(height: 8),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
