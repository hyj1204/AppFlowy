import 'package:appflowy/generated/flowy_svgs.g.dart';
import 'package:appflowy/plugins/database/grid/application/filter/select_option_filter_list_bloc.dart';
import 'package:appflowy/plugins/database/grid/presentation/layout/sizes.dart';
import 'package:appflowy/plugins/database/grid/presentation/widgets/filter/filter_info.dart';
import 'package:appflowy/plugins/database/widgets/row/cells/select_option_cell/extension.dart';
import 'package:appflowy_backend/protobuf/flowy-database2/field_entities.pbenum.dart';
import 'package:appflowy_backend/protobuf/flowy-database2/select_option_entities.pb.dart';
import 'package:flowy_infra_ui/widget/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'select_option_loader.dart';

class SelectOptionFilterList extends StatelessWidget {
  const SelectOptionFilterList({
    super.key,
    required this.filterInfo,
    required this.selectedOptionIds,
    required this.onSelectedOptions,
  });

  final FilterInfo filterInfo;
  final List<String> selectedOptionIds;
  final Function(List<String>) onSelectedOptions;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        late SelectOptionFilterListBloc bloc;
        if (filterInfo.fieldInfo.fieldType == FieldType.SingleSelect) {
          bloc = SelectOptionFilterListBloc(
            selectedOptionIds: selectedOptionIds,
            delegate:
                SingleSelectOptionFilterDelegateImpl(filterInfo: filterInfo),
          );
        } else {
          bloc = SelectOptionFilterListBloc(
            selectedOptionIds: selectedOptionIds,
            delegate:
                MultiSelectOptionFilterDelegateImpl(filterInfo: filterInfo),
          );
        }

        bloc.add(const SelectOptionFilterListEvent.initial());
        return bloc;
      },
      child:
          BlocListener<SelectOptionFilterListBloc, SelectOptionFilterListState>(
        listenWhen: (previous, current) =>
            previous.selectedOptionIds != current.selectedOptionIds,
        listener: (context, state) {
          onSelectedOptions(state.selectedOptionIds.toList());
        },
        child: BlocBuilder<SelectOptionFilterListBloc,
            SelectOptionFilterListState>(
          builder: (context, state) {
            return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.visibleOptions.length,
              separatorBuilder: (context, index) {
                return VSpace(GridSize.typeOptionSeparatorHeight);
              },
              itemBuilder: (BuildContext context, int index) {
                final option = state.visibleOptions[index];
                return SelectOptionFilterCell(
                  option: option.optionPB,
                  isSelected: option.isSelected,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class SelectOptionFilterCell extends StatefulWidget {
  const SelectOptionFilterCell({
    super.key,
    required this.option,
    required this.isSelected,
  });

  final SelectOptionPB option;
  final bool isSelected;

  @override
  State<SelectOptionFilterCell> createState() => _SelectOptionFilterCellState();
}

class _SelectOptionFilterCellState extends State<SelectOptionFilterCell> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: GridSize.popoverItemHeight,
      child: SelectOptionTagCell(
        option: widget.option,
        onSelected: () {
          if (widget.isSelected) {
            context
                .read<SelectOptionFilterListBloc>()
                .add(SelectOptionFilterListEvent.unselectOption(widget.option));
          } else {
            context
                .read<SelectOptionFilterListBloc>()
                .add(SelectOptionFilterListEvent.selectOption(widget.option));
          }
        },
        children: [
          if (widget.isSelected)
            const Padding(
              padding: EdgeInsets.only(right: 6),
              child: FlowySvg(FlowySvgs.check_s),
            ),
        ],
      ),
    );
  }
}
