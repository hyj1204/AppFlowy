import 'package:appflowy/env/cloud_env.dart';
import 'package:appflowy/generated/locale_keys.g.dart';
import 'package:appflowy/startup/startup.dart';
import 'package:appflowy/workspace/application/settings/appflowy_cloud_urls_bloc.dart';
import 'package:appflowy_backend/log.dart';
import 'package:dartz/dartz.dart' show Some;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelfHostUrlBottomSheet extends StatefulWidget {
  const SelfHostUrlBottomSheet({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<SelfHostUrlBottomSheet> createState() => _SelfHostUrlBottomSheetState();
}

class _SelfHostUrlBottomSheetState extends State<SelfHostUrlBottomSheet> {
  final TextEditingController _textFieldController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    _textFieldController.text = widget.url;
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.editor_urlHint.tr(),
              style: theme.textTheme.labelSmall,
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: theme.hintColor,
              ),
              onPressed: () {
                context.pop();
              },
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _textFieldController,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.settings_mobile_usernameEmptyError.tr();
              }
              return null;
            },
            onEditingComplete: _saveSelfHostUrl,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveSelfHostUrl,
            child: Text(LocaleKeys.settings_menu_restartApp.tr()),
          ),
        ),
      ],
    );
  }

  void _saveSelfHostUrl() {
    if (_formKey.currentState!.validate()) {
      final value = _textFieldController.text;
      if (value.isNotEmpty) {
        validateUrl(value).fold(
          (url) async {
            await setAppFlowyCloudUrl(Some(url));
            runAppFlowy();
          },
          (err) => Log.error(err),
        );
      }
    }
  }
}
