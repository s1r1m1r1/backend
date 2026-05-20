# Rate Limiting / Flood Control — Улучшения WebSocket

## P0: Быстрые исправления

- [ ] **P0.1** Ужесточить глобальный rate limiter: 20/s → 5/s + добавить второй уровень 30 сообщений в 10 секунд (session_socket.dart:286)
- [ ] **P0.2** Вынести ping/ack из rate limiting — обрабатывать до проверки isRateLimited() в routes/ws/index.dart:17
- [ ] **P0.3** Добавить rate limiting на edit_letter и delete_letter в letters_broad.dart:153,211

## P1: Централизованный RateLimiter сервис

- [ ] **P1.1** Создать RateLimiter сервис (@lazySingleton) с хранением Map<UserId, UserRateState> и периодической очисткой
- [ ] **P1.2** Определить квоты по типам команд:
  - ping/ack: без лимита
  - new_letter: 10 / 30s
  - edit_letter, delete_letter: 15 / 30s
  - join_arena, leave_arena, join_battle_room, change_location: 3 / 5s
  - game_action, allocate_stats: 5 / 1s
  - sync_*: 2 / 3s
  - create_bots, reset_*: 1 / 5s
- [ ] **P1.3** Интегрировать RateLimiter в AuthenticatedWsCmd.execute() (ws_cmd.dart:22)
- [ ] **P1.4** Создать RateLimitErrorResponse DTO для уведомления клиента вместо закрытия соединения

## P2: Мягкие наказания

- [ ] **P2.1** Реализовать градацию нарушений: warning → mute 5s → mute 30s → close
- [ ] **P2.2** Счётчик нарушений с TTL (сброс через 5 минут без нарушений)
- [ ] **P2.3** Отправлять клиенту информацию о текущем уровне предупреждений

## P3: Broadcast throttle

- [ ] **P3.1** Применить BroadcastThrottle к ArenaBroadcast, CombatBroadcast
- [ ] **P3.2** Добавить distinct() по содержимому для предотвращения дубликатов

## P4: Клиентская сторона (Flutter)

- [ ] **P4.1** Очередь сообщений на клиенте — отправлять следующее только после ответа на предыдущее
- [ ] **P4.2** Exponential backoff при реконнекте: 1s → 2s → 4s → 8s → max 30s
- [ ] **P4.3** Клиентский rate limiting UI — cooldown-таймер, блокировка кнопки отправки

## P5: Мониторинг

- [ ] **P5.1** Логирование нарушений: userId, тип команды, время
- [ ] **P5.2** Метрики: rate-limited запросов/мин, топ нарушителей, алерты
