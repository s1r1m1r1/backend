---
name: websocket-protocol-expert
description: Specialized knowledge for I_GAME WebSocket protocol, DTO mappings, and command execution.
---

# WebSocket Protocol Expert (Backend View)

This skill describes the server-side handling of the WebSocket protocol.

## Protocol Structure
- **DTO Package**: Shared library containing `WsResponse` and `ToRequest` definitions.
- **WsCmdExecutor**: The central router for all incoming `ToRequest` messages.

## Command Implementation Pattern
Every command must extend `WsCmd<T extends ToServer>` or `AuthenticatedWsCmd<T extends ToServer>`.

### Mapping Table
| ToServer DTO | Command Class | Location |
|--------------|----------------|----------|
| `PingTs` | `PingCmd` | `lib/ws/ping.cmd.dart` |
| `AckTs` | `AckCmd` | `lib/ws/ack.cmd.dart` |
| `WithTokenTs` | `WithTokenCmd` | `lib/ws/with_token.cmd.dart` |
| `GameActionTs` | `GameActionCmd` | `lib/ws/game_action.cmd.dart` |
| `ChangeLocationTs` | `ChangeLocationCmd` | `lib/ws/change_location.cmd.dart` |

## Response Standards
- **AcknowledgeTc**: Use `WsResponse.ack` or `WsResponse.pong` for direct replies.
- **Broadcasts**: Use `channel.sinkAdd` for single replies, and specific broadcast streams for room-wide updates.
- **Timestamps**: Always include `ts` in milliseconds for latency tracking.

## Error Handling
- Use `WebSocketCloseCode` (e.g., 4004 for `UnitNotFound`) to trigger client-side redirection.
- `CombatErrorTc` should be used for non-terminal game logic errors.
