import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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

  // https://help.openai.com/en/articles/5247780-using-logit-bias-to-define-token-probability
  // https://platform.openai.com/tokenizer?view=bpe
  Map<String, dynamic> toJson() => {
        'temperature': 0.2,
        'logit_bias': {
          // prevent ChatKnights from saying certain things
          '25688': -100, // .aspx
          '300': -100, // as
          '1804': -100, // px
          '2628': -100, // .html
          '30089': -100, // /default
          '58290': -100, // .asp
          '13671': -100, // asp
          '16744': -100, // /P
        },
        'messages': messages,
      };
}

class MyChatPage extends StatefulWidget {
  const MyChatPage({Key? key}) : super(key: key);

  @override
  State<MyChatPage> createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  @override
  void initState() {
    super.initState();
    nextTryExample();
  }

  List<String> tryExamples = [];
  String tryExample = 'How do I join a club?';

  final List<types.TextMessage> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final _bot = const types.User(
      id: 'f3f0a4e1-9c0a-4f1a-8a4f-5e4d4c7b0f3a',
      firstName: 'ChatKnights',
      lastName: 'AI',
      imageUrl:
          "https://github.com/popoway/goknights/blob/main/assets/icon/icon-scaled-128px.png?raw=true");
  final _endpoint = FlutterConfig.get('OPENAI_API_ENDPOINT');
  final _key = FlutterConfig.get('OPENAI_API_KEY');
  final _model = FlutterConfig.get('OPENAI_API_MODEL');

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    tryExamples = [
      FlutterI18n.translate(context, "chat.try-example-1"),
      FlutterI18n.translate(context, "chat.try-example-2"),
      FlutterI18n.translate(context, "chat.try-example-3"),
      FlutterI18n.translate(context, "chat.try-example-4"),
      FlutterI18n.translate(context, "chat.try-example-5")
    ];

    return Scaffold(
      body: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          onAvatarTap: _handleAvatarTapped,
          // when user double taps on message, select the entire text of that message
          onMessageDoubleTap: _handleMessageDoubleTapped,
          textMessageOptions: const TextMessageOptions(
            onLinkPressed: _launchURL,
          ),
          dateLocale: 'en_US',
          usePreviewData: false, // disable link preview
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
                  primaryColor: Color(0xFFE71939),
                  userAvatarNameColors: [Color(0xFFE71939)])
              : const DefaultChatTheme(
                  inputBackgroundColor: CupertinoColors.white,
                  inputTextColor: CupertinoColors.darkBackgroundGray,
                  inputContainerDecoration: BoxDecoration(
                      color: CupertinoColors.white,
                      border: Border(
                          top: BorderSide(
                              color: CupertinoColors.lightBackgroundGray))),
                  primaryColor: Color(0xFFE71939),
                  userAvatarNameColors: [Color(0xFFE71939)]),
          l10n: ChatL10nEn(
            inputPlaceholder:
                FlutterI18n.translate(context, "chat.placeholder"),
          ),
          emptyState: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus(); // hide keyboard
            },
            onVerticalDragStart: (_) {
              FocusManager.instance.primaryFocus?.unfocus(); // hide keyboard
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
                  FlutterI18n.translate(context, "chat.title"),
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
                      FlutterI18n.translate(context, "chat.subtitle"),
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
                    Text(
                      '${FlutterI18n.translate(context, "chat.try-it")}:',
                      style: TextStyle(
                        color:
                            isDarkMode ? CupertinoColors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _handleSendPressed(types.PartialText(text: tryExample));
                      },
                      child: Text(
                        tryExample,
                        style: const TextStyle(
                          color: Color(0xFFE71939),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                // if devide height is less than 600, make a smaller sized box
                MediaQuery.of(context).size.height < 760
                    ? const SizedBox(height: 70)
                    : const SizedBox(height: 140),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        FlutterI18n.translate(context, "chat.disclaimer"),
                        style: const TextStyle(
                          color: CupertinoColors.inactiveGray,
                          fontSize: 13,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _launchURL(
                              'https://github.com/popoway/goknights/wiki/Introducing-ChatKnights');
                        },
                        child: Text(
                          FlutterI18n.translate(context, "button.learn-more"),
                          style: const TextStyle(
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
            "https://$_endpoint/openai/deployments/$_model/chat/completions?api-version=2023-12-01-preview"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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
    // if message == "demo", show a demo message
    if (message.text == "demo") {
      var textMessage = types.TextMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: "Where is the tutoring center?",
        showStatus: true,
        status: types.Status.sent,
      );
      var textMessage2 = types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text:
            "The Learning Commons, which includes the Academic Support Center and Tutoring, is located in Kiely Hall 131. You can find more information about their services at https://www.qc.cuny.edu/academics/qclc/.",
      );
      var textMessage3 = types.TextMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: "I need to swap a class.",
        showStatus: true,
        status: types.Status.sent,
      );
      var textMessage4 = types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text:
            "You can swap a class using the CUNYfirst Schedule Builder at https://sb.cunyfirst.cuny.edu/. If you need help with CUNYfirst, you can contact the ITS Tech Helpdesk at Kiely Hall 226 or visit their website at https://support.qc.cuny.edu/.",
      );
      _addMessage(textMessage);
      _addMessage(textMessage2);
      _addMessage(textMessage3);
      _addMessage(textMessage4);
      return;
    }
    // if the message is too short, tell the user to type more
    else if (message.text.length < 7) {
      var textMessage = types.TextMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: message.text,
        showStatus: false,
      );
      var textMessage2 = types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: FlutterI18n.translate(context, "chat.too-short"),
      );
      _addMessage(textMessage);
      _addMessage(textMessage2);
      return;
    }

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
      print(utf8.decode(response.bodyBytes));
      var responseJSON = jsonDecode(utf8.decode(response.bodyBytes));
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

  void _handleAvatarTapped(types.User user) {
    print('Avatar tapped: ${user.firstName} ${user.lastName}');
    _showAlertDialog(context);
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: const Text('Remove all messages?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              // remove all messages
              setState(() {
                _messages.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
        insetAnimationDuration: const Duration(milliseconds: 50),
      ),
    );
  }

  void _handleMessageDoubleTapped(
      BuildContext context, types.Message msg) async {
    // cast msg to TextMessage
    types.TextMessage textMessage = msg as types.TextMessage;
    Clipboard.setData(ClipboardData(text: textMessage.text));
    // add a new message to the chat
    var textMessage2Id = randomString();
    var textMessage2 = types.TextMessage(
        id: textMessage2Id, text: 'Message copied!', author: _bot);
    _addMessage(textMessage2);
    // remove the message
    Future.delayed(const Duration(milliseconds: 1000), () async {
      setState(() {
        _messages.removeWhere((element) => element.id == textMessage2Id);
      });
    });
  }

  void nextTryExample() {
    Future.delayed(const Duration(milliseconds: 4000), () async {
      // randomly select a new try example
      var rng = new Random();
      var newTryExample = tryExample;
      do {
        newTryExample = tryExamples[rng.nextInt(tryExamples.length)];
      } while (newTryExample == tryExample);
      setState(() {
        tryExample = newTryExample;
      });
      nextTryExample(); // repeat
    });
  }
}

_launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $url');
  }
}
