import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../features/auth/application/online_repository_impl.dart';
import '../features/game/application/combat_supervisor.dart';

/// Service that periodically logs system health and status.
@lazySingleton
class SystemHealthService {
  SystemHealthService(this._onlineRepository, this._combatSupervisor);

  final OnlineRepository _onlineRepository;
  final CombatSupervisor _combatSupervisor;
  Timer? _timer;

  /// Starts the health check timer.
  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _logStatus());
    // Log immediately on start
    _logStatus();
  }

  void _logStatus() {
    final onlineCount = _onlineRepository.getList().length;
    final combatCount = _combatSupervisor.roomCount;

    // Using a dedicated logger for health status
    Logger(
      'SystemHealth',
    ).info('💓 Status: Online: $onlineCount | CombatRooms: $combatCount');
  }

  /// Stops the health check timer.
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
