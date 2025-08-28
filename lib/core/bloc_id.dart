import 'package:freezed_annotation/freezed_annotation.dart';
part 'bloc_id.freezed.dart';

@freezed
abstract class BlocId with _$BlocId {
  const BlocId._();
  const factory BlocId({required int id, required String family}) = _BlocId;
}
