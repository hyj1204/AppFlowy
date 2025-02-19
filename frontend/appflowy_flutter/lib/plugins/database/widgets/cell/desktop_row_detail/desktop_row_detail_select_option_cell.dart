import 'package:appflowy/generated/locale_keys.g.dart';
import 'package:appflowy/plugins/database/widgets/row/cells/cell_container.dart';
import 'package:appflowy/plugins/database/widgets/row/cells/select_option_cell/extension.dart';
import 'package:appflowy/plugins/database/widgets/row/cells/select_option_cell/select_option_cell_bloc.dart';
import 'package:appflowy/plugins/database/widgets/row/cells/select_option_cell/select_option_editor.dart';
import 'package:appflowy_backend/protobuf/flowy-database2/protobuf.dart';
import 'package:appflowy_popover/appflowy_popover.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowy_infra_ui/flowy_infra_ui.dart';
import 'package:flutter/material.dart';

import '../editable_cell_skeleton/select_option.dart';

class DesktopRowDetailSelectOptionCellSkin
    extends IEditableSelectOptionCellSkin {
  @override
  Widget build(
    BuildContext context,
    CellContainerNotifier cellContainerNotifier,
    SelectOptionCellBloc bloc,
    SelectOptionCellState state,
    PopoverController popoverController,
  ) {
    return AppFlowyPopover(
      controller: popoverController,
      constraints: BoxConstraints.loose(const Size.square(300)),
      margin: EdgeInsets.zero,
      direction: PopoverDirection.bottomWithLeftAligned,
      popupBuilder: (BuildContext popoverContext) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          cellContainerNotifier.isFocus = true;
        });
        return SelectOptionCellEditor(
          cellController: bloc.cellController,
        );
      },
      onClose: () => cellContainerNotifier.isFocus = false,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        padding: state.selectedOptions.isEmpty
            ? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0)
            : const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        child: state.selectedOptions.isEmpty
            ? _buildPlaceholder(context)
            : _buildOptions(context, state.selectedOptions),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return FlowyText(
      LocaleKeys.grid_row_textPlaceholder.tr(),
      color: Theme.of(context).hintColor,
    );
  }

  Widget _buildOptions(BuildContext context, List<SelectOptionPB> options) {
    return Wrap(
      runSpacing: 4,
      spacing: 4,
      children: options.map(
        (option) {
          return SelectOptionTag(
            option: option,
            padding: const EdgeInsets.symmetric(
              vertical: 1,
              horizontal: 8,
            ),
          );
        },
      ).toList(),
    );
  }
}
