import 'package:appflowy/plugins/database/application/database_controller.dart';
import 'package:appflowy_backend/protobuf/flowy-database2/protobuf.dart';

import 'cell_controller.dart';
import 'cell_data_loader.dart';
import 'cell_data_persistence.dart';

typedef TextCellController = CellController<String, String>;
typedef CheckboxCellController = CellController<String, String>;
typedef NumberCellController = CellController<String, String>;
typedef SelectOptionCellController
    = CellController<SelectOptionCellDataPB, String>;
typedef ChecklistCellController = CellController<ChecklistCellDataPB, String>;
typedef DateCellController = CellController<DateCellDataPB, String>;
typedef TimestampCellController = CellController<TimestampCellDataPB, String>;
typedef URLCellController = CellController<URLCellDataPB, String>;

CellController makeCellController(
  DatabaseController databaseController,
  CellContext cellContext,
) {
  final DatabaseController(:viewId, :rowCache, :fieldController) =
      databaseController;
  final fieldType = fieldController.getField(cellContext.fieldId)!.fieldType;
  switch (fieldType) {
    case FieldType.Checkbox:
      return TextCellController(
        viewId: viewId,
        fieldController: fieldController,
        cellContext: cellContext,
        rowCache: rowCache,
        cellDataLoader: CellDataLoader(
          parser: StringCellDataParser(),
        ),
        cellDataPersistence: TextCellDataPersistence(),
      );
    case FieldType.DateTime:
      return DateCellController(
        viewId: viewId,
        fieldController: fieldController,
        cellContext: cellContext,
        rowCache: rowCache,
        cellDataLoader: CellDataLoader(
          parser: DateCellDataParser(),
          reloadOnFieldChange: true,
        ),
        cellDataPersistence: TextCellDataPersistence(),
      );
    case FieldType.LastEditedTime:
    case FieldType.CreatedTime:
      return TimestampCellController(
        viewId: viewId,
        fieldController: fieldController,
        cellContext: cellContext,
        rowCache: rowCache,
        cellDataLoader: CellDataLoader(
          parser: TimestampCellDataParser(),
          reloadOnFieldChange: true,
        ),
        cellDataPersistence: TextCellDataPersistence(),
      );
    case FieldType.Number:
      return NumberCellController(
        viewId: viewId,
        fieldController: fieldController,
        cellContext: cellContext,
        rowCache: rowCache,
        cellDataLoader: CellDataLoader(
          parser: NumberCellDataParser(),
          reloadOnFieldChange: true,
        ),
        cellDataPersistence: TextCellDataPersistence(),
      );
    case FieldType.RichText:
      return TextCellController(
        viewId: viewId,
        fieldController: fieldController,
        cellContext: cellContext,
        rowCache: rowCache,
        cellDataLoader: CellDataLoader(
          parser: StringCellDataParser(),
        ),
        cellDataPersistence: TextCellDataPersistence(),
      );
    case FieldType.MultiSelect:
    case FieldType.SingleSelect:
      return SelectOptionCellController(
        viewId: viewId,
        fieldController: fieldController,
        cellContext: cellContext,
        rowCache: rowCache,
        cellDataLoader: CellDataLoader(
          parser: SelectOptionCellDataParser(),
          reloadOnFieldChange: true,
        ),
        cellDataPersistence: TextCellDataPersistence(),
      );
    case FieldType.Checklist:
      return ChecklistCellController(
        viewId: viewId,
        fieldController: fieldController,
        cellContext: cellContext,
        rowCache: rowCache,
        cellDataLoader: CellDataLoader(
          parser: ChecklistCellDataParser(),
          reloadOnFieldChange: true,
        ),
        cellDataPersistence: TextCellDataPersistence(),
      );
    case FieldType.URL:
      return URLCellController(
        viewId: viewId,
        fieldController: fieldController,
        cellContext: cellContext,
        rowCache: rowCache,
        cellDataLoader: CellDataLoader(
          parser: URLCellDataParser(),
        ),
        cellDataPersistence: TextCellDataPersistence(),
      );
  }
  throw UnimplementedError;
}
