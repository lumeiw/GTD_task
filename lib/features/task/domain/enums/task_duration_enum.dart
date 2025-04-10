enum TaskDuration {
  short,
  medium,
  long,
  veryLong,
  undefined;
  
  
  String get time {
    return switch (this) {
      TaskDuration.short => '5m',
      TaskDuration.medium => '10m',
      TaskDuration.long => '30m',
      TaskDuration.veryLong => '1h',
      TaskDuration.undefined => '?',
    };
  }

  String get display {
    return switch (this){
      TaskDuration.short => 'Короткая (5 m)',
      TaskDuration.medium => 'Средняя (10 m)',
      TaskDuration.long => 'Длинная (30 m)',
      TaskDuration.veryLong => 'Очень длинная (1 h)',
      TaskDuration.undefined => 'Неизвестная',
    };
  }
}