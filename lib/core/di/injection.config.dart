// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:gtd_task/features/task/data/datasources/local/task_local_source.dart';
import 'package:gtd_task/features/task/data/factories/task_factory_impl.dart';
import 'package:gtd_task/features/task/data/repositories/task_repository_impl.dart';
import 'package:gtd_task/features/task/presentation/cubits/details/details_task_cubit.dart';
import 'package:gtd_task/features/task/presentation/cubits/list/list_task_cubit.dart';
import 'package:injectable/injectable.dart' as _i526;

import '../../features/settings/data/repository/theme_repository_impl.dart'
    as _i907;
import '../../features/settings/domain/repository/theme_repository.dart'
    as _i695;
import '../../features/settings/presentation/cubit/theme/theme_cubit.dart'
    as _i1059;

import '../../features/task/domain/factory/i_task_factory.dart' as _i686;
import '../../features/task/domain/repositories/i_task_repository.dart'
    as _i767;
import '../../features/task/presentation/cubits/create/create_task_cubit.dart'
    as _i778;
import '../../features/task_action/presentation/cubit/task_actions_cubit.dart'
    as _i1023;
import '../storage/local_storage.dart' as _i329;
import 'modules/storage_module.dart' as _i148;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final storageModule = _$StorageModule();
  gh.factory<_i1023.TaskActionsCubit>(() => _i1023.TaskActionsCubit());
  await gh.singletonAsync<_i329.LocalStorage>(
    () => storageModule.provideLocalStorage(),
    preResolve: true,
  );
  gh.factory<_i686.TaskFactory>(() => TaskFactoryImpl());
  gh.factory<_i778.CreateTaskCubit>(() => _i778.CreateTaskCubit(
        gh<_i767.ITaskRepository>(),
        gh<_i686.TaskFactory>(),
      ));
  gh.lazySingleton<TaskLocalSource>(
      () => TaskLocalSource(gh<_i329.LocalStorage>()));
  gh.lazySingleton<_i695.ThemeRepository>(
      () => _i907.ThemeRepositoryImpl(localstorage: gh<_i329.LocalStorage>()));
  gh.lazySingleton<_i767.ITaskRepository>(
      () => TaskRepositoryImpl(localSource: gh<TaskLocalSource>()));
  gh.factory<_i1059.ThemeCubit>(
      () => _i1059.ThemeCubit(gh<_i695.ThemeRepository>()));
  gh.factory<TaskListCubit>(() => TaskListCubit(gh<_i767.ITaskRepository>()));
  gh.factory<TaskDetailsCubit>(() => TaskDetailsCubit(
        gh<_i767.ITaskRepository>(),
        gh<_i686.TaskFactory>(),
      ));
  return getIt;
}

class _$StorageModule extends _i148.StorageModule {}
