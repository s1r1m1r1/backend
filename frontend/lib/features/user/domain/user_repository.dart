import 'package:injectable/injectable.dart';

abstract class UserRepository {}

@LazySingleton(as: UserRepository)
class UserRepositoryImpl extends UserRepository {}
