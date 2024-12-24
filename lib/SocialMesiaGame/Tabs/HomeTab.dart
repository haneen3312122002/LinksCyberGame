import 'package:flutter/material.dart';
import 'package:cybergame/SocialMesiaGame/Pages/Msgs.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/ActivityTab.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/ProfileTab.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/SearchTab.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/UploadTab.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/ActivityTile.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/FeedPost.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/Stories.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeTab extends StatelessWidget {
  Map<String, String> personalInfo;
  HomeTab({required this.personalInfo});

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // You can use the image file (e.g., display it or upload it)
      print('Picked image path: ${image.path}');
    } else {
      // Handle the case where the user cancels the picker
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        title: Container(
          width: MediaQuery.of(context).size.width / 2.3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: Icon(
                  FontAwesomeIcons.camera,
                  color: Colors.black,
                  size: 30.0,
                ),
              ),
              SizedBox(width: 30.0),
              Text(
                'CYBRT GAME',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Billabong',
                  fontSize: 30.0,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MessagesPage()),
                );
              },
              child: Icon(
                FontAwesomeIcons.paperPlane,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StoriesWidget(),
            FeedPost(
              personalInfo: personalInfo,
              username: 'assm11',
              likes: 120,
              time: '2 ساعات',
              profilePicture: 'assets/profile1.png',
              image: 'assets/post1.png',
              text: 'انظروا لهذا الشخص، انه معاق ولا يفقه شيئا ',
              comments: [
                Comment(
                  username: 'sara_99',
                  profilePicture: 'assets/profile2.png',
                  content: 'هذا الشخص غبي ومعاق',
                ),
                Comment(
                  username: 'batool_q',
                  profilePicture: 'assets/profile3.png',
                  content:
                      'هذا غير لائق ، لا يجب عليك نشر هذه المنشورات التي تؤذي المشاعر💚',
                ),
              ],
            ),
            FeedPost(
              personalInfo: personalInfo,
              username: '__jhaneen__', // من الرسائل الموجودة
              likes: 156,
              time: '6 hours',
              profilePicture: 'assets/jeremy.jpg',
              image: 'assets/story2.jpg',
              text:
                  "هذا الحساب لا يقدم أي محتوى مثير للاهتمام. لماذا يتابعه أي شخص؟ يبدو كأنه لا يعرف كيف يستخدم الإنترنت بشكل صحيح. 😒",
              comments: [
                Comment(
                  username: 'keen_ammar',
                  profilePicture: 'assets/profile2.png',
                  content:
                      'انت تنشر الاشاعات دون ان تشاهد مقاطع الفيديو الخاصة به',
                ),
                Comment(
                  username: 'ranakh',
                  profilePicture: 'assets/profile3.png',
                  content:
                      'نعم معك حق ربما لان اسلوب تصويره سيء / لو عدل اسلوب التصوير سيصبح محتواه افضل ',
                ),
              ],
            ),
            FeedPost(
              personalInfo: personalInfo,
              username: 'adelle', // من الرسائل الموجودة
              likes: 56,
              time: '2 days',
              profilePicture: 'assets/adelle.jpg',
              image: 'assets/story3.jpg',
              text:
                  "أحببت هذا المكان الذي زرته اليوم مع عائلتي! الطبيعة مذهلة، وأعتقد أن الجميع يجب أن يقضي وقتًا أقل على الإنترنت وأكثر مع الطبيعة. 💚🌳",
              comments: [
                Comment(
                  username: 'sami_2002',
                  profilePicture: 'assets/profile2.png',
                  content: 'تصويرك مقرف ، اعتزل المنصة ارجوووك',
                ),
                Comment(
                  username: 'ibrahim_al',
                  profilePicture: 'assets/profile3.png',
                  content: 'رائع لكن عدل الاضاءة في المرة القادمة',
                ),
              ],
            ),
            FeedPost(
              personalInfo: personalInfo,
              username: 'amalnader', // من الرسائل الموجودة
              likes: 224,
              time: '1 week',
              profilePicture: 'assets/chris.jpg',
              image: 'assets/story4.jpg',
              text:
                  "هل شاهدتم منشور هذا الشخص؟ إنه دائمًا ينشر أشياء غبية! لماذا لا يتوقف عن استخدام الإنترنت؟ 🤦‍♂️",
              comments: [
                Comment(
                  username: 'sami_2002',
                  profilePicture: 'assets/profile2.png',
                  content: 'انت الغبي/ اترك الناس وشانها ، انظر الى نفسك اولا',
                ),
              ],
            ),
            FeedPost(
              personalInfo: personalInfo,
              username: 'dana_p_0', // من الرسائل الموجودة
              likes: 112,
              time: '2 weeks',
              profilePicture: 'assets/dan.jpg',
              image: 'assets/story8.jpg',
              text:
                  "أنا ممتن جدًا لدعمكم المستمر لي! ❤️ أعدكم أن أشارك محتوى إيجابيًا ومفيدًا دائمًا. لا تنسوا أن تكونوا لطفاء مع الجميع. 🌈",
              comments: [
                Comment(
                  username: 'sami_2002',
                  profilePicture: 'assets/profile2.png',
                  content: 'تصويرك مقرف ، اعتزل المنصة ارجوووك',
                ),
                Comment(
                  username: 'ibrahim_al',
                  profilePicture: 'assets/profile3.png',
                  content: 'استمر',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
