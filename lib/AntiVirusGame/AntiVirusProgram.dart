import 'package:flutter/material.dart';
import 'Questions.dart';
import 'dart:async';
import 'dart:math';

class AntivirusProgram {
  List<Question> trojanQuestions = [
    Question(
      questionText: 'ما هو حصان طروادة في عالم الكمبيوتر؟',
      options: [
        'برنامج مفيد',
        'فيروس يتنكر كبرنامج شرعي',
        'أداة لتحسين الأداء',
        'نوع من الأجهزة'
      ],
      correctAnswer: 'فيروس يتنكر كبرنامج شرعي',
    ),
    // أضف المزيد من الأسئلة حول حصان طروادة
  ];

  List<Question> wormQuestions = [
    Question(
      questionText: 'كيف تنتشر الدودة في الشبكات؟',
      options: [
        'من خلال نسخ نفسها عبر الشبكة',
        'عن طريق المستخدمين فقط',
        'لا تنتشر على الإطلاق',
        'من خلال الأجهزة الخارجية فقط'
      ],
      correctAnswer: 'من خلال نسخ نفسها عبر الشبكة',
    ),
    // أضف المزيد من الأسئلة حول الديدان
  ];

  List<Question> spywareQuestions = [
    Question(
      questionText: 'ما هو الهدف الرئيسي لفيروسات التجسس؟',
      options: [
        'تحسين أداء النظام',
        'جمع المعلومات الشخصية',
        'تدمير الملفات',
        'تحديث البرامج'
      ],
      correctAnswer: 'جمع المعلومات الشخصية',
    ),
    // أضف المزيد من الأسئلة حول برامج التجسس
  ];

  // إرجاع سؤال بناءً على نوع الفيروس
  Question getQuestionByVirusType(String virusType) {
    Random random = Random();
    if (virusType == 'حصان طروادة') {
      return trojanQuestions[random.nextInt(trojanQuestions.length)];
    } else if (virusType == 'دودة') {
      return wormQuestions[random.nextInt(wormQuestions.length)];
    } else if (virusType == 'فيروس تجسس') {
      return spywareQuestions[random.nextInt(spywareQuestions.length)];
    } else {
      // افتراضيًا، إذا لم يتم تحديد النوع
      return trojanQuestions[random.nextInt(trojanQuestions.length)];
    }
  }

  // مسح الملفات للبحث عن الفيروسات
  void scanFiles(List<FileItem> filesToScan) {
    // تحديث حالة الملفات لتكون "تم المسح"
    for (var file in filesToScan) {
      file.scanned = true;
    }
  }
}
