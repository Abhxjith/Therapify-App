import 'package:therapify/models/cbt_question.dart';

class CBTQuestionsService {
  static List<CBTQuestion> getQuestions() {
    return [
      CBTQuestion(
        id: 'q1',
        question: 'How often do you experience anxiety or stress?',
        options: [
          'Rarely or never',
          'Occasionally',
          'Frequently',
          'Almost always',
        ],
      ),
      CBTQuestion(
        id: 'q2',
        question: 'What situations trigger your anxiety?',
        options: [
          'Social interactions',
          'Work or school',
          'Health concerns',
          'Financial matters',
          'Family issues',
          // 'Future uncertainty',
        ],
        isMultiSelect: true,
      ),
      CBTQuestion(
        id: 'q3',
        question: 'How do you typically respond to stress?',
        options: [
          'I try to avoid the situation',
          'I seek support from others',
          'I use relaxation techniques',
          'I try to solve the problem',
          'I become overwhelmed',
        ],
        isMultiSelect: true,
      ),
      CBTQuestion(
        id: 'q4',
        question: 'What physical symptoms do you experience when anxious?',
        options: [
          'Rapid heartbeat',
          'Sweating',
          'Shortness of breath',
          'Nausea',
          'Headaches',
        ],
        isMultiSelect: true,
      ),
      CBTQuestion(
        id: 'q5',
        question: 'How would you rate your current sleep quality?',
        options: [
          'Excellent',
          'Good',
          'Fair',
          'Poor',
          'Very poor',
        ],
      ),
    ];
  }
} 