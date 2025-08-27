import 'package:injectable/injectable.dart';

abstract class ArenaRepository {}

@LazySingleton(as: ArenaRepository)
class ArenaRepositoryImpl implements ArenaRepository {}
