import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_dto.g.dart';

@JsonSerializable()
class TodoDto {
  final int? id;
  final String title;
  @Default('')
  final String description; // Default is handled differently
  final bool? completed;
  @DateTimeConverter()
  final DateTime createdAt;
  @DateTimeConverterNullable()
  final DateTime? updatedAt;

  TodoDto({
    this.id,
    required this.title,
    this.description = '', // Set default value in the constructor
    this.completed = false, // Set default value in the constructor
    required this.createdAt,
    this.updatedAt,
  });

  factory TodoDto.fromJson(Map<String, dynamic> json) => _$TodoDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoDtoToJson(this);
}

class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) => object.toIso8601String();
}

// Example of DateTimeConverterNullable (if custom):
class DateTimeConverterNullable implements JsonConverter<DateTime?, String?> {
  const DateTimeConverterNullable();

  @override
  DateTime? fromJson(String? json) => json == null ? null : DateTime.parse(json);

  @override
  String? toJson(DateTime? object) => object?.toIso8601String();
}
