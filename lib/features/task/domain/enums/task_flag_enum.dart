enum TaskFlag {
  priority,   // Приоритетная
  next,       // Следующая
  blocked,    // Заблокирована (невозможно выполинть на данный момен)
  delegated,  // Делегирована (переданна другому лицу)
  recurring   // Повторяющаяся
}