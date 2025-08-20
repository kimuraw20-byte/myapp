import 'package:flutter/material.dart';
import 'package:academia_flow/models/quiz.dart';

class TakeQuizScreen extends StatefulWidget {
  final Quiz quiz;

  const TakeQuizScreen({super.key, required this.quiz});

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  int currentQuestionIndex = 0;
  List<int?> selectedAnswers = [];
  bool isQuizCompleted = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    selectedAnswers = List.filled(widget.quiz.questions.length, null);
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      selectedAnswers[currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _completeQuiz();
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void _completeQuiz() {
    score = 0;
    for (int i = 0; i < widget.quiz.questions.length; i++) {
      if (selectedAnswers[i] == widget.quiz.questions[i].correctAnswer) {
        score++;
      }
    }
    setState(() {
      isQuizCompleted = true;
    });
  }

  void _restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      selectedAnswers = List.filled(widget.quiz.questions.length, null);
      isQuizCompleted = false;
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isQuizCompleted) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Results'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  score >= widget.quiz.questions.length * 0.7 ? Icons.celebration : Icons.sentiment_neutral,
                  size: 80,
                  color: score >= widget.quiz.questions.length * 0.7 ? Colors.green : Colors.orange,
                ),
                const SizedBox(height: 24),
                Text(
                  'Quiz Completed!',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  'Your Score: $score/${widget.quiz.questions.length}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${((score / widget.quiz.questions.length) * 100).round()}%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _restartQuiz,
                    child: const Text('Try Again'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Quizzes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentQuestion = widget.quiz.questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / widget.quiz.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: progress),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1} of ${widget.quiz.questions.length}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              currentQuestion.text,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.options.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedAnswers[currentQuestionIndex] == index;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
                    child: ListTile(
                      title: Text(currentQuestion.options[index]),
                      leading: Radio<int>(
                        value: index,
                        groupValue: selectedAnswers[currentQuestionIndex],
                        onChanged: (value) => _selectAnswer(value!),
                      ),
                      onTap: () => _selectAnswer(index),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                if (currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousQuestion,
                      child: const Text('Previous'),
                    ),
                  ),
                if (currentQuestionIndex > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedAnswers[currentQuestionIndex] != null ? _nextQuestion : null,
                    child: Text(
                      currentQuestionIndex < widget.quiz.questions.length - 1 ? 'Next' : 'Finish',
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
}