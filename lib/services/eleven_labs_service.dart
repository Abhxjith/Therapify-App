import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ElevenLabsService {
  static const String _apiKey = 'sk_95c3f36fb251a59b80e9de116eb0b7ce915e43c9b4a7dc0f';
  static const String _baseUrl = 'https://api.elevenlabs.io/v1';
  
  // Using Emily (legacy) voice - known for warm, natural, and empathetic qualities
  static const String _defaultVoiceId = '21m00Tcm4TlvDq8ikWAM'; // Emily (legacy) voice ID
  
  final Dio _dio;
  
  ElevenLabsService() : _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    headers: {
      'xi-api-key': _apiKey,
      'Content-Type': 'application/json',
    },
  ));
  
  Future<String> textToSpeech(String text) async {
    try {
      final response = await _dio.post(
        '/text-to-speech/$_defaultVoiceId',
        data: {
          'text': text,
          'model_id': 'eleven_monolingual_v1',
          'voice_settings': {
            'stability': 0.75,        // Lower stability for faster generation
            'similarity_boost': 0.75, // Lower similarity for faster generation
            'style': 0.35,           // Lower style for faster generation
            'use_speaker_boost': true,
            'speaking_rate': 1.0,    // Normal speaking rate
            'pitch': 0.9             // Keep pitch for natural sound
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          sendTimeout: Duration(seconds: 10),  // Add timeout
          receiveTimeout: Duration(seconds: 10),
        ),
      );
      
      final bytes = response.data as List<int>;
      final dir = await getTemporaryDirectory();
      final filePath = path.join(dir.path, 'theera_response.mp3');
      
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      
      return filePath;
    } catch (e) {
      print('Error in text to speech: $e');
      rethrow;
    }
  }
  
  Future<List<Map<String, dynamic>>> getVoices() async {
    try {
      final response = await _dio.get('/voices');
      final List<dynamic> voices = response.data['voices'];
      
      return voices.map((voice) => {
        'id': voice['voice_id'],
        'name': voice['name'],
        'preview_url': voice['preview_url'],
      }).toList();
    } catch (e) {
      print('Error getting voices: $e');
      rethrow;
    }
  }
} 