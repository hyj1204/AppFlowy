import 'dart:typed_data';
import 'package:appflowy_backend/protobuf/flowy-notification/protobuf.dart';
import 'package:dartz/dartz.dart';

class NotificationParser<T, E> {
  NotificationParser({
    this.id,
    required this.callback,
    required this.errorParser,
    required this.tyParser,
  });

  String? id;
  void Function(T, Either<Uint8List, E>) callback;
  E Function(Uint8List) errorParser;
  T? Function(int) tyParser;

  void parse(SubscribeObject subject) {
    if (id != null) {
      if (subject.id != id) {
        return;
      }
    }

    final ty = tyParser(subject.ty);
    if (ty == null) {
      return;
    }

    if (subject.hasError()) {
      final bytes = Uint8List.fromList(subject.error);
      final error = errorParser(bytes);
      callback(ty, right(error));
    } else {
      final bytes = Uint8List.fromList(subject.payload);
      callback(ty, left(bytes));
    }
  }
}
