import 'package:flutter/material.dart';
import 'package:planer/ui/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(50.0),
              child: Image.network(
                "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/illustrations%2Fundraw_Designer_re_5v95%201.png?alt=media&token=5d053bd8-d0ea-4635-abb6-52d87539b7ec",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 16.0),
              child: const Text(
                'Thank you for using my app!\n\n'
                'This is a simple app that I made to learn Flutter.\n\n'
                'I hope you like it!\n\n'
                'If you like it, you can buy me a coffee!\n\n',
                style: TextStyle(
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: _launchURLBrowser,
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width * 0.9,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                  ),
                  color: Themes.primaryClr,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'Buy me a coffee',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchURLBrowser() async {
    final Uri url = Uri.parse('https://www.buymeacoffee.com/bukharneyK');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
