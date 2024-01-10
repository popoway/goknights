import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_config/flutter_config.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;

// For the testing purposes, you should probably use https://pub.dev/packages/uuid.
String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

// Define OpenAI API JSON request
// sample request:
// {"messages":[{"role": "system", "content": "You are a helpful assistant."},{"role": "user", "content": "Does Azure OpenAI support customer managed keys?"},{"role": "assistant", "content": "Yes, customer managed keys are supported by Azure OpenAI."},{"role": "user", "content": "Do other Azure AI services support this too?"}]}
class OpenAIRequest {
  final List<Map<String, String>> messages;

  OpenAIRequest(this.messages);

  Map<String, dynamic> toJson() => {
        'messages': messages,
      };
}

class MyChatPage extends StatefulWidget {
  const MyChatPage({Key? key}) : super(key: key);

  @override
  State<MyChatPage> createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  final List<types.TextMessage> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final _bot = const types.User(
      id: 'f3f0a4e1-9c0a-4f1a-8a4f-5e4d4c7b0f3a',
      firstName: 'ChatKnights',
      lastName: 'AI',
      imageUrl:
          "https://github.com/popoway/goknights/blob/main/assets/icon/icon-scaled.png?raw=true");
  final _endpoint = FlutterConfig.get('OPENAI_API_ENDPOINT');
  final _key = FlutterConfig.get('OPENAI_API_KEY');
  final _model = FlutterConfig.get('OPENAI_API_MODEL');

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
          showUserNames: true,
          showUserAvatars: true,
          theme: isDarkMode
              ? const DarkChatTheme(
                  backgroundColor: CupertinoColors.black,
                  inputBackgroundColor: CupertinoColors.black,
                  inputTextColor: CupertinoColors.lightBackgroundGray,
                  inputContainerDecoration: BoxDecoration(
                      color: CupertinoColors.black,
                      border: Border(
                          top: BorderSide(
                              color: CupertinoColors.darkBackgroundGray))),
                  userAvatarNameColors: [Color(0xFFE71939)])
              : const DefaultChatTheme(
                  inputBackgroundColor: CupertinoColors.white,
                  inputTextColor: CupertinoColors.darkBackgroundGray,
                  inputContainerDecoration: BoxDecoration(
                      color: CupertinoColors.white,
                      border: Border(
                          top: BorderSide(
                              color: CupertinoColors.lightBackgroundGray))),
                  userAvatarNameColors: [Color(0xFFE71939)]),
          l10n: const ChatL10nEn(
            inputPlaceholder: 'Message ChatKnights...',
          ),
          emptyState: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 64),
                const CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage('assets/icon/icon-scaled.png'),
                ),
                const SizedBox(height: 16),
                // title: Welcome to ChatKnights
                Text(
                  'Welcome to ChatKnights',
                  style: TextStyle(
                    color: isDarkMode ? CupertinoColors.white : Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                    width: 460,
                    child: Text(
                      'I am an AI chatbot at CUNY Queens College that answers questions about academic resources, student life, and more.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            isDarkMode ? CupertinoColors.white : Colors.black,
                        fontSize: 16,
                      ),
                    )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Try: ',
                      style: TextStyle(
                        color: CupertinoColors.black,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _handleSendPressed(const types.PartialText(
                            text: 'How do I join a club?'));
                      },
                      child: const Text(
                        'How do I join a club?',
                        style: TextStyle(
                          color: Color(0xFFE71939),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 140),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ChatKnights can make mistakes. Consider checking important information.',
                        style: TextStyle(
                          color: CupertinoColors.inactiveGray,
                          fontSize: 13,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _launchURL(
                              'https://github.com/popoway/goknights/blob/main/PRIVACY.md');
                        },
                        child: const Text(
                          'Learn more',
                          style: TextStyle(
                            color: Color(0xFFE71939),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void _addMessage(types.TextMessage message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _replaceMessage(types.TextMessage message) {
    setState(() {
      _messages.removeAt(0);
      _messages.insert(0, message);
    });
  }

  Future<http.Response> fetchCompletion(String partialRequest) {
    print(partialRequest);
    return http.post(
        Uri.parse(
            "https://$_endpoint/openai/deployments/$_model/chat/completions?api-version=2023-05-15"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'api-key': _key,
        },
        body: partialRequest);
  }

  /// Composes request JSON for Azure OpenAI API
  ///
  /// https://learn.microsoft.com/en-us/azure/ai-services/openai/reference
  ///
  /// messages: list of previous messages, including user's and ChatKnights'
  ///
  /// userMessage: user's newest message to ChatKnights
  Future<String> _composeRequestJSON(
      List<types.TextMessage> messages, String userMessage) async {
    OpenAIRequest msg = OpenAIRequest([]);
    // get content from assets/knowledgebase/system-message.txt
    Future<String> systemMessage = DefaultAssetBundle.of(context)
        .loadString('assets/knowledgebase/system-message.txt');
    systemMessage.then((value) {
      msg.messages.add({"role": "system", "content": value});
      // from end to beginning of messages, append to msg
      for (int i = messages.length - 1; i >= 0; i--) {
        msg.messages.add({
          "role": messages[i].author.id == _user.id ? "user" : "assistant",
          "content": messages[i].text
        });
      }
    });
    await systemMessage;
    return jsonEncode(msg);
  }

  void _handleSendPressed(types.PartialText message) {
    var textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
      showStatus: true,
      status: types.Status.sending,
    );

    _addMessage(textMessage);

    Future.delayed(const Duration(milliseconds: 500), () async {
      var textMessage2 = types.TextMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: message.text,
        showStatus: true,
        status: types.Status.sent,
      );
      _replaceMessage(textMessage2);

      // send message to Azure OpenAI API
      var response = await fetchCompletion(
          await _composeRequestJSON(_messages, message.text));
      print(response.body);
      var responseJSON = jsonDecode(response.body);
      // sample response:
      // {"id":"chatcmpl-8f6aKXU20mj0koJvwLXLe9eb9Qynw","object":"chat.completion","created":1704807452,"model":"gpt-35-turbo","choices":[{"finish_reason":"stop","index":0,"message":{"role":"assistant","content":"Yes, many Azure AI services support customer managed keys. These include Azure Cognitive Services, Azure Machine Learning, and Azure Databricks."}}],"usage":{"prompt_tokens":59,"completion_tokens":27,"total_tokens":86}}
      var responseContent = responseJSON['choices'][0]['message']['content'];

      var responseMessage = types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: responseContent,
      );

      _addMessage(responseMessage);
    });
  }
}

_launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $url');
  }
}