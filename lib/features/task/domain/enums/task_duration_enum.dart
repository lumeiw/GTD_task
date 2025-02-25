enum TaskDuration {
  // Очень быстрая задача (до 5 минут)
  veryShort(5, 'Очень быстро'),
  
  // Короткая задача (до 15 минут)
  short(15, 'Быстро'),
  
  // Средняя задача (до 30 минут)
  medium(30, 'Средне'),
  
  // Длинная задача (до 1 часа)
  long(60, 'Долго'),
  
  // Очень длинная задача (более 1 часа)
  veryLong(120, 'Очень долго'),
  
  // Неопределенная продолжительность
  undefined(0, 'Не определено');
  
  // Примерное время выполнения в минутах
  final int minutes;
  
  
  final String displayName;
  
  const TaskDuration(this.minutes, this.displayName);
  
  // Получение строкового представления для отображения
  String get display => displayName;
}