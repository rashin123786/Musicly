import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicly/screens/settings/privacy_policy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:musicly/screens/settings/terms_condition.dart';

import '../../widgets/styles.dart';
import 'about_us.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        title: Text(
          'Settings',
          style: AppStyles().myMusicStyleHead,
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Card(
            elevation: 5,
            shadowColor: const Color.fromARGB(255, 98, 255, 103),
            color: const Color.fromARGB(255, 27, 28, 27),
            child: Column(
              children: [
                ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Privacy(),
                      )),
                  leading: const Icon(
                    Icons.privacy_tip,
                    color: Colors.green,
                  ),
                  title: Text(
                    'Privacy Policy',
                    style: SettingStyles().mySettingStyle,
                  ),
                ),
                ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Terms(),
                      )),
                  leading: const Icon(
                    Icons.list_alt,
                    color: Colors.green,
                  ),
                  title: Text(
                    'Terms & Condition',
                    style: SettingStyles().mySettingStyle,
                  ),
                ),
                ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutUs(),
                      )),
                  leading: const Icon(
                    Icons.account_box_outlined,
                    color: Colors.green,
                  ),
                  title: Text(
                    'About',
                    style: SettingStyles().mySettingStyle,
                  ),
                ),
                const SizedBox(
                  width: 100,
                  height: 270,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          launchUrl(Uri.parse(
                              'https://instagram.com/rashieey.__?igshid=ZDdkNTZiNTM='));
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.instagram,
                          color: Colors.green,
                        )),
                    IconButton(
                        onPressed: () {
                          launchUrl(
                              Uri.parse('https://github.com/rashin123786'));
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.github,
                          color: Colors.green,
                        )),
                    IconButton(
                        onPressed: () {
                          launchUrl(Uri.parse(
                              'https://www.linkedin.com/in/rashin-k-50b2681a7/'));
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.linkedin,
                          color: Colors.green,
                        )),
                  ],
                ),
                const SizedBox(
                  width: 100,
                  height: 30,
                ),
                const Text(
                  'V 1.0',
                  style: TextStyle(color: Color.fromARGB(255, 187, 254, 209)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
