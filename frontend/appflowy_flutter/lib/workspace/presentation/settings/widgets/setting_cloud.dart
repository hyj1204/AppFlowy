import 'package:appflowy/env/cloud_env.dart';
import 'package:appflowy/env/env.dart';
import 'package:appflowy/generated/flowy_svgs.g.dart';
import 'package:appflowy/generated/locale_keys.g.dart';
import 'package:appflowy/mobile/presentation/bottom_sheet/bottom_sheet.dart';
import 'package:appflowy/mobile/presentation/widgets/widgets.dart';
import 'package:appflowy/startup/startup.dart';
import 'package:appflowy/workspace/application/settings/cloud_setting_bloc.dart';
import 'package:appflowy/workspace/presentation/settings/widgets/setting_local_cloud.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:appflowy_popover/appflowy_popover.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowy_infra_ui/flowy_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'setting_appflowy_cloud.dart';
import 'setting_supabase_cloud.dart';

class SettingCloud extends StatelessWidget {
  const SettingCloud({required this.didResetServerUrl, super.key});

  final VoidCallback didResetServerUrl;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAuthenticatorType(),
      builder:
          (BuildContext context, AsyncSnapshot<AuthenticatorType> snapshot) {
        if (snapshot.hasData) {
          final cloudType = snapshot.data!;
          return BlocProvider(
            create: (context) => CloudSettingBloc(cloudType),
            child: BlocBuilder<CloudSettingBloc, CloudSettingState>(
              builder: (context, state) {
                return Column(
                  children: [
                    if (Env.enableCustomCloud)
                      Row(
                        children: [
                          Expanded(
                            child: FlowyText.medium(
                              LocaleKeys.settings_menu_cloudServerType.tr(),
                            ),
                          ),
                          Tooltip(
                            message: LocaleKeys.settings_menu_cloudServerTypeTip
                                .tr(),
                            child: CloudTypeSwitcher(
                              cloudType: state.cloudType,
                              onSelected: (newCloudType) {
                                context.read<CloudSettingBloc>().add(
                                      CloudSettingEvent.updateCloudType(
                                        newCloudType,
                                      ),
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                    const VSpace(8),
                    _viewFromCloudType(state.cloudType),
                  ],
                );
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _viewFromCloudType(AuthenticatorType cloudType) {
    switch (cloudType) {
      case AuthenticatorType.local:
        return SettingLocalCloud(
          didResetServerUrl: didResetServerUrl,
        );
      case AuthenticatorType.supabase:
        return SettingSupabaseCloudView(
          didResetServerUrl: didResetServerUrl,
        );
      case AuthenticatorType.appflowyCloud:
        return AppFlowyCloudViewSetting(
          restartAppFlowy: didResetServerUrl,
        );
      case AuthenticatorType.appflowyCloudSelfHost:
        return CustomAppFlowyCloudView(
          restartAppFlowy: didResetServerUrl,
        );
      case AuthenticatorType.appflowyCloudDevelop:
        return AppFlowyCloudViewSetting(
          serverURL: "http://localhost",
          authenticatorType: AuthenticatorType.appflowyCloudDevelop,
          restartAppFlowy: didResetServerUrl,
        );
    }
  }
}

class CloudTypeSwitcher extends StatelessWidget {
  const CloudTypeSwitcher({
    super.key,
    required this.cloudType,
    required this.onSelected,
  });

  final AuthenticatorType cloudType;
  final Function(AuthenticatorType) onSelected;

  @override
  Widget build(BuildContext context) {
    final isDevelopMode = integrationMode().isDevelop;
    // Only show the appflowyCloudDevelop in develop mode
    final values = AuthenticatorType.values
        .where(
          (element) =>
              isDevelopMode ||
              element != AuthenticatorType.appflowyCloudDevelop,
        )
        .toList();
    return PlatformExtension.isDesktopOrWeb
        ? AppFlowyPopover(
            direction: PopoverDirection.bottomWithRightAligned,
            child: FlowyTextButton(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              titleFromCloudType(cloudType),
              fontColor: Theme.of(context).colorScheme.onBackground,
              fillColor: Colors.transparent,
              onPressed: () {},
            ),
            popupBuilder: (BuildContext context) {
              return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return CloudTypeItem(
                    cloudType: values[index],
                    currentCloudtype: cloudType,
                    onSelected: onSelected,
                  );
                },
                itemCount: values.length,
              );
            },
          )
        : FlowyButton(
            text: FlowyText(
              titleFromCloudType(cloudType),
            ),
            useIntrinsicWidth: true,
            rightIcon: const Icon(
              Icons.chevron_right,
            ),
            onTap: () {
              showMobileBottomSheet(
                context,
                showHeader: true,
                showDragHandle: true,
                showDivider: false,
                showCloseButton: false,
                title: LocaleKeys.settings_menu_cloudServerType.tr(),
                padding: const EdgeInsets.only(bottom: 36),
                builder: (context) {
                  return Column(
                    children: values
                        .mapIndexed(
                          (i, e) => FlowyOptionTile.checkbox(
                            text: titleFromCloudType(values[i]),
                            isSelected: cloudType == values[i],
                            onTap: () {
                              onSelected(e);
                              context.pop();
                            },
                            showBottomBorder: i == values.length - 1,
                          ),
                        )
                        .toList(),
                  );
                },
              );
            },
          );
  }
}

class CloudTypeItem extends StatelessWidget {
  const CloudTypeItem({
    super.key,
    required this.cloudType,
    required this.currentCloudtype,
    required this.onSelected,
  });

  final AuthenticatorType cloudType;
  final AuthenticatorType currentCloudtype;
  final Function(AuthenticatorType) onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: FlowyButton(
        text: FlowyText.medium(
          titleFromCloudType(cloudType),
        ),
        rightIcon: currentCloudtype == cloudType
            ? const FlowySvg(FlowySvgs.check_s)
            : null,
        onTap: () {
          if (currentCloudtype != cloudType) {
            onSelected(cloudType);
          }
          PopoverContainer.of(context).close();
        },
      ),
    );
  }
}

String titleFromCloudType(AuthenticatorType cloudType) {
  switch (cloudType) {
    case AuthenticatorType.local:
      return LocaleKeys.settings_menu_cloudLocal.tr();
    case AuthenticatorType.supabase:
      return LocaleKeys.settings_menu_cloudSupabase.tr();
    case AuthenticatorType.appflowyCloud:
      return LocaleKeys.settings_menu_cloudAppFlowy.tr();
    case AuthenticatorType.appflowyCloudSelfHost:
      return LocaleKeys.settings_menu_cloudAppFlowySelfHost.tr();
    case AuthenticatorType.appflowyCloudDevelop:
      return "AppFlowyCloud Develop";
  }
}
