import 'dart:io';

import 'package:appflowy/generated/locale_keys.g.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeErrorPage extends StatefulWidget {
  /// Similar content as [WorkspaceFailedScreen] in Desktop
  const HomeErrorPage({super.key});

  @override
  State<HomeErrorPage> createState() => _HomeErrorPageState();
}

class _HomeErrorPageState extends State<HomeErrorPage> {
  String version = '';
  final String os = Platform.operatingSystem;

  @override
  void initState() {
    super.initState();
    initVersion();
  }

  Future<void> initVersion() async {
    final platformInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = platformInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LocaleKeys.workspace_failedToLoad.tr(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ElevatedButton(
                      child: Text(
                        LocaleKeys.workspace_errorActions_reportIssue.tr(),
                      ),
                      onPressed: () => safeLaunchUrl(
                        'https://github.com/AppFlowy-IO/AppFlowy/issues/new?assignees=&labels=&projects=&template=bug_report.yaml&title=[Bug]%20Workspace%20failed%20to%20load&version=$version&os=$os',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: ElevatedButton(
                      child: Text(
                        LocaleKeys.workspace_errorActions_reachOut.tr(),
                      ),
                      onPressed: () =>
                          safeLaunchUrl('https://discord.gg/JucBXeU2FE'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
