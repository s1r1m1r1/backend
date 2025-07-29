// import 'package:backend/models/user.dart';
// import 'package:backend/todo/datasource/todo_datasource.dart';
// import 'package:backend/todo/repository/todo_repository.dart';
// import 'package:shared/shared.dart';
// import 'package:test/test.dart';
// import 'package:mockito/mockito.dart';

// // Mocks
// class MockTodoDataSource extends Mock implements TodoDataSource {}

// class MockUser extends Mock implements User {}

// void main() {
//   late TodoRepositoryImpl todoRepository;
//   late MockTodoDataSource mockTodoDataSource;
//   late MockUser mockUser;

//   // Sample data
//   final String userId = 'test_user_id';
//   final TodoDto sampleTodo = TodoDto(
//     id: 1,
//     title: 'Test Todo',
//     description: 'This is a test todo',
//     createdAt: DateTime.now(),
//     completed: false,
//   );
//   final CreateTodoDto sampleCreateTodoDto = CreateTodoDto('New Todo', 'Description for new todo');
//   // final UpdateTodoDto sampleUpdateTodoDto = UpdateTodoDto(title: 'Updated Todo', completed: true);

//   setUp(() {
//     mockTodoDataSource = MockTodoDataSource();
//     mockUser = MockUser();
//     when(mockUser.userId).thenReturn(userId); // Stubbing userId for the mock user
//     todoRepository = TodoRepositoryImpl(mockTodoDataSource, mockUser);
//   });

//   group('TodoRepositoryImpl', () {
//     group('getTodos', () {
//       test('should return a list of TodoDto when successful', () async {
//         when(mockTodoDataSource.getAllTodo(userId)).thenAnswer((_) async => [sampleTodo]);

//         final result = await todoRepository.getTodos();

//         expect(result, isA<List<TodoDto>>());
//         expect(result.length, 1);
//         expect(result.first.title, 'Test Todo');
//         verify(mockTodoDataSource.getAllTodo(userId)).called(1);
//       });

//       test('should throw an exception if datasource throws an exception', () {
//         when(mockTodoDataSource.getAllTodo(userId)).thenThrow(Exception('Failed to fetch todos'));

//         expectLater(() => todoRepository.getTodos(), throwsA(isA<Exception>()));
//         verify(mockTodoDataSource.getAllTodo(userId)).called(1);
//       });
//     });

//     //   group('getTodoById', () {
//     //     test('should return a TodoDto when successful', () async {
//     //       when(mockTodoDataSource.getTodoById(sampleTodo.id!, userId)).thenAnswer((_) async => sampleTodo);

//     //       final result = await todoRepository.getTodoById(sampleTodo.id!);

//     //       expect(result, isA<TodoDto>());
//     //       expect(result.id, sampleTodo.id);
//     //       verify(mockTodoDataSource.getTodoById(sampleTodo.id!, userId)).called(1);
//     //     });

//     //     test('should throw an exception if datasource throws an exception', () {
//     //       when(mockTodoDataSource.getTodoById(sampleTodo.id!, userId)).thenThrow(Exception('Todo not found'));

//     //       expectLater(() => todoRepository.getTodoById(sampleTodo.id!), throwsA(isA<Exception>()));
//     //       verify(mockTodoDataSource.getTodoById(sampleTodo.id!, userId)).called(1);
//     //     });
//     //   });

//     //   group('createTodo', () {
//     //     test('should return created TodoDto when successful', () async {
//     //       when(mockTodoDataSource.createTodo(sampleCreateTodoDto, userId)).thenAnswer((_) async => sampleTodo);

//     //       final result = await todoRepository.createTodo(sampleCreateTodoDto);

//     //       expect(result, isA<TodoDto>());
//     //       expect(result.title, sampleTodo.title);
//     //       verify(mockTodoDataSource.createTodo(sampleCreateTodoDto, userId)).called(1);
//     //     });

//     //     test('should throw an exception if datasource throws an exception', () {
//     //       when(mockTodoDataSource.createTodo(sampleCreateTodoDto, userId)).thenThrow(Exception('Failed to create todo'));

//     //       expectLater(() => todoRepository.createTodo(sampleCreateTodoDto), throwsA(isA<Exception>()));
//     //       verify(mockTodoDataSource.createTodo(sampleCreateTodoDto, userId)).called(1);
//     //     });
//     //   });

//     //   group('updateTodo', () {
//     //     test('should return updated TodoDto when successful', () async {
//     //       when(
//     //         mockTodoDataSource.updateTodo(todoId: sampleTodo.id!, todo: sampleUpdateTodoDto, userId: userId),
//     //       ).thenAnswer(
//     //         (_) async => sampleTodo.copyWith(title: sampleUpdateTodoDto.title, completed: sampleUpdateTodoDto.completed),
//     //       );

//     //       final result = await todoRepository.updateTodo(todoId: sampleTodo.id!, updateTodoDto: sampleUpdateTodoDto);

//     //       expect(result, isA<TodoDto>());
//     //       expect(result.title, sampleUpdateTodoDto.title);
//     //       expect(result.completed, sampleUpdateTodoDto.completed);
//     //       verify(
//     //         mockTodoDataSource.updateTodo(todoId: sampleTodo.id!, todo: sampleUpdateTodoDto, userId: userId),
//     //       ).called(1);
//     //     });

//     //     test('should throw an exception if datasource throws an exception', () {
//     //       when(
//     //         mockTodoDataSource.updateTodo(todoId: sampleTodo.id!, todo: sampleUpdateTodoDto, userId: userId),
//     //       ).thenThrow(Exception('Failed to update todo'));

//     //       expectLater(
//     //         () => todoRepository.updateTodo(todoId: sampleTodo.id!, updateTodoDto: sampleUpdateTodoDto),
//     //         throwsA(isA<Exception>()),
//     //       );
//     //       verify(
//     //         mockTodoDataSource.updateTodo(todoId: sampleTodo.id!, todo: sampleUpdateTodoDto, userId: userId),
//     //       ).called(1);
//     //     });
//     //   });

//     //   group('deleteTodo', () {
//     //     test('should call deleteTodoById on datasource when successful', () async {
//     //       when(
//     //         mockTodoDataSource.getTodoById(sampleTodo.id!, userId),
//     //       ).thenAnswer((_) async => sampleTodo); // Mock getTodoById for the delete flow
//     //       when(mockTodoDataSource.deleteTodoById(sampleTodo.id!, userId)).thenAnswer((_) async => Future.value());

//     //       await todoRepository.deleteTodo(sampleTodo.id!);

//     //       verify(mockTodoDataSource.getTodoById(sampleTodo.id!, userId)).called(1);
//     //       verify(mockTodoDataSource.deleteTodoById(sampleTodo.id!, userId)).called(1);
//     //     });

//     //     test('should not throw if getTodoById fails but deleteTodoById is not called', () async {
//     //       when(
//     //         mockTodoDataSource.getTodoById(sampleTodo.id!, userId),
//     //       ).thenThrow(Exception('Todo not found for deletion'));

//     //       await todoRepository.deleteTodo(sampleTodo.id!); // Error is logged, not thrown

//     //       verify(mockTodoDataSource.getTodoById(sampleTodo.id!, userId)).called(1);
//     //       verifyNever(mockTodoDataSource.deleteTodoById(any, any)); // Ensure delete is not called
//     //     });

//     //     test('should not throw if deleteTodoById fails', () async {
//     //       when(mockTodoDataSource.getTodoById(sampleTodo.id!, userId)).thenAnswer((_) async => sampleTodo);
//     //       when(
//     //         mockTodoDataSource.deleteTodoById(sampleTodo.id!, userId),
//     //       ).thenThrow(Exception('Failed to delete from DB'));

//     //       await todoRepository.deleteTodo(sampleTodo.id!); // Error is logged, not thrown

//     //       verify(mockTodoDataSource.getTodoById(sampleTodo.id!, userId)).called(1);
//     //       verify(mockTodoDataSource.deleteTodoById(sampleTodo.id!, userId)).called(1);
//     //     });
//     //   });
//   });
// }
