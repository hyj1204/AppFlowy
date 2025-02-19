import 'package:appflowy/generated/flowy_svgs.g.dart';
import 'package:appflowy/generated/locale_keys.g.dart';
import 'package:appflowy/plugins/database/grid/presentation/layout/sizes.dart';
import 'package:appflowy/plugins/database/widgets/row/cells/cell_container.dart';
import 'package:appflowy/plugins/database/widgets/row/cells/date_cell/date_cell_bloc.dart';
import 'package:appflowy/plugins/database/widgets/row/cells/date_cell/date_editor.dart';
import 'package:appflowy_popover/appflowy_popover.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowy_infra_ui/flowy_infra_ui.dart';
import 'package:flowy_infra_ui/widget/flowy_tooltip.dart';
import 'package:flutter/widgets.dart';

import '../editable_cell_skeleton/date.dart';

class DesktopGridDateCellSkin extends IEditableDateCellSkin {
  @override
  Widget build(
    BuildContext context,
    CellContainerNotifier cellContainerNotifier,
    DateCellBloc bloc,
    DateCellState state,
    PopoverController popoverController,
  ) {
    return AppFlowyPopover(
      controller: popoverController,
      triggerActions: PopoverTriggerFlags.none,
      direction: PopoverDirection.bottomWithLeftAligned,
      constraints: BoxConstraints.loose(const Size(260, 620)),
      margin: EdgeInsets.zero,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        padding: GridSize.cellContentInsets,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: FlowyText.medium(
                state.dateStr,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (state.data?.reminderId.isNotEmpty ?? false) ...[
              const HSpace(4),
              FlowyTooltip(
                message: LocaleKeys.grid_field_reminderOnDateTooltip.tr(),
                child: const FlowySvg(FlowySvgs.clock_alarm_s),
              ),
            ],
          ],
        ),
      ),
      popupBuilder: (BuildContext popoverContent) {
        return DateCellEditor(
          cellController: bloc.cellController,
          onDismissed: () => cellContainerNotifier.isFocus = false,
        );
      },
      onClose: () {
        cellContainerNotifier.isFocus = false;
      },
    );
  }
}
