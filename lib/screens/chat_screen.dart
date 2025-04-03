import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/chat_message.dart';
import '../services/api_service.dart';
import '../services/preferences_service.dart';
import 'settings_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _preferencesService = PreferencesService();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  
  ApiService? _apiService;
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isSettingsConfigured = false;
  
  @override
  void initState() {
    super.initState();
    _checkSettings();
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  Future<void> _checkSettings() async {
    final apiKey = await _preferencesService.getApiKey();
    final provider = await _preferencesService.getProvider();
    final model = await _preferencesService.getModel();
    
    if (apiKey != null && provider != null && model != null) {
      _apiService = ApiService(
        apiKey: apiKey,
        provider: provider,
        model: model,
      );
      
      setState(() {
        _isSettingsConfigured = true;
      });
    } else {
      _navigateToSettings();
    }
  }
  
  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          onSettingsSaved: () {
            Navigator.pop(context);
            _checkSettings();
          },
        ),
      ),
    );
  }
  
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    
    final userMessage = ChatMessage(
      text: _messageController.text,
      isUser: true,
    );
    
    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
      _messageController.clear();
    });
    
    _scrollToBottom();
    
    try {
      final response = await _apiService!.sendMessage(userMessage.text);
      
      final aiMessage = ChatMessage(
        text: response,
        isUser: false,
      );
      
      setState(() {
        _messages.add(aiMessage);
        _isLoading = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.add(ChatMessage(
          text: 'Error: ${e.toString()}',
          isUser: false,
        ));
      });
      
      _scrollToBottom();
    }
  }
  
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI ChatBot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: !_isSettingsConfigured
          ? const Center(
              child: Text(
                'Please configure your settings first',
                style: TextStyle(fontSize: 16),
              ),
            )
          : Column(
              children: [
                // Chat messages
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
                ),
                
                // Loading indicator
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: SpinKitThreeBounce(
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                
                // Message input
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type your message...',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
  
  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: message.isUser
            ? Text(
                message.text,
                style: const TextStyle(color: Colors.white),
              )
            : MarkdownBody(
                data: message.text,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(color: Colors.black),
                  code: TextStyle(
                    backgroundColor: Colors.grey.shade300,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
      ),
    );
  }
}
