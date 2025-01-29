import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_in.freezed.dart';
part 'check_in.g.dart';

const List<String> kCheckInResultTierSymbols = ['大凶', '凶', '中平', '吉', '大吉'];

@freezed
class SnCheckInRecord with _$SnCheckInRecord {
  const SnCheckInRecord._();

  const factory SnCheckInRecord({
    required int id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime? deletedAt,
    required int resultTier,
    required int resultExperience,
    required double resultCoin,
    required List<int> resultModifiers,
    required int accountId,
  }) = _SnCheckInRecord;

  factory SnCheckInRecord.fromJson(Map<String, dynamic> json) =>
      _$SnCheckInRecordFromJson(json);

  String get symbol => kCheckInResultTierSymbols[resultTier];
}
