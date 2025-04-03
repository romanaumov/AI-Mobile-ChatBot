import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class ApiService {
  final String apiKey;
  final String provider;
  final String model;

  ApiService({
    required this.apiKey,
    required this.provider,
    required this.model,
  });

  Future<String> sendMessage(String message) async {
    if (provider == 'OpenAI') {
      return await _sendOpenAIMessage(message);
    } else if (provider == 'Anthropic') {
      return await _sendAnthropicMessage(message);
    } else {
      throw Exception('Unsupported provider: $provider');
    }
  }

  Future<String> _sendOpenAIMessage(String message) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    
    final body = jsonEncode({
      'model': model,
      'messages': [
        {'role': 'user', 'content': message}
      ],
      'temperature': 0.7,
    });
    
    try {
      final response = await http.post(url, headers: headers, body: body);
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to get response: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error communicating with OpenAI: $e');
    }
  }

  Future<String> _sendAnthropicMessage(String message) async {
    final url = Uri.parse('https://api.anthropic.com/v1/messages');
    
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
      'anthropic-version': '2023-06-01',
    };
    
    final body = jsonEncode({
      'model': model,
      'messages': [
        {'role': 'user', 'content': message}
      ],
      'max_tokens': 1000,
      'temperature': 0.7,
    });
    
    try {
      final response = await http.post(url, headers: headers, body: body);
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['content'][0]['text'];
      } else {
        throw Exception('Failed to get response: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error communicating with Anthropic: $e');
    }
  }
}
