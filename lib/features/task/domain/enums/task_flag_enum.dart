enum TaskFlag {
  none,
  priority,   // Приоритетная
  next,       // Следующая
  blocked,    // Заблокирована (невозможно выполинть на данный момен)
  delegated,  // Делегирована (переданна другому лицу)
  recurring;  // Повторяющаяся

  String get display => '@${toString().split('.').last.toLowerCase()}';
}

//* Тут рассширяем класс List, чтобы у нас был новый метод 
extension TaskFlagsExtension on List<TaskFlag> {
  String get displayText => 
    isNotEmpty 
      ? map((flag) => flag.display).join(' ')
      : '@none';
}