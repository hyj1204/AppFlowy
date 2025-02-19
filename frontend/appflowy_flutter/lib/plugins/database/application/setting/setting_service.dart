import 'package:appflowy_backend/protobuf/flowy-database2/database_entities.pb.dart';
import 'package:dartz/dartz.dart';
import 'package:appflowy_backend/dispatch/dispatch.dart';
import 'package:appflowy_backend/protobuf/flowy-error/errors.pb.dart';
import 'package:appflowy_backend/protobuf/flowy-database2/setting_entities.pb.dart';

class SettingBackendService {
  const SettingBackendService({required this.viewId});

  final String viewId;

  Future<Either<DatabaseViewSettingPB, FlowyError>> getSetting() {
    final payload = DatabaseViewIdPB.create()..value = viewId;
    return DatabaseEventGetDatabaseSetting(payload).send();
  }
}
