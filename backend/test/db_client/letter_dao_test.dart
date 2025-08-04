import 'package:backend/db_client/dao/letters_dao.dart';
import 'package:backend/db_client/db_client.dart';
import 'package:backend/models/enums.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  late DbClient db;
  late LettersDao dao;

  setUp(() {
    db = DbClient(NativeDatabase.memory());
    dao = LettersDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  LetterTableCompanion sampleLetter({required int chatRoomId, required int senderId, String content = 'Hello'}) {
    return LetterTableCompanion.insert(
      chatRoomId: chatRoomId,
      senderId: senderId,
      content: content,
      // Add other required fields here if needed
    );
  }

  test('insertRow inserts and returns the letter', () async {
    final user = await db.userDao.insert(UserTableCompanion.insert(email: 'name@name.net', password: '123'));
    final room = await db.roomDao.insertRoom(RoomTableCompanion.insert(name: 'Test Room', type: RoomType.chat));
    if (room == null) {
      fail('Failed to create user or chat room');
    }
    final userInRoom = await db.roomDao.insertMember(
      RoomMemberTableCompanion.insert(chatRoomId: room.id, userId: user.id),
    );
    if (userInRoom == null) {
      fail('Failed to add user to chat room');
    }
    final inserted = await dao.insertRow(sampleLetter(chatRoomId: userInRoom.chatRoomId, senderId: userInRoom.userId));
    expect(inserted, isNotNull);
    expect(inserted!.content, 'Hello');
  });

  test('getLetters returns all inserted letters', () async {
    final user = await db.userDao.insert(UserTableCompanion.insert(email: 'name@name.net', password: '123'));
    final room = await db.roomDao.insertRoom(RoomTableCompanion.insert(name: 'Test Room', type: RoomType.chat));
    if (room == null) {
      fail('Failed to create user or chat room');
    }
    final userInRoom = await db.roomDao.insertMember(
      RoomMemberTableCompanion.insert(chatRoomId: room.id, userId: user.id),
    );
    if (userInRoom == null) {
      fail('Failed to add user to chat room');
    }
    await dao.insertRow(sampleLetter(chatRoomId: userInRoom.chatRoomId, senderId: userInRoom.userId, content: 'A'));
    await dao.insertRow(sampleLetter(chatRoomId: userInRoom.chatRoomId, senderId: userInRoom.userId, content: 'B'));
    final letters = await dao.getListLetter();
    expect(letters.length, 2);
    expect(letters.map((l) => l.content), containsAll(['A', 'B']));
  });

  test('getLettersByChannel returns only letters for the given channel', () async {
    final user = await db.userDao.insert(UserTableCompanion.insert(email: 'name@name.net', password: '123'));
    final room1 = await db.roomDao.insertRoom(RoomTableCompanion.insert(name: 'Test Room 1', type: RoomType.chat));
    final room2 = await db.roomDao.insertRoom(RoomTableCompanion.insert(name: 'Test Room 2', type: RoomType.chat));
    if (room1 == null || room2 == null) {
      fail('Failed to create user or chat room');
    }
    final userInRoom1 = await db.roomDao.insertMember(
      RoomMemberTableCompanion.insert(chatRoomId: room1.id, userId: user.id),
    );
    final userInRoom2 = await db.roomDao.insertMember(
      RoomMemberTableCompanion.insert(chatRoomId: room2.id, userId: user.id),
    );
    if (userInRoom1 == null || userInRoom2 == null) {
      fail('Failed to add user to chat room');
    }
    await dao.insertRow(sampleLetter(chatRoomId: userInRoom1.chatRoomId, senderId: userInRoom1.userId, content: 'A'));
    await dao.insertRow(sampleLetter(chatRoomId: userInRoom2.chatRoomId, senderId: userInRoom2.userId, content: 'B'));
    final letters = await dao.getListLetter(chatRoomId: userInRoom2.chatRoomId);
    expect(letters.length, 1);
    expect(letters.first.content, 'B');
  });

  test('deleteLetter removes the letter with the given id', () async {
    final user = await db.userDao.insert(UserTableCompanion.insert(email: 'name@name.net', password: '123'));
    final room = await db.roomDao.insertRoom(RoomTableCompanion.insert(name: 'Test Room', type: RoomType.chat));
    if (room == null) {
      fail('Failed to create user or chat room');
    }
    final userInRoom = await db.roomDao.insertMember(
      RoomMemberTableCompanion.insert(chatRoomId: room.id, userId: user.id),
    );
    if (userInRoom == null) {
      fail('Failed to add user to chat room');
    }
    final inserted = await dao.insertRow(
      sampleLetter(chatRoomId: userInRoom.chatRoomId, senderId: userInRoom.userId, content: 'To be deleted'),
    );
    expect(inserted, isNotNull);
    await dao.deleteLetter(inserted!.id);
    final letters = await dao.getListLetter(chatRoomId: userInRoom.chatRoomId);
    expect(letters, isEmpty);
  });

  test('deleteLettersByChannel removes all letters for the given channel', () async {
    final user = await db.userDao.insert(UserTableCompanion.insert(email: 'name@name.net', password: '123'));
    final room1 = await db.roomDao.insertRoom(RoomTableCompanion.insert(name: 'Test Room 1', type: RoomType.chat));
    final room2 = await db.roomDao.insertRoom(RoomTableCompanion.insert(name: 'Test Room 2', type: RoomType.chat));
    if (room1 == null || room2 == null) {
      fail('Failed to create user or chat room');
    }
    final userInRoom1 = await db.roomDao.insertMember(
      RoomMemberTableCompanion.insert(chatRoomId: room1.id, userId: user.id),
    );
    final userInRoom2 = await db.roomDao.insertMember(
      RoomMemberTableCompanion.insert(chatRoomId: room2.id, userId: user.id),
    );
    if (userInRoom1 == null || userInRoom2 == null) {
      fail('Failed to add user to chat room');
    }
    await dao.insertRow(sampleLetter(chatRoomId: userInRoom1.chatRoomId, senderId: userInRoom1.userId, content: 'A'));
    await dao.insertRow(sampleLetter(chatRoomId: userInRoom2.chatRoomId, senderId: userInRoom2.userId, content: 'B'));
    await dao.deleteLettersByChannel(userInRoom1.chatRoomId);
    final letters = await dao.getListLetter();
    expect(letters.length, 1);
    expect(letters.first.chatRoomId, userInRoom2.chatRoomId);
  });
}
