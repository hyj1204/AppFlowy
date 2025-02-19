import 'dart:async';

import 'package:appflowy_backend/protobuf/flowy-database2/select_option_entities.pb.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'select_option_type_option_bloc.freezed.dart';

abstract class ISelectOptionAction {
  Future<List<SelectOptionPB>> insertOption(
    List<SelectOptionPB> options,
    String newOptionName,
  );

  List<SelectOptionPB> deleteOption(
    List<SelectOptionPB> options,
    SelectOptionPB deletedOption,
  );

  List<SelectOptionPB> updateOption(
    List<SelectOptionPB> options,
    SelectOptionPB updatedOption,
  );
}

class SelectOptionTypeOptionBloc
    extends Bloc<SelectOptionTypeOptionEvent, SelectOptionTypeOptionState> {
  SelectOptionTypeOptionBloc({
    required List<SelectOptionPB> options,
    required this.typeOptionAction,
  }) : super(SelectOptionTypeOptionState.initial(options)) {
    _dispatch();
  }

  final ISelectOptionAction typeOptionAction;

  void _dispatch() {
    on<SelectOptionTypeOptionEvent>(
      (event, emit) async {
        await event.when(
          createOption: (optionName) async {
            final List<SelectOptionPB> options =
                await typeOptionAction.insertOption(state.options, optionName);
            emit(state.copyWith(options: options));
          },
          addingOption: () {
            emit(state.copyWith(isEditingOption: true, newOptionName: none()));
          },
          endAddingOption: () {
            emit(state.copyWith(isEditingOption: false, newOptionName: none()));
          },
          updateOption: (option) {
            final List<SelectOptionPB> options =
                typeOptionAction.updateOption(state.options, option);
            emit(state.copyWith(options: options));
          },
          deleteOption: (option) {
            final List<SelectOptionPB> options =
                typeOptionAction.deleteOption(state.options, option);
            emit(state.copyWith(options: options));
          },
        );
      },
    );
  }
}

@freezed
class SelectOptionTypeOptionEvent with _$SelectOptionTypeOptionEvent {
  const factory SelectOptionTypeOptionEvent.createOption(String optionName) =
      _CreateOption;
  const factory SelectOptionTypeOptionEvent.addingOption() = _AddingOption;
  const factory SelectOptionTypeOptionEvent.endAddingOption() =
      _EndAddingOption;
  const factory SelectOptionTypeOptionEvent.updateOption(
    SelectOptionPB option,
  ) = _UpdateOption;
  const factory SelectOptionTypeOptionEvent.deleteOption(
    SelectOptionPB option,
  ) = _DeleteOption;
}

@freezed
class SelectOptionTypeOptionState with _$SelectOptionTypeOptionState {
  const factory SelectOptionTypeOptionState({
    required List<SelectOptionPB> options,
    required bool isEditingOption,
    required Option<String> newOptionName,
  }) = _SelectOptionTypeOptionState;

  factory SelectOptionTypeOptionState.initial(List<SelectOptionPB> options) =>
      SelectOptionTypeOptionState(
        options: options,
        isEditingOption: false,
        newOptionName: none(),
      );
}
