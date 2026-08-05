import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/audio_waveform_visualizer.dart';
import '../../core/widgets/primary_record_button.dart';

class RecordingModal extends ConsumerStatefulWidget {
  final Function(String transcript) onTranscriptProcessed;

  const RecordingModal({super.key, required this.onTranscriptProcessed});

  @override
  ConsumerState<RecordingModal> createState() => _RecordingModalState();
}

class _RecordingModalState extends ConsumerState<RecordingModal> {
  bool _isRecording = false;
  bool _isProcessing = false;
  String _currentTranscript = AppStrings.tapToRecord;

  void _toggleRecording() async {
    if (!_isRecording) {
      setState(() {
        _isRecording = true;
        _currentTranscript = AppStrings.listeningPrompt;
      });
    } else {
      setState(() {
        _isRecording = false;
        _isProcessing = true;
        _currentTranscript = AppStrings.processingPrompt;
      });

      await Future.delayed(const Duration(seconds: 2));

      const sampleVoiceInput =
          'Tomorrow morning I have a meeting with my HOD regarding the CodeVerse Visualizer. Before that I need to finish my presentation, call Rahul, and send the proposal.';

      if (mounted) {
        widget.onTranscriptProcessed(sampleVoiceInput);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.darkGlassBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            _isProcessing ? 'AI Processing' : (_isRecording ? 'Listening...' : 'Speak Naturally'),
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _currentTranscript,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondaryDark,
                    height: 1.4,
                  ),
            ),
          ),
          const SizedBox(height: 32),

          AudioWaveformVisualizer(isRecording: _isRecording),
          const SizedBox(height: 40),

          if (_isProcessing)
            const CircularProgressIndicator(color: AppColors.primaryAccent)
          else
            PrimaryRecordButton(
              isRecording: _isRecording,
              onTap: _toggleRecording,
              size: 90,
            ),
          const SizedBox(height: 16),

          Text(
            _isRecording ? 'Tap Stop when finished' : 'Tap to start recording',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMutedDark,
                ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
