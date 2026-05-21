import 'package:drift/drift.dart';
import 'package:dto/dto.dart' show UnitStatsDto;
import 'package:game_dto/game_dto.dart';
import 'package:types/types.dart';

import '../db_client.dart';
import '../tables/selected_unit_table.dart';
import '../tables/unit_table.dart';

part 'unit_dao.g.dart';

@DriftAccessor(tables: [UnitTable, SelectedUnitTable])
class UnitDao extends DatabaseAccessor<DbClient> with _$UnitDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  UnitDao(super.db);

  //------------------------------------------------------------------------------- --
  // Mapping methods
  //------------------------------------------------------------------------------- --

  //------------------------------------------------------------------------------- --
  // CRUD operations returning DTOs
  //------------------------------------------------------------------------------- --

  Future<UnitEntry> insertUnit(UnitTableCompanion companion) async {
    final entry = await into(unitTable).insertReturning(companion);
    return entry;
  }

  Future<int> deleteAllBotUnits(List<String> botUserIds) async {
    if (botUserIds.isEmpty) return 0;
    final query = delete(unitTable);
    query.where((t) => t.userId.isIn(botUserIds));
    return query.go();
  }

  Future<UnitEntry?> getUnitEntry(String unitId) {
    final query = unitTable.select();
    query.where((t) => t.id.equals(unitId));
    return query.getSingleOrNull();
  }

  Future<List<UnitEntry>> getListUnitEntries({required String userId}) async {
    final query = unitTable.select();
    query.where((t) => t.userId.equals(userId));
    final entries = await query.get();
    return entries;
  }

  Future<UnitEntry?> updateUnit(UnitTableCompanion companion) async {
    final isOk = await update(unitTable).replace(companion);
    if (!isOk) return null;

    final entry = await getUnitEntry(companion.id.value);
    return entry;
  }

  Future<int> deleteUnit(String characterId) async {
    final query = delete(unitTable);
    query.where((t) => t.id.equals(characterId));
    return query.go();
  }

  Future<UnitEntry?> setSelectedUnit(
    SelectedUnitTableCompanion companion,
  ) async {
    final selectedEntry = await selectedUnitTable.insertReturning(
      companion,
      mode: InsertMode.insertOrReplace,
    );

    final unitEntry = await getUnitEntry(selectedEntry.unitId);
    return unitEntry;
  }

  Future<UnitEntry?> getSelectedUnitEntry(String userId) async {
    final query = selectedUnitTable.select();
    query.where((t) => t.userId.equals(userId));
    final selectedEntry = await query.getSingleOrNull();

    if (selectedEntry == null) return null;

    final unitEntry = await getUnitEntry(selectedEntry.unitId);
    return unitEntry;
  }

  Future<void> updateStats({
    required UnitId unitId,
    int winDelta = 0,
    int lossDelta = 0,
    int coinDelta = 0,
    int expDelta = 0,
    int? newLevel,
    int? newStatPoints,
  }) async {
    final query = StringBuffer(
      'UPDATE unit_table SET '
      'wins = wins + ?, '
      'losses = losses + ?, '
      'coins = coins + ?, '
      'exp = exp + ? ',
    );
    final params = <dynamic>[winDelta, lossDelta, coinDelta, expDelta];

    if (newLevel != null) {
      query.write(', level = ? ');
      params.add(newLevel);
    }
    if (newStatPoints != null) {
      query.write(', stat_points = ? ');
      params.add(newStatPoints);
    }

    query.write('WHERE id = ?');
    params.add(unitId);

    await customStatement(query.toString(), params);
  }

  Future<void> setStats({
    required UnitId unitId,
    int? wins,
    int? losses,
    int? coins,
    int? exp,
  }) async {
    if (wins == null && losses == null && coins == null && exp == null) return;

    final query = StringBuffer('UPDATE unit_table SET ');
    final params = <dynamic>[];

    if (wins != null) {
      query.write('wins = ?, ');
      params.add(wins);
    }
    if (losses != null) {
      query.write('losses = ?, ');
      params.add(losses);
    }
    if (coins != null) {
      query.write('coins = ?, ');
      params.add(coins);
    }
    if (exp != null) {
      query.write('exp = ?, ');
      params.add(exp);
    }

    // Remove trailing comma and space
    final queryString = query.toString().substring(0, query.length - 2);
    final finalizedQuery = '$queryString WHERE id = ?';
    params.add(unitId);

    await customStatement(finalizedQuery, params);
  }

  Future<void> allocateStats(
    String unitId,
    int addAtk,
    int addDef,
    int addVitality,
  ) async {
    final totalSpent = addAtk + addDef + addVitality;
    if (totalSpent <= 0) return;

    // We do atomic check and update: only update if statPoints >= totalSpent
    const query = '''
      UPDATE unit_table 
      SET 
        atk = atk + ?,
        def = def + ?,
        vitality = vitality + ?,
        stat_points = stat_points - ?
      WHERE id = ? AND stat_points >= ?
    ''';

    await customStatement(query, [
      addAtk,
      addDef,
      addVitality,
      totalSpent,
      unitId,
      totalSpent,
    ]);
  }

  Future<UnitStatsDto?> getUnitPublicInfo(String unitId) async {
    final query = unitTable.select();
    query.where((t) => t.id.equals(unitId));
    final entry = await query.getSingleOrNull();
    if (entry == null) return null;
    return UnitStatsDto(
      wins: entry.wins,
      losses: entry.losses,
      coins: entry.coins,
      exp: entry.exp,
    );
  }
}
