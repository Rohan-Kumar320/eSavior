import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  Uri dialnumber = Uri(scheme: 'tel', path: '03000347158');

  callNumber() async {
    if (!kIsWeb) {
      if (await canLaunchUrl(dialnumber)) {
        await launchUrl(dialnumber);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch dialer')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Calling is not supported on the web.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Call Screen',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  callNumber();
                },
                icon: Icon(
                  Icons.call,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }
}