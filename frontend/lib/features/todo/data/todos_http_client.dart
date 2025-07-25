import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../domain/models/create_todo_dto.dart';
import '../domain/models/todo.dart';
import '../domain/models/update_todo_dto.dart';
part 'todos_http_client.g.dart';

@RestApi()
@lazySingleton
abstract class TodosHttpClient {
  @factoryMethod
  factory TodosHttpClient(Dio dio) = _TodosHttpClient;
  @GET('/todos')
  Future<List<Todo>> getAllTodo();
  @GET('/todos/{id}')
  Future<Todo> getTodoById(@Path('id') int todoId);
  @POST('/todos')
  Future<Todo> createTodo(@Body() CreateTodoDto todo);
  @PATCH('/todos/{id}')
  Future<Todo> updateTodo(@Path('id') int todoId, @Body() UpdateTodoDto todo);
  @DELETE('/todos/{id}')
  Future<void> deleteTodoById(@Path('id') int todoId);
}
