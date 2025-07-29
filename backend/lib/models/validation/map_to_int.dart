import '../../exceptions/new_api_exceptions.dart';

int mapToInt(String id) {
  final intId = int.tryParse(id);
  if (intId == null) throw ApiException.badRequest(message: 'Invalid int id');
  return intId;
}
