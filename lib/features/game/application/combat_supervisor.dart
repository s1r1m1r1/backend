import 'package:dto/dto.dart';
import 'package:injectable/injectable.dart';

import '../../../core/broadcast.dart';
import '../../../core/utils/noun_gen.dart';
import '../../auth/application/online_repository_impl.dart';
import '../../auth/application/session_socket.dart';
import '../../auth/domain/session_repository.dart';
import '../../auth/domain/user_repository.dart';
import '../domain/edict.dart';
import '../domain/unit_repository.dart';
import 'combat_broadcast.dart';

@lazySingleton
final class CombatSupervisor
    extends
        BroadcastSupervisor<
          CombatRoomsResponse,
          CombatResponse,
          CombatBroadcast
        > {
  CombatSupervisor(
    this.onlineRepository,
    this.sessionRepository,
    this.unitRepository,
    this.userRepository,
  ) : broadcastId = BroadcastId('combat-manager');

  final OnlineRepository onlineRepository;
  final SessionRepository sessionRepository;
  final UnitRepository unitRepository;
  final UserRepository userRepository;
  // main rooms
  final _obsListCombat = <GameSocket>{};
  final _focusObservers = <UserId, BroadcastId>{};

  Future<void> createRoom(Edict edict) async {
    final combat = CombatBroadcast(
      onlineRepository,
      sessionRepository,
      unitRepository,
      userRepository,
      edict,
    );
    combat.onCombatEnd = () => deleteRoom(edict.id);
    addRoom(combat.broadcastId, combat);
    await combat.subscribeEdict();

    // Subscribe supervisor to room messages
    combat.subscribe(this);

    // Populate listDto early so observers see it immediately
    listDto[combat.broadcastId] = CombatRoomDto(
      id: edict.id,
      members: edict.members
          .map((m) => UserMemberDto(m.userId.id, m.unitName))
          .toList(),
      maxMembers: edict.maxMembers,
      startedAt: DateTime.now(),
      status: 'prepare',
    );

    // Broadcast update to existing observers
    broadcast(
      WsResponse.combatRooms(
            n: NouN.next().v,
            broadcastId: broadcastId,
            rooms: listDto.values.toList(),
          )
          as CombatRoomsResponse,
    );

    for (final sub in _obsListCombat) {
      combat.subscribe(sub);
      sub.shouldUnsubscribe[combat.broadcastId] = () => combat.unsubscribe(sub);
    }
  }

  Future<void> subscribeObserver(GameSocket socket) async {
    if (socket.session.user.role != .develop) {
      return;
    }
    _obsListCombat.add(socket);
    subscribe(socket);
    // send initial list
    socket.sinkAdd(
      WsResponse.combatRooms(
        n: NouN.next().v,
        broadcastId: broadcastId,
        rooms: listDto.values.toList(),
      ).toPacket(),
    );
  }

  Future<void> focusObserver(GameSocket socket, String roomId) async {
    // final room = rooms[BroadcastId(roomId)];
    // if (room == null) {
    //   socket.sinkAdd(ToClient.combatError(n: roomId, error: WsCombatError.missedRoom).jsonBarrel());
    //   return;
    // }
    // _focusObservers[socket.session.user.userId] = room.broadcastId;
    // room.subscribe(socket);
  }

  void deleteRoom(String edictId) {
    final broadcast = removeRoom(BroadcastId(edictId));
    broadcast?.dispose();
  }

  Future<void> combatReady(GameSocket socket, String roomId, String n) async {
    final room = getRoom(BroadcastId(roomId));
    if (room == null) {
      socket.sinkAdd(
        WsResponse.combatError(
          n: n,
          broadcastId: broadcastId as String,
          error: WsCombatError.missedSocket,
        ).toPacket(),
      );
      return;
    }
    await room.combatReady(socket, n);
  }

  Future<void> gameAction(GameSocket socket, GameActionRequest action) async {
    final room = getRoom(BroadcastId(action.combatRoomId));
    if (room == null) {
      socket.sinkAdd(
        WsResponse.combatError(
          n: action.n,
          error: WsCombatError.missedRoom,
          broadcastId: broadcastId,
        ).toPacket(),
      );
      return;
    }
    await room.gameAction(socket, action);
  }

  Future<void> syncCombatState(
    GameSocket socket,
    SyncCombatStateRequest message,
  ) async {
    final room = getRoom(BroadcastId(message.combatRoomId));
    if (room == null) {
      socket.sinkAdd(
        WsResponse.combatError(
          n: message.n,
          error: WsCombatError.missedRoom,
          broadcastId: broadcastId as String,
        ).toPacket(),
      );
      return;
    }
    await room.syncCombatState(socket, message.n);
  }

  @override
  BroadcastId broadcastId;

  final Map<BroadcastId, CombatRoomDto> listDto = {};

  @override
  void onRoomBroadcast(EncodedPacket<CombatResponse> toClient) {
    final data = toClient.data;
    switch (data) {
      case LocationResponse():
      case CombatStartedResponse():
        break;
      case StartBattleResponse(:final membs, :final broadcastId):
        final dto = CombatRoomDto(
          id: broadcastId,
          members: membs
              .map((i) => UserMemberDto(i.userId, i.unit.name))
              .toList(),
          maxMembers: 10,
          startedAt: DateTime.now(),
          status: 'play',
        );
        listDto[BroadcastId(broadcastId)] = dto;
        _broadcastRooms();
        break;
      case CombatEventResponse():
      case CombatStateResponse():
        break;
      case CombatErrorResponse(:final isFatal, :final broadcastId):
        if (isFatal) {
          deleteRoom(broadcastId);
          listDto.remove(BroadcastId(broadcastId));
          _broadcastRooms();
        }
        break;
      case CombatClosedResponse(:final broadcastId):
      case CombatWinResponse(:final broadcastId):
        deleteRoom(broadcastId);
        listDto.remove(BroadcastId(broadcastId));
        _broadcastRooms();

        break;
    }
  }

  void _broadcastRooms() {
    broadcast(
      WsResponse.combatRooms(
            n: NouN.next().v,
            broadcastId: broadcastId,
            rooms: listDto.values.toList(),
          )
          as CombatRoomsResponse,
    );
  }

  void reset() {
    final roomsToDispose = rooms.toList();
    for (final room in roomsToDispose) {
      room.broadcast(
        WsResponse.location(n: NouN.next().v, location: GameLocation.arena)
            as CombatResponse,
      );
      room.broadcast(
        WsResponse.combatClosed(n: NouN.next().v, broadcastId: room.broadcastId)
            as CombatResponse,
      );
      deleteRoom(room.broadcastId);
    }
    listDto.clear();
    _broadcastRooms();
  }

  @override
  Future<void> dispose() async {
    reset();
    return super.dispose();
  }

  @override
  SocketId get socketId => broadcastId;
}
