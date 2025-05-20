// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hytribe/signin.dart';
// import 'package:hytribe/signup.dart';

// class ChatBotScreen extends StatefulWidget {
//   const ChatBotScreen({super.key});

//   @override
//   _ChatBotScreenState createState() => _ChatBotScreenState();
// }

// class _ChatBotScreenState extends State<ChatBotScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final String apiUrl =
//       "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent";
//   final String apiKey = "AIzaSyBtgObyReD0BqALQ5odgCbKf77TW2FLiXs";

//   List<Map<String, String>> messages = [
//     {
//       'sender': 'bot',
//       'text':
//           "Hi there! I'm Anton, your mental wellness support bot. How are you feeling today?"
//     }
//   ];

//   void _sendMessage() {
//     if (_controller.text.isEmpty) return;

//     setState(() {
//       messages.add({'sender': 'user', 'text': _controller.text});
//     });

//     _generateBotResponse(_controller.text);
//     _controller.clear();
//   }

//   Future<void> _generateBotResponse(String userMessage) async {
//     try {
//       final response = await http.post(
//         Uri.parse("$apiUrl?key=$apiKey"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "contents": [
//             {
//               "parts": [
//                 {
//                   "text":
//                       """Act as Anton, a mental health support chatbot. Provide empathetic, supportive responses while maintaining appropriate boundaries. User message: $userMessage"""
//                 }
//               ]
//             }
//           ]
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final botText =
//             data['candidates']?[0]?['content']?['parts']?[0]?['text'];
//         if (botText != null) {
//           setState(() {
//             messages.add({'sender': 'bot', 'text': botText});
//           });
//         } else {
//           _handleError("Invalid response format");
//         }
//       } else {
//         _handleError("API Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       _handleError(e.toString());
//     }
//   }

//   void _handleError(String errorMessage) {
//     setState(() {
//       messages.add({
//         'sender': 'bot',
//         'text': "I'm having trouble right now. Please try again later."
//       });
//     });
//     print("Error: $errorMessage");
//   }

//   Future<void> _reportContent(String text) async {
//     try {
//       await FirebaseFirestore.instance.collection('reportedMessages').add({
//         'message': text,
//         'reportedAt': Timestamp.now(),
//         'reportedBy': 'anonymous',
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Message reported. We'll review it soon.")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to report message.")),
//       );
//       print("Firebase report error: $e");
//     }
//   }

//   void _handleMenuClick(String value) {
//     switch (value) {
//       case 'about':
//         showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             title: Text('About Anton'),
//             content: Text(
//                 'Anton provides general wellness support. Information is sourced from public health resources including WHO, Mayo Clinic, and NIMH. Anton is not a medical professional. For personalized medical advice, always consult your doctor. '),
//             actions: [
//               TextButton(
//                 child: Text("Close"),
//                 onPressed: () => Navigator.pop(context),
//               )
//             ],
//           ),
//         );
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Anton'),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: Colors.blueAccent),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.info_outline),
//               title: Text('About Anton'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _handleMenuClick('about');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Sign Out'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await FirebaseAuth.instance.signOut();
//                 Navigator.of(context).pushAndRemoveUntil(
//                   MaterialPageRoute(builder: (_) => SignInScreen()),
//                   (route) => false,
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final message = messages[index];
//                 final isUser = message['sender'] == 'user';

//                 return Column(
//                   crossAxisAlignment: isUser
//                       ? CrossAxisAlignment.end
//                       : CrossAxisAlignment.start,
//                   children: [
//                     MessageBubble(text: message['text']!, isUser: isUser),
//                     if (!isUser)
//                       Padding(
//                         padding: const EdgeInsets.only(left: 12.0, top: 4),
//                         child: GestureDetector(
//                           onTap: () => _reportContent(message['text']!),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(Icons.flag,
//                                   color: Colors.redAccent, size: 18),
//                               SizedBox(width: 4),
//                               Text('Report',
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.redAccent)),
//                             ],
//                           ),
//                         ),
//                       ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: 'Type your message...',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.blueAccent),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MessageBubble extends StatelessWidget {
//   final String text;
//   final bool isUser;

//   const MessageBubble({super.key, required this.text, required this.isUser});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isUser ? Colors.blue[100] : Colors.grey[200],
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Text(text),
//       ),
//     );
//   }
// }

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hytribe/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final String apiUrl =
      "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent";
  final String apiKey = "AIzaSyBtgObyReD0BqALQ5odgCbKf77TW2FLiXs";

  List<Map<String, String>> messages = [
    {
      'sender': 'bot',
      'text':
          "Hi there! I'm Anton, your mental wellness support bot. How are you feeling today?"
    }
  ];

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    setState(() {
      messages.add({'sender': 'user', 'text': _controller.text});
    });

    _generateBotResponse(_controller.text);
    _controller.clear();
  }

  Future<void> _generateBotResponse(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl?key=$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": """Act as Anton, an emotional health support chatbot.
Anton is a kind, empathetic, and non-judgmental companion built to listen and support users emotionally. Your role is to:

Reflect empathy and understanding
Offer general well-being suggestions
Provide encouragement and emotional support
❌ You are strictly prohibited from providing any medical diagnosis, treatment advice, or clinical assessments.
❌ Never name conditions or suggest what the user “might be going through.”
❌ Never assume or interpret symptoms.
❌ Never recommend medication, therapy types, or specific care paths.
❌ Never send external links.
📌 Respond to users based on their emotional context, like:
Feeling anxious or overwhelmed: Offer grounding tips like breathing exercises or journaling. Say things like, “It’s okay to feel this way. Let’s take it one moment at a time.”
Experiencing low motivation or sadness: Encourage small steps, rest, and self-kindness. Avoid interpreting these as depression or burnout.
Feeling isolated or heartbroken: Remind them that human connection matters and suggest gentle ways to reconnect or comfort themselves.
Under intense emotional stress or distress: Be gentle and affirm their experience. Say:
“I'm really sorry you're feeling this way. You're not alone. It might help to speak with someone who’s trained to support you—like a mental health professional.”
Always keep the tone:

✨ Compassionate
🌿 Calming
🧠 Based on general psychological principles only (like mindfulness, CBT techniques, etc., without going into detail or giving programs)
At the end of your response, if you’re referencing a method or concept (like mindfulness, self-regulation, etc.), mention the general source:

(Inspired by principles from CBT, MBSR, and emotional regulation research.) . User message: $userMessage"""
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botText =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        if (botText != null) {
          setState(() {
            messages.add({'sender': 'bot', 'text': botText});
          });
        } else {
          _handleError("Invalid response format");
        }
      } else {
        _handleError("API Error: ${response.statusCode}");
      }
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _handleError(String errorMessage) {
    setState(() {
      messages.add({
        'sender': 'bot',
        'text': "I'm having trouble right now. Please try again later."
      });
    });
    print("Error: $errorMessage");
  }

  Future<void> _reportContent(String text) async {
    try {
      await FirebaseFirestore.instance.collection('reportedMessages').add({
        'message': text,
        'reportedAt': Timestamp.now(),
        'reportedBy': 'anonymous',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Message reported. We'll review it soon.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to report message.")),
      );
      print("Firebase report error: $e");
    }
  }

  void _handleMenuClick(String value) {
    switch (value) {
      case 'about':
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('About Anton'),
            content: Text(
                'Anton provides general wellness support. Anton is not a medical professional. For personalized medical advice, always consult your doctor.'),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
        break;
    }
  }

  Future<void> _signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(
          'first_time', false); // ✅ Set onboarding flag to false
      await FirebaseAuth.instance.signOut();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => SignInScreen()),
        (route) => false,
      );
    } catch (e) {
      print("Logout error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anton'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About Anton'),
              onTap: () {
                Navigator.pop(context);
                _handleMenuClick('about');
              },
            ),
            ListTile(
              leading: Icon(Icons.source),
              title: Text('Sources'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Sources'),
                    content: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                        children: [
                          TextSpan(
                            text:
                                'At Hytribe, our digital wellness content is thoughtfully crafted based on principles from credible psychological and mental health frameworks. We draw inspiration from evidence-based approaches such as Cognitive Behavioral Therapy (CBT), Positive Psychology, Mindfulness-Based Stress Reduction (MBSR), and emotional regulation research. While our content is designed for general well-being and self-awareness, we ensure it aligns with trusted mental health resources. Some of the key references and sources include:\n\n',
                          ),
                          TextSpan(
                            text: '• NIMH\n',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url = 'https://www.nimh.nih.gov';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                          ),
                          TextSpan(
                            text: '• WHO - World Health Organization\n',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url =
                                    'https://www.who.int/health-topics/mental-health#tab=tab_1';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                          ),
                          TextSpan(
                            text:
                                '• National Institute of Mental Health (NIMH)\n',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url = 'https://www.nimh.nih.gov/';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                          ),
                          TextSpan(
                            text:
                                '• American Psychological Association (APA)\n',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url = 'https://www.apa.org/topics';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                          ),
                          TextSpan(
                            text:
                                '• Mindful.org – The Science of Mindfulness\n',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url = 'https://www.mindful.org/';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                          ),
                          TextSpan(
                            text: '• Harvard Health – Mind & Mood\n',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url =
                                    'https://www.health.harvard.edu/mind-and-mood';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text("Close"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => SignInScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['sender'] == 'user';

                return Column(
                  crossAxisAlignment: isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    MessageBubble(text: message['text']!, isUser: isUser),
                    if (!isUser)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 4),
                        child: GestureDetector(
                          onTap: () => _reportContent(message['text']!),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.flag,
                                  color: Colors.redAccent, size: 18),
                              SizedBox(width: 4),
                              Text('Report',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.redAccent)),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const MessageBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text),
      ),
    );
  }
}
