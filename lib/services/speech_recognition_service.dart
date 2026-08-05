import 'dart:async';

class SpeechRecognitionService {
  bool _isRecording = false;
  bool get isRecording => _isRecording;

  final _transcriptController = StreamController<String>.broadcast();
  Stream<String> get transcriptStream => _transcriptController.stream;

  Future<void> startRecording() async {
    _isRecording = true;
    _transcriptController.add('Listening...');
  }

  Future<String> stopRecording() async {
    _isRecording = false;
    // Simulated transcript of natural spoken voice input
    const sampleTranscript =
        'Tomorrow morning I have a meeting with my HOD regarding the CodeVerse Visualizer. Before that I need to finish my presentation, call Rahul, and send the proposal.';
    _transcriptController.add(sampleTranscript);
    return sampleTranscript;
  }

  void dispose() {
    _transcriptController.close();
  }
}
