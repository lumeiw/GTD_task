// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:gtd_task/features/project/bloc/project_task/project_task_bloc.dart';
import 'package:gtd_task/features/task/presentation/cubits/create/create_task_cubit.dart';
import 'package:injectable/injectable.dart' as _i526;

import '../../features/project/bloc/create/project_create_bloc.dart' as _i734;
import '../../features/project/bloc/list/project_list_bloc.dart' as _i994;
import '../../features/project/data/data_source/project_local_source.dart'
    as _i988;
import '../../features/project/data/repository/project_repository_impl.dart'
    as _i369;
import '../../features/project/domain/repository/project_repository.dart'
    as _i533;
import '../../features/settings/data/repository/theme_repository_impl.dart'
    as _i907;
import '../../features/settings/domain/repository/theme_repository.dart'
    as _i695;
import '../../features/settings/presentation/cubit/theme/theme_cubit.dart'
    as _i1059;
import '../../features/task/data/datasources/local/task_local_source.dart'
    as _i544;
import '../../features/task/data/factories/task_factory_impl.dart' as _i610;
import '../../features/task/data/repositories/task_repository_impl.dart'
    as _i325;
import '../../features/task/domain/factory/i_task_factory.dart' as _i686;
import '../../features/task/domain/repositories/i_task_repository.dart'
    as _i767;
import '../../features/task/presentation/cubits/details/details_task_cubit.dart'
    as _i246;
import '../../features/task/presentation/cubits/list/list_task_cubit.dart'
    as _i289;
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
  gh.factory<ProjectTaskBloc>(() => ProjectTaskBloc(gh<_i767.ITaskRepository>()));
  gh.lazySingleton<_i988.ProjectLocalSource>(
      () => _i988.ProjectLocalSource(gh<_i329.LocalStorage>()));
  gh.lazySingleton<_i544.TaskLocalSource>(
      () => _i544.TaskLocalSource(gh<_i329.LocalStorage>()));
  gh.factory<_i686.TaskFactory>(() => _i610.TaskFactoryImpl());
  gh.lazySingleton<_i533.ProjectRepository>(() =>
      _i369.ProjectRepositoryImpl(localSource: gh<_i988.ProjectLocalSource>()));
  gh.lazySingleton<_i695.ThemeRepository>(
      () => _i907.ThemeRepositoryImpl(localstorage: gh<_i329.LocalStorage>()));
  gh.lazySingleton<_i767.ITaskRepository>(
      () => _i325.TaskRepositoryImpl(localSource: gh<_i544.TaskLocalSource>()));
  gh.factory<CreateTaskCubit>(() => CreateTaskCubit(
        gh<_i767.ITaskRepository>(),
        gh<_i686.TaskFactory>(),
      ));
  gh.factory<_i289.TaskListCubit>(
      () => _i289.TaskListCubit(gh<_i767.ITaskRepository>()));
  gh.factory<_i1059.ThemeCubit>(
      () => _i1059.ThemeCubit(gh<_i695.ThemeRepository>()));
  gh.factory<_i994.ProjectListBloc>(() =>
      _i994.ProjectListBloc(projectRepository: gh<_i533.ProjectRepository>()));
  gh.factory<_i734.CreateProjectBloc>(() => _i734.CreateProjectBloc(
      projectRepository: gh<_i533.ProjectRepository>()));
  gh.factory<_i246.TaskDetailsCubit>(() => _i246.TaskDetailsCubit(
        gh<_i767.ITaskRepository>(),
        gh<_i686.TaskFactory>(),
      ));
  return getIt;
}

class _$StorageModule extends _i148.StorageModule {}
