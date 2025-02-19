import 'package:appflowy/plugins/database/application/field/field_info.dart';

List<FieldInfo> getCreatableSorts(List<FieldInfo> fieldInfos) {
  final List<FieldInfo> creatableFields = List.from(fieldInfos);
  creatableFields.retainWhere((element) => element.canCreateSort);
  return creatableFields;
}
