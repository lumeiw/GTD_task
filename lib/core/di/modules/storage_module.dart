import 'package:injectable/injectable.dart';
import 'package:gtd_task/core/storage/local_storage.dart';

@module
abstract class StorageModule {
  @preResolve // для асинхронной инициализации
  @singleton
  Future<LocalStorage> provideLocalStorage() async {
    final localStorage = LocalStorage();
    await localStorage.init();
    return localStorage;
  }
}