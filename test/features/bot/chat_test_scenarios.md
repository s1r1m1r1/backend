# Chat Bot Test Scenarios

This document describes test scenarios for the letters chat system using bot strategies.

## Implemented (Simple)

| # | Scenario | Strategy Class | Description |
|---|----------|---------------|-------------|
| 1 | Send multiple messages | `SimpleMessageBotStrategy` | Bot sends a list of messages with random delays. Verifies messages are persisted. |
| 2 | Delete own message | `DeleteOwnMessageStrategy` | Bot creates a message then deletes it. Verifies the message is removed. |
| 3 | Fail to delete other's message | `DeleteOtherMessageStrategy` | Bot attempts to delete another user's message. Expects `DeleteLetterFailTc`. |
| 4 | Edit own message | `EditOwnMessageStrategy` | Bot creates a message then edits it. Verifies content is updated. |
| 5 | Send single message | `SingleMessageBotStrategy` | Bot sends one message and returns the letterId via Completer. |

## Medium Complexity

| # | Scenario | Strategy Class | Description | Notes |
|---|----------|---------------|-------------|-------|
| 6 | Spam protection | `SpamBotStrategy` | Bot sends many messages rapidly (50ms delay). Tests rate limiting / spam handling. | Requires rate limiter to be active in test environment. |
| 7 | Full lifecycle | `FullLifecycleBotStrategy` | Bot tests send → edit → delete flow in sequence. | Tests the complete message lifecycle. |
| 8 | Two bots chat | _(new)_ | Two bots send messages to the same chat room. Verifies both receive each other's messages via `OnLetterTc`. | Requires coordinating two `ScenarioBot` instances. |
| 9 | Bot receives history | _(new)_ | Bot joins chat with existing messages and verifies `LetterHistoryTc` contains correct count. | Pre-populate DB with messages before bot joins. |
| 10 | Edit other's message fails | _(new)_ | Bot creates a message, second bot tries to edit it. Expects edit to fail silently. | Requires two bots, verify first bot's message unchanged. |

## Complex

| # | Scenario | Description | Notes |
|---|----------|-------------|-------|
| 11 | Concurrent bots spam | Multiple bots send messages simultaneously to test race conditions and data integrity. | Requires `LettersBroad._lock` to be properly tested. |
| 12 | Cross-room isolation | Bots in different roles (user vs develop) send messages. Verify messages don't leak between rooms. | Uses `Role.develop` and `Role.user` sessions. |
| 13 | Delete multiple messages | Bot creates several messages then deletes them all at once with `deleteLetters()`. | Tests batch delete endpoint. |
| 14 | Partial delete failure | Bot creates messages, then attempts to delete mix of own and others' messages. Verify partial success/failure. | Tests `DeleteLetterFailTc` with partial failures. |
| 15 | Rejoin chat | Bot joins chat, leaves, and rejoins. Verify history is still available. | Tests `subscribeChannel` idempotency. |
| 16 | Message ordering | Multiple bots send messages and verify they arrive in correct order (by `createdAt`). | Tests DB ordering and broadcast sequence. |
| 17 | Large message content | Bot sends messages with very long content (e.g., 10KB). Tests content size limits. | May need content length validation. |
| 18 | Unicode/special characters | Bot sends messages with emoji, CRLF, special chars. Tests encoding handling. | Tests content sanitization. |
