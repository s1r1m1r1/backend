import 'package:types/types.dart';

typedef UserMember = ({UserId userId, String unitName});

class Edict {
  Edict({
    required this.id,
    required this.maxMembers,
    required this.createdAt,
    required this.members,
    required this.startIn,
    required this.isFighting,
  });
  final BroadcastId id;
  final int maxMembers;
  final List<UserMember> members;
  final DateTime createdAt;
  final DateTime startIn;
  bool isFighting;
  bool get isFull => members.length >= maxMembers;

  @override
  int get hashCode => Object.hashAll([id, maxMembers]);

  @override
  bool operator ==(Object other) =>
      other is Edict && other.id == id && other.isFighting == isFighting;
}
