import '../../exceptions/new_api_exceptions.dart';

int mapToInt(String id) {
  final todoId = int.tryParse(id);
  if (todoId == null) throw ApiException.badRequest(message: 'Invalid id');
  return todoId;
}
