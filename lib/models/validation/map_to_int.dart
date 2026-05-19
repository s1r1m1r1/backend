import '../../core/api_exceptions.dart';

int mapToInt(String id) {
  final intId = int.tryParse(id);
  if (intId == null)
    throw const ApiException.badRequest(message: 'Invalid int id');
  return intId;
}
