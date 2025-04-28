import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // название метода инициализации
  preferRelativeImports: true, // использовать относительные импорты
  asExtension: false, // не использовать расширения
)
Future<void> configureDependencies() => init(getIt);