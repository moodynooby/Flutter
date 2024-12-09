import 'package:flutter/foundation.dart';
import 'package:shared_preferences.dart';
import 'dart:convert';
import '../models/subject.dart';
import '../models/topic.dart';

class SubjectProvider with ChangeNotifier {
  List<Subject> _subjects = [];
  final String _storageKey = 'subjects';

  List<Subject> get subjects => [..._subjects];

  SubjectProvider() {
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final String? subjectsJson = prefs.getString(_storageKey);
    
    if (subjectsJson != null) {
      final List<dynamic> decoded = json.decode(subjectsJson);
      _subjects = decoded.map((item) => Subject.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(
      _subjects.map((subject) => subject.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encoded);
  }

  void addSubject(String name) {
    _subjects.add(Subject(name: name));
    _saveSubjects();
    notifyListeners();
  }

  void addTopic(String subjectId, String topicName) {
    final subjectIndex = _subjects.indexWhere((s) => s.id == subjectId);
    if (subjectIndex != -1) {
      final subject = _subjects[subjectIndex];
      final updatedTopics = [...subject.topics, Topic(name: topicName)];
      _subjects[subjectIndex] = subject.copyWith(topics: updatedTopics);
      _saveSubjects();
      notifyListeners();
    }
  }

  void toggleTopicCompletion(String subjectId, String topicId) {
    final subjectIndex = _subjects.indexWhere((s) => s.id == subjectId);
    if (subjectIndex != -1) {
      final subject = _subjects[subjectIndex];
      final topicIndex = subject.topics.indexWhere((t) => t.id == topicId);
      
      if (topicIndex != -1) {
        final topic = subject.topics[topicIndex];
        final updatedTopic = topic.copyWith(
          isCompleted: !topic.isCompleted,
          completedAt: !topic.isCompleted ? DateTime.now() : null,
        );
        
        final updatedTopics = [...subject.topics];
        updatedTopics[topicIndex] = updatedTopic;
        
        _subjects[subjectIndex] = subject.copyWith(topics: updatedTopics);
        _saveSubjects();
        notifyListeners();
      }
    }
  }

  void deleteSubject(String subjectId) {
    _subjects.removeWhere((subject) => subject.id == subjectId);
    _saveSubjects();
    notifyListeners();
  }

  void deleteTopic(String subjectId, String topicId) {
    final subjectIndex = _subjects.indexWhere((s) => s.id == subjectId);
    if (subjectIndex != -1) {
      final subject = _subjects[subjectIndex];
      final updatedTopics = subject.topics.where((t) => t.id != topicId).toList();
      _subjects[subjectIndex] = subject.copyWith(topics: updatedTopics);
      _saveSubjects();
      notifyListeners();
    }
  }
}