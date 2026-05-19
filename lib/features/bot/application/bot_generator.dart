import 'dart:math';

import 'package:injectable/injectable.dart';

import '../../../core/debug_log.dart';
import '../../../db_client/dao/unit_dao.dart';
import '../../../db_client/dao/user_dao.dart';
import '../../../db_client/db_client.dart';

@lazySingleton
class BotGenerator {
  BotGenerator(this.userDao, this.unitDao);

  final UserDao userDao;
  final UnitDao unitDao;
  final Random _random = Random();

  final List<String> _prefixes = [
    'Steel',
    'Iron',
    'Dark',
    'Swift',
    'Shadow',
    'Frost',
    'Blaze',
    'Stone',
    'Wind',
    'Storm',
  ];
  final List<String> _suffixes = [
    'Warrior',
    'Slayer',
    'Ghost',
    'Knight',
    'Blade',
    'Guard',
    'Reaver',
    'Hunter',
    'Stalker',
    'Hero',
  ];

  Future<void> generateBot() async {
    final botId = _random.nextInt(1000000);
    final email = 'bot_$botId@igame.internal';
    // Password must be at least 28 characters long according to UserTable
    final password = 'bot_long_secure_password_fixed_$botId';

    debugLog('BotGenerator: Generating bot user: $email');
    final user = await userDao.insertBot(email: email, password: password);

    // Generate Unit
    final name =
        '${_prefixes[_random.nextInt(_prefixes.length)]}${_suffixes[_random.nextInt(_suffixes.length)]}';

    // Distribute 20 stat points
    var remainingPoints = 20;
    final atkPoints = _random.nextInt(remainingPoints + 1);
    remainingPoints -= atkPoints;
    final defPoints = _random.nextInt(remainingPoints + 1);
    remainingPoints -= defPoints;
    final vitPoints = remainingPoints;

    debugLog(
      'BotGenerator: Generating unit: $name for userId: ${user.userId.id}',
    );
    final unitCompanion = UnitTableCompanion.insert(
      name: name,
      atk: 10 + atkPoints,
      def: 5 + defPoints,
      vitality: 50 + (vitPoints * 5),
      userId: user.userId.id,
    );

    final unit = await unitDao.insertUnit(unitCompanion);

    // Select the unit for the bot
    debugLog(
      'BotGenerator: Selecting unit: ${unit.id} for userId: ${user.userId.id}',
    );
    await unitDao.setSelectedUnit(
      SelectedUnitTableCompanion.insert(
        unitId: unit.id,
        userId: user.userId.id,
      ),
    );
  }
}
