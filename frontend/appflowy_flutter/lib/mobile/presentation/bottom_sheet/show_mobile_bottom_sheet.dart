import 'package:appflowy/mobile/presentation/base/app_bar_actions.dart';
import 'package:appflowy/plugins/base/drag_handler.dart';
import 'package:flowy_infra/size.dart';
import 'package:flowy_infra_ui/flowy_infra_ui.dart' hide WidgetBuilder;
import 'package:flutter/material.dart';

Future<T?> showMobileBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool isDragEnabled = true,
  bool showDragHandle = false,
  bool showHeader = false,
  // this field is only used if showHeader is true
  bool showCloseButton = false,
  // this field is only used if showHeader is true
  String title = '',
  bool resizeToAvoidBottomInset = true,
  bool isScrollControlled = true,
  bool showDivider = true,
  bool useRootNavigator = false,
  ShapeBorder? shape,
  // the padding of the content, the padding of the header area is fixed
  EdgeInsets padding = const EdgeInsets.fromLTRB(16, 4, 16, 32),
  Color? backgroundColor,
  BoxConstraints? constraints,
  Color? barrierColor,
  double? elevation,
  bool showDoneButton = false,
}) async {
  assert(() {
    if (showCloseButton || title.isNotEmpty) assert(showHeader);
    return true;
  }());

  shape ??= const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Corners.s12Radius,
    ),
  );

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    enableDrag: isDragEnabled,
    useSafeArea: true,
    clipBehavior: Clip.antiAlias,
    backgroundColor: backgroundColor,
    constraints: constraints,
    barrierColor: barrierColor,
    elevation: elevation,
    shape: shape,
    useRootNavigator: useRootNavigator,
    builder: (context) {
      final List<Widget> children = [];

      final child = builder(context);

      // if the children is only one, we don't need to wrap it with a column
      if (!showDragHandle &&
          !showHeader &&
          !showDivider &&
          !resizeToAvoidBottomInset) {
        return child;
      }

      // ----- header area -----
      if (showDragHandle) {
        children.add(
          const DragHandler(),
        );
      }

      if (showHeader) {
        children.add(
          _Header(
            showCloseButton: showCloseButton,
            showDoneButton: showDoneButton,
            title: title,
          ),
        );

        if (showDivider) {
          children.add(
            const Divider(height: 1.0, thickness: 1.0),
          );
        }
      }

      // ----- header area -----

      // ----- content area -----
      if (resizeToAvoidBottomInset) {
        children.add(
          Padding(
            padding: EdgeInsets.only(
              top: padding.top,
              left: padding.left,
              right: padding.right,
              bottom: padding.bottom + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: child,
          ),
        );
      } else {
        children.add(child);
      }
      // ----- content area -----

      if (children.length == 1) {
        return children.first;
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    },
  );
}

class _Header extends StatelessWidget {
  const _Header({
    required this.showCloseButton,
    required this.title,
    required this.showDoneButton,
  });

  final bool showCloseButton;
  final String title;
  final bool showDoneButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: SizedBox(
        height: 44.0, // the height of the header area is fixed
        child: Stack(
          children: [
            if (showCloseButton)
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: AppBarCloseButton(
                    margin: EdgeInsets.zero,
                  ),
                ),
              ),
            Align(
              child: FlowyText(
                title,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (showDoneButton)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AppBarDoneButton(
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
