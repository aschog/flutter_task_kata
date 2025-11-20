// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_task_kata/data/repositories/in_memory_task_repository.dart'
    as _i107;
import 'package:flutter_task_kata/domain/repositories/task_repository.dart'
    as _i17;
import 'package:flutter_task_kata/domain/usecases/add_task.dart' as _i1027;
import 'package:flutter_task_kata/domain/usecases/get_tasks.dart' as _i629;
import 'package:flutter_task_kata/domain/usecases/toggle_task.dart' as _i795;
import 'package:flutter_task_kata/presentation/cubit/task_cubit.dart' as _i514;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i17.TaskRepository>(() => _i107.InMemoryTaskRepository());
    gh.factory<_i1027.AddTask>(() => _i1027.AddTask(gh<_i17.TaskRepository>()));
    gh.factory<_i629.GetTasks>(() => _i629.GetTasks(gh<_i17.TaskRepository>()));
    gh.factory<_i795.ToggleTask>(
      () => _i795.ToggleTask(gh<_i17.TaskRepository>()),
    );
    gh.factory<_i514.TaskCubit>(
      () => _i514.TaskCubit(
        getTasks: gh<_i629.GetTasks>(),
        addTask: gh<_i1027.AddTask>(),
        toggleTask: gh<_i795.ToggleTask>(),
      ),
    );
    return this;
  }
}
