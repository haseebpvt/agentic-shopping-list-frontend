import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class SpeechToTextService {
  final RecorderController _recorderController = RecorderController();
  final String _openAiApiKey;
  String? _currentRecordingPath;

  SpeechToTextService(this._openAiApiKey);

  /// Checks if microphone permission is granted
  Future<bool> hasPermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  /// Requests microphone permission
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Starts recording audio
  Future<bool> startRecording() async {
    try {
      // Check permission first
      if (!await hasPermission()) {
        final granted = await requestPermission();
        if (!granted) {
          print("❌ Microphone permission denied");
          return false;
        }
      }

      // Get temporary directory for recording
      final tempDir = await getTemporaryDirectory();
      final fileName = 'voice_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      _currentRecordingPath = '${tempDir.path}/$fileName';

      // Start recording
      await _recorderController.record(
        path: _currentRecordingPath!,
        androidEncoder: AndroidEncoder.aac,
        androidOutputFormat: AndroidOutputFormat.mpeg4,
        iosEncoder: IosEncoder.kAudioFormatMPEG4AAC,
        sampleRate: 44100,
      );

      print("🎤 Started recording: $_currentRecordingPath");
      return true;
    } catch (e) {
      print("❌ Failed to start recording: $e");
      return false;
    }
  }

  /// Stops recording and returns the file path
  Future<String?> stopRecording() async {
    try {
      final path = await _recorderController.stop();
      print("🛑 Stopped recording: $path");
      return path;
    } catch (e) {
      print("❌ Failed to stop recording: $e");
      return null;
    }
  }

  /// Checks if currently recording
  Future<bool> isRecording() async {
    return _recorderController.isRecording;
  }

  /// Transcribes audio file using OpenAI's Whisper API
  Future<String?> transcribeAudio(String audioFilePath) async {
    try {
      print("🔄 Starting transcription for: $audioFilePath");

      final file = File(audioFilePath);
      if (!await file.exists()) {
        print("❌ Audio file does not exist: $audioFilePath");
        return null;
      }

      // Prepare multipart request
      final uri = Uri.parse('https://api.openai.com/v1/audio/transcriptions');
      final request = http.MultipartRequest('POST', uri);
      
      // Add headers
      request.headers['Authorization'] = 'Bearer $_openAiApiKey';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add form fields
      request.fields['model'] = 'gpt-4o-transcribe'; // Using the newer, higher quality model
      request.fields['response_format'] = 'text';
      request.fields['prompt'] = 'This is a voice input for adding items to a shopping list. Please transcribe clearly.';

      // Add audio file
      final audioBytes = await file.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          audioBytes,
          filename: 'audio.m4a',
        ),
      );

      print("🌐 Sending transcription request to OpenAI...");
      
      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📡 OpenAI response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final transcription = response.body.trim();
        print("✅ Transcription successful: $transcription");
        
        // Clean up the audio file
        await _cleanupRecording(audioFilePath);
        
        return transcription;
      } else {
        print("❌ Transcription failed: ${response.statusCode}");
        print("❌ Response body: ${response.body}");
        
        // Try to parse error message
        try {
          final errorData = jsonDecode(response.body);
          print("❌ Error details: ${errorData['error']?['message'] ?? 'Unknown error'}");
        } catch (_) {
          // Ignore JSON parsing errors
        }
        
        return null;
      }
    } catch (e) {
      print("❌ Transcription error: $e");
      return null;
    }
  }

  /// Cleans up recording file
  Future<void> _cleanupRecording(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        print("🗑️ Cleaned up recording: $filePath");
      }
    } catch (e) {
      print("⚠️ Failed to cleanup recording: $e");
    }
  }

  /// Cancels current recording and cleans up
  Future<void> cancelRecording() async {
    try {
      if (await isRecording()) {
        await _recorderController.stop();
      }
      
      if (_currentRecordingPath != null) {
        await _cleanupRecording(_currentRecordingPath!);
        _currentRecordingPath = null;
      }
      
      print("🚫 Recording cancelled and cleaned up");
    } catch (e) {
      print("❌ Failed to cancel recording: $e");
    }
  }

  /// Disposes resources
  void dispose() {
    _recorderController.dispose();
  }
}
