import 'package:flutter/material.dart';

class Question {
  final String text;
  final String? yesText;
  final String? noText;
  final Function(bool)? onAnswer;
  final int? yesNextIndex;
  final int? noNextIndex;

  Question({
    required this.text,
    this.yesText = 'Да',
    this.noText = 'Нет',
    this.onAnswer,
    this.yesNextIndex,
    this.noNextIndex,
  });
}

class QuestionCard extends StatefulWidget {
  final List<Question> questions;
  final VoidCallback? onCompleted;

  const QuestionCard({
    Key? key,
    required this.questions,
    this.onCompleted,
  }) : super(key: key);

  QuestionCard.single({
    Key? key,
    required String question,
    required VoidCallback onYes,
    required VoidCallback onNo,
    String? yesText = 'Да',
    String? noText = 'Нет',
  }) : this(
          key: key,
          questions: [
            Question(
              text: question,
              yesText: yesText,
              noText: noText,
              onAnswer: (bool isYes) {
                if (isYes) {
                  onYes();
                } else {
                  onNo();
                }
              },
            ),
          ],
        );

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  int _currentIndex = 0;
  List<QuestionResult> _answers = [];

  @override
  void initState() {
    super.initState();
    _answers = [];
  }

  void _handleAnswer(bool isYes) {
    final currentQuestion = widget.questions[_currentIndex];
    currentQuestion.onAnswer?.call(isYes);

    _answers.add(QuestionResult(
      question: currentQuestion.text,
      answer: isYes ? 'Да' : 'Нет',
    ));

    final nextIndex =
        isYes ? currentQuestion.yesNextIndex : currentQuestion.noNextIndex;

    if (nextIndex != null && nextIndex < widget.questions.length) {
      setState(() {
        _currentIndex = nextIndex;
      });
    } else {
      widget.onCompleted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return QuestionCardContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Отображение предыдущих вопросов и ответов
            ..._buildPreviousQuestionsAndAnswers(colorScheme, context),

            // Текущий вопрос
            Text(
              widget.questions[_currentIndex].text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
            ),

            const SizedBox(height: 24),

            // Кнопки для текущего вопроса
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Кнопка НЕТ
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _handleAnswer(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(
                        color: colorScheme.secondary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      widget.questions[_currentIndex].noText ?? 'Нет',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Кнопка ДА
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _handleAnswer(true),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(
                        color: colorScheme.secondary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      widget.questions[_currentIndex].yesText ?? 'Да',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPreviousQuestionsAndAnswers(
      ColorScheme colorScheme, BuildContext context) {
    if (_answers.isEmpty) {
      return [];
    }

    List<Widget> widgets = [];

    for (var i = 0; i < _answers.length; i++) {
      final result = _answers[i];

      widgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.question,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Ответ: ${result.answer}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    widgets.add(const SizedBox(height: 16));
    return widgets;
  }
}

class QuestionResult {
  final String question;
  final String answer;

  QuestionResult({required this.question, required this.answer});
}

class QuestionCardContainer extends StatelessWidget {
  final Widget child;

  const QuestionCardContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 351,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.onBackground,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: colorScheme.surface.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Material(
            color: Colors.transparent,
            child: child,
          ),
        ),
      ),
    );
  }
}
