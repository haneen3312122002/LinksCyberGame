import 'package:flutter/material.dart';
import 'Questions.dart';
import 'dart:async';
import 'dart:math';

class AntivirusProgram {
  // القوائم الأصلية للأسئلة
  final List<Question> trojanQuestions = [
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
    // أضف المزيد من الأسئلة حول حصان طروادة هنا
  ];

  final List<Question> wormQuestions = [
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
    // أضف المزيد من الأسئلة حول الديدان هنا
  ];

  final List<Question> spywareQuestions = [
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
    // أضف المزيد من الأسئلة حول برامج التجسس هنا
  ];

  final List<Question> generalQuestions = [
    Question(
      questionText: 'ما هو الفيروس في الكمبيوتر؟',
      options: [
        'برنامج يساعد الكمبيوتر',
        'برنامج يسبب مشاكل في الكمبيوتر',
        'لعبة على الكمبيوتر',
        'صورة في الكمبيوتر'
      ],
      correctAnswer: 'برنامج يسبب مشاكل في الكمبيوتر',
    ),
    // الأسئلة الحالية في القائمة العامة...

    // إضافة الأسئلة الجديدة هنا
    Question(
      questionText: 'ما هو الهدف من مضاد الفيروسات؟',
      options: [
        'يحسن سرعة الكمبيوتر',
        'يحمي الكمبيوتر من الفيروسات',
        'يزيد من سعة التخزين',
        'يعرض الأفلام'
      ],
      correctAnswer: 'يحمي الكمبيوتر من الفيروسات',
    ),
    Question(
      questionText:
          'ماذا تفعل عندما تتلقى رسالة بريد إلكتروني من شخص لا تعرفه؟',
      options: ['افتح الرسالة', 'قم بحذفها', 'أرسل رد', 'شاركها مع أصدقائك'],
      correctAnswer: 'قم بحذفها',
    ),
    Question(
      questionText: 'ما هي كلمة المرور القوية؟',
      options: ['1234', 'كلمة المرور', 'تحتوي على أحرف وأرقام ورموز', 'اسمك'],
      correctAnswer: 'تحتوي على أحرف وأرقام ورموز',
    ),
    Question(
      questionText: 'ماذا يعني "تحميل البرامج من مصادر موثوقة"؟',
      options: [
        'تحميل أي برنامج من الإنترنت',
        'تحميل البرامج من المواقع الرسمية',
        'تحميل البرامج من رسائل البريد الإلكتروني',
        'تحميل البرامج من روابط غير معروفة'
      ],
      correctAnswer: 'تحميل البرامج من المواقع الرسمية',
    ),
    Question(
      questionText: 'ما هو الجدار الناري (Firewall)؟',
      options: [
        'لعبة فيديو',
        'برنامج يحمي الكمبيوتر',
        'برنامج لتحرير الصور',
        'جهاز خارجي'
      ],
      correctAnswer: 'برنامج يحمي الكمبيوتر',
    ),
    Question(
      questionText: 'لماذا يجب تحديث مضاد الفيروسات بانتظام؟',
      options: [
        'ليصبح أبطأ',
        'ليكتشف فيروسات جديدة',
        'ليضيف ألعاب جديدة',
        'ليغير الألوان'
      ],
      correctAnswer: 'ليكتشف فيروسات جديدة',
    ),
    Question(
      questionText: 'ما هي البرمجيات الخبيثة (Malware)؟',
      options: [
        'ألعاب مفيدة',
        'برامج تصمم لحماية الكمبيوتر',
        'برامج تصمم لإلحاق الضرر بالكمبيوتر',
        'برامج تعليمية'
      ],
      correctAnswer: 'برامج تصمم لإلحاق الضرر بالكمبيوتر',
    ),
    Question(
      questionText: 'ماذا تفعل إذا لاحظت أن الكمبيوتر يعمل ببطء فجأة؟',
      options: [
        'تغلق الكمبيوتر فوراً',
        'تستخدم مضاد الفيروسات لفحص الكمبيوتر',
        'تشغل لعبة جديدة',
        'تشتري كمبيوتر جديد'
      ],
      correctAnswer: 'تستخدم مضاد الفيروسات لفحص الكمبيوتر',
    ),
    Question(
      questionText: 'لماذا يجب عدم مشاركة كلمة المرور مع الآخرين؟',
      options: [
        'لأنها طويلة',
        'لأنها تحتوي على أحرف كبيرة',
        'لأنها سرية وتساعد في حماية الحساب',
        'لأنها سهلة التذكر'
      ],
      correctAnswer: 'لأنها سرية وتساعد في حماية الحساب',
    ),
    Question(
      questionText: 'كيف يساعد تحديث النظام في حماية جهازك؟',
      options: [
        'يجعل الجهاز أبطأ',
        'يضيف ميزات جديدة فقط',
        'يقوم بإصلاح الثغرات الأمنية ويحمي من الفيروسات',
        'لا يفيد في الحماية'
      ],
      correctAnswer: 'يقوم بإصلاح الثغرات الأمنية ويحمي من الفيروسات',
    ),
  ];

  // القوائم القابلة للتعديل والممزوجة
  List<Question> _remainingTrojanQuestions = [];
  List<Question> _remainingWormQuestions = [];
  List<Question> _remainingSpywareQuestions = [];
  List<Question> _remainingGeneralQuestions = [];

  // المُنشئ: يهيئ القوائم الممزوجة عند إنشاء كائن من هذه الفئة
  AntivirusProgram() {
    resetQuestions();
  }

  // إعادة تهيئة القوائم الممزوجة (تستخدم عند بدء لعبة جديدة)
  void resetQuestions() {
    _remainingTrojanQuestions = List.from(trojanQuestions)..shuffle();
    _remainingWormQuestions = List.from(wormQuestions)..shuffle();
    _remainingSpywareQuestions = List.from(spywareQuestions)..shuffle();
    _remainingGeneralQuestions = List.from(generalQuestions)..shuffle();
  }

  // إرجاع سؤال بناءً على نوع الفيروس أو الفئة العامة دون تكرار
  Question getQuestionByVirusType(String virusType) {
    if (virusType == 'حصان طروادة') {
      if (_remainingTrojanQuestions.isEmpty) {
        _remainingTrojanQuestions = List.from(trojanQuestions)..shuffle();
      }
      return _remainingTrojanQuestions.removeLast();
    } else if (virusType == 'دودة') {
      if (_remainingWormQuestions.isEmpty) {
        _remainingWormQuestions = List.from(wormQuestions)..shuffle();
      }
      return _remainingWormQuestions.removeLast();
    } else if (virusType == 'فيروس تجسس') {
      if (_remainingSpywareQuestions.isEmpty) {
        _remainingSpywareQuestions = List.from(spywareQuestions)..shuffle();
      }
      return _remainingSpywareQuestions.removeLast();
    } else if (virusType == 'عام') {
      if (_remainingGeneralQuestions.isEmpty) {
        _remainingGeneralQuestions = List.from(generalQuestions)..shuffle();
      }
      return _remainingGeneralQuestions.removeLast();
    } else {
      // افتراضيًا، إذا لم يتم تحديد النوع
      if (_remainingTrojanQuestions.isEmpty) {
        _remainingTrojanQuestions = List.from(trojanQuestions)..shuffle();
      }
      return _remainingTrojanQuestions.removeLast();
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
