import 'dart:math';
import 'package:dto/dto.dart';
import 'package:game_dto/game_dto.dart';
import '../../../core/debug_log.dart';

class LevelSystemResult {
  LevelSystemResult({
    required this.addedExp,
    required this.newExp,
    required this.newLevel,
    required this.newStatPoints,
  });
  final int addedExp;
  final int newExp;
  final int newLevel;
  final int newStatPoints;
}

class LevelSystem {
  static const double _baseReward = 100.0;
  static const double _rewardGrowthPerLevel =
      1.0549; // ~5.5% reward bump per enemy power level
  static const double _reqGrowthPerLevel =
      1.10; // 10% exp requirement bump per level
  static const int _baseLevelExp = 1000; // Base exp for level 2
  static const int _statPointsPerLevel = 3; // 3 stat points per level

  /// Power is simply the sum of all combat stats
  static int _calculatePower(UnitDto unit) {
    return unit.atk + unit.def + unit.hp;
  }

  /// Convert Power into effective level (where every 3 power points = 1 level diff)
  static double _powerToLevel(int power) {
    return power / 3.0; // E.g., power 30 = level 10
  }

  /// Compute experience required for ANY given level.
  /// Level 1 -> 0
  /// Level 2 -> 1000
  /// Level 3 -> 1100 (1000 * 1.1)
  static int getExpForLevel(int level) {
    if (level <= 1) return 0;
    double currentReq = _baseLevelExp.toDouble();
    double totalExp = 0;

    // Summing up required EXP for all levels up to the target
    for (int i = 2; i <= level; i++) {
      totalExp += currentReq;
      currentReq *= _reqGrowthPerLevel;
    }
    return totalExp.toInt();
  }

  /// Calculates rewards for a winner based on enemy power difference
  static LevelSystemResult calculateWinnerReward(
    UnitProfileDto winner,
    UnitDto loser,
  ) {
    final winnerPower = _calculatePower(winner.unit);
    final loserPower = _calculatePower(loser);

    final winnerLvlEquiv = _powerToLevel(winnerPower);
    final loserLvlEquiv = _powerToLevel(loserPower);

    // This makes winning against stronger enemies give exponentially more exp
    final diff = loserLvlEquiv - winnerLvlEquiv;

    // Scale base reward by enemy's power
    // Example: If enemy is +3 power (1 level diff), reward is 100 * 1.0549
    // If enemy is much weaker (neg diff), exp penalty applies gracefully down to 0
    var expReward = _baseReward * pow(_rewardGrowthPerLevel, diff);

    // Soft cap or floor if needed
    if (expReward < 0) expReward = 0;

    // Bonus for fighting someone much stronger (risk reward) e.g., 50% more if diff > 2 levels (6 power)
    if (diff > 2.0) {
      expReward *= 1.5;
      debugLog('UNDERDOG BONUS! Enemy was 2+ power levels stronger.');
    }

    final int addedExpFinal = expReward.toInt();
    return _applyExpAndLevelProgression(winner, addedExpFinal);
  }

  static LevelSystemResult _applyExpAndLevelProgression(
    UnitProfileDto profile,
    int addedExp,
  ) {
    final currentExp = profile.stats.exp + addedExp;
    var currentLevel = profile.unit.level;
    var currentStatPoints = profile.unit.statPoints;

    // Evaluate if we reached the next level threshold
    var nextLevelThreshold = getExpForLevel(currentLevel + 1);

    while (currentExp >= nextLevelThreshold) {
      currentLevel++;
      currentStatPoints += _statPointsPerLevel;
      debugLog(
        'LEVEL UP! Unit ${profile.unit.name} is now Level $currentLevel',
      );

      // Update threshold for next iteration in case of multi-level up
      nextLevelThreshold = getExpForLevel(currentLevel + 1);
    }

    return LevelSystemResult(
      addedExp: addedExp,
      newExp: currentExp,
      newLevel: currentLevel,
      newStatPoints: currentStatPoints,
    );
  }
}
