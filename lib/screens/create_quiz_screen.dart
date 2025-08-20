import 'package:flutter/material.dart';
import 'package:academia_flow/models/quiz.dart';
import 'package:academia_flow/services/storage_service.dart';

class CreateQuizScreen extends StatefulWidget {
  final String subjectId;

  const CreateQuizScreen({super.key, required this.subjectId});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<QuestionBuilder> questions = [QuestionBuilder()];

  @override
  void dispose() {
    _titleController.dispose();
    for (final question in questions) {
      question.dispose();
    }
    super.dispose();
  }

  void _addQuestion() {
    setState(() {
      questions.add(QuestionBuilder());
    });
  }

  void _removeQuestion(int index) {
    if (questions.length > 1) {
      setState(() {
        questions[index].dispose();
        questions.removeAt(index);
      });
    }
  }

  Future<void> _saveQuiz() async {
    if (_formKey.currentState?.validate() ?? false) {
      final quiz = Quiz(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        subjectId: widget.subjectId,
        title: _titleController.text.trim(),
        questions: questions.map((q) => q.toQuestion()).toList(),
        createdAt: DateTime.now(),
      );

      await StorageService.addQuiz(quiz);

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quiz'),
        actions: [
          TextButton(
            onPressed: _saveQuiz,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Quiz Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a quiz title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Questions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...questions.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Question ${index + 1}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            if (questions.length > 1)
                              IconButton(
                                onPressed: () => _removeQuestion(index),
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: question.questionController,
                          decoration: const InputDecoration(
                            labelText: 'Question text',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a question';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(4, (optionIndex) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Radio<int>(
                                  value: optionIndex,
                                  groupValue: question.correctAnswer,
                                  onChanged: (value) {
                                    setState(() {
                                      question.correctAnswer = value!;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: question.optionControllers[optionIndex],
                                    decoration: InputDecoration(
                                      labelText: 'Option ${optionIndex + 1}',
                                      border: const OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Please enter an option';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _addQuestion,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Question'),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveQuiz,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Create Quiz'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionBuilder {
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  int correctAnswer = 0;

  void dispose() {
    questionController.dispose();
    for (final controller in optionControllers) {
      controller.dispose();
    }
  }

  Question toQuestion() {
    return Question(
      text: questionController.text.trim(),
      options: optionControllers.map((c) => c.text.trim()).toList(),
      correctAnswer: correctAnswer,
    );
  }
}