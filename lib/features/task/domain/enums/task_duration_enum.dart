enum TaskDuration {
  veryShort,
  short,
  medium,
  long,
  veryLong,
  undefined;
  
  
  String get time {
    return switch (this) {
      TaskDuration.veryShort => '1m',
      TaskDuration.short => '5m',
      TaskDuration.medium => '10m',
      TaskDuration.long => '30m',
      TaskDuration.veryLong => '1h',
      TaskDuration.undefined => '?',
    };
  }

  String get display {
    return switch (this){
      TaskDuration.veryShort => 'Очень короткая',
      TaskDuration.short => 'Короткая',
      TaskDuration.medium => 'Средняя',
      TaskDuration.long => 'Длинная',
      TaskDuration.veryLong => 'Очень длинная',
      TaskDuration.undefined => '?',
    };
  }
}