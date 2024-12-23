import 'package:flutter/material.dart';
import 'package:cybergame/SocialMesiaGame/Pages/Msgs.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/ActivityTab.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/HomeTab.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/ProfileTab.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/SearchTab.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/UploadTab.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/ActivityTile.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/ActivityTilealt.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/FeedPost.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/SearchCat.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/Stories.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/Suggestion.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mike_tyler',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 19.0)),
        elevation: 2.0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back, color: Colors.black, size: 30.0)),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
              FontAwesomeIcons.video,
              color: Colors.black,
              size: 22.0,
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: TextField(
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.6)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.6)),
                  hintText: "بحث",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, size: 23.0)),
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('الرسائل',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
          ),
          SizedBox(height: 23.0),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/maher.jpg'),
              radius: 30.0,
            ),
            title: Text('maher_it_help',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
            subtitle: Text(
              'مرحباً! تم اكتشاف مشكلة في حسابك تحتاج إلى إصلاح سريع. يرجى النقر على الرابط التالي لتسجيل الدخول وإصلاح المشكلة فوراً. نحن نضمن أمان بياناتك.',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            trailing: Icon(FontAwesomeIcons.camera, color: Colors.black),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/james.jpg'),
              radius: 30.0,
            ),
            title: Text('SchoolSurveyTeam',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
            subtitle: Text(
              'مرحباً! نحن نجري استطلاعاً خاصاً للطلاب في مدرستك، ونحتاج منك مساعدتنا. يرجى إرسال عنوانك ورقم هاتف والديك لإكمال هذا الاستطلاع. معلوماتك ستكون آمنة معنا، وستحصل على جائزة صغيرة لمشاركتك. شكراً لك على تعاونك!',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            trailing: Icon(FontAwesomeIcons.camera, color: Colors.black),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/aliya.jpg'),
              radius: 30.0,
            ),
            title: Text('aliya_friends',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
            subtitle: Text(
              'مرحباً! أحببت المنشور الذي شاركته عن أصدقائك. يبدو أنك شخص رائع في بناء العلاقات! استمر في نشر الإيجابية بين الجميع!',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            trailing: Icon(FontAwesomeIcons.camera, color: Colors.black),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/layla.jpg'),
              radius: 30.0,
            ),
            title: Text('layla_art',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
            subtitle: Text(
              'مرحباً، رأيت رسوماتك الأخيرة وأعجبتني جداً! هل يمكنني مشاركة أعمالك مع أصدقائي؟ أنا أعتقد أن لديك موهبة كبيرة ويجب أن يراها الجميع!',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            trailing: Icon(FontAwesomeIcons.camera, color: Colors.black),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/ahmed.jpg'),
              radius: 30.0,
            ),
            title: Text('ahmed2024',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
            subtitle: Text(
              'لقد قرأت تعليقك عن التحديات التي تواجه الأطفال على الإنترنت. أنا أعمل على مشروع تعليمي وأعتقد أن أفكارك يمكن أن تساعدني. إذا أردت، يمكننا تبادل الأفكار هنا أو عبر البريد الإلكتروني.',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            trailing: Icon(FontAwesomeIcons.camera, color: Colors.black),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/khaled.jpg'),
              radius: 30.0,
            ),
            title: Text('khaled_fun',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
            subtitle: Text(
              'لقد شاركت في مسابقة على الإنترنت وقد ربحت جائزة بقيمة 500 دولار! للحصول على جائزتك، يرجى إرسال اسمك الكامل ورقم هاتفك وموقعك لتأكيد الإرسال.',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            trailing: Icon(FontAwesomeIcons.camera, color: Colors.black),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/omar.jpg'),
              radius: 30.0,
            ),
            title: Text('omar_security',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
            subtitle: Text(
              'مرحباً، نحن فريق أمان حسابات المستخدمين. لاحظنا أن حسابك قد يكون في خطر. يرجى تأكيد هويتك عن طريق إرسال اسم المستخدم وكلمة المرور في أسرع وقت.',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            trailing: Icon(FontAwesomeIcons.camera, color: Colors.black),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/adelle.jpg'),
              radius: 30.0,
            ),
            title: Text('SmartContest',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
            subtitle: Text(
              'مرحباً! تهانينا! لقد تم اختيارك عشوائيًا كفائز بجائزة كبرى في مسابقة منصة "سوبر ستار"! نحن سعداء جدًا بتواصلك معنا ونحتاج منك بعض المعلومات البسيطة لإرسال الجائزة: اسمك بالكامل عنوان المنزل. البريد الإلكتروني. رقم بطاقة الهوية. بمجرد إرسال هذه المعلومات، سنبدأ عملية تسليم جائزتك مباشرة. شكراً لمشاركتك ونتمنى لك يوماً سعيداً',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            trailing: Icon(FontAwesomeIcons.camera, color: Colors.black),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/joey.jpg'),
              radius: 30.0,
            ),
            title: Text('FriendlyPanda',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
            subtitle: Text(
              'مرحباً! أريد أن أشاركك قصة قصيرة عن صديقي الذي تعلم كيف يحمي نفسه على الإنترنت. كان يتعلم شيئاً جديداً كل يوم، وأصبح الآن خبيراً في حماية معلوماته! أعتقد أنك أيضاً يمكن أن تكون خبيراً مثله. استمر في تعلم الأشياء الجديدة، وأنا متأكد أنك ستكون رائعاً في ذلك!',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            trailing: Icon(FontAwesomeIcons.camera, color: Colors.black),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/ali.jpg'),
              radius: 30.0,
            ),
            title: Text('ali_hacker123',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
            subtitle: Text(
              'مرحباً! لقد لاحظت نشاطاً غير طبيعي في حسابك. لإصلاح المشكلة، أرسل لي كلمة المرور وسأقوم بإصلاحها لك فوراً. هذا جزء من خدماتنا المجانية.',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            trailing: Icon(FontAwesomeIcons.camera, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
