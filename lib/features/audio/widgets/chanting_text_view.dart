import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ChantingTextView extends StatefulWidget {
  const ChantingTextView({
    super.key,
    required this.text,
    required this.positionStream,
    required this.durationStream,
  });

  final String text;
  final Stream<Duration> positionStream;
  final Stream<Duration?> durationStream;

  @override
  State<ChantingTextView> createState() => _ChantingTextViewState();
}

class _ChantingTextViewState extends State<ChantingTextView> {
  final _scrollController = ScrollController();
  bool _autoScroll = true;
  Duration _position = Duration.zero;
  Duration _duration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    widget.positionStream.listen((pos) {
      if (mounted) {
        setState(() => _position = pos);
        if (_autoScroll) _syncScroll();
      }
    });
    widget.durationStream.listen((dur) {
      if (mounted && dur != null) {
        setState(() => _duration = dur);
      }
    });
  }

  void _syncScroll() {
    if (!_scrollController.hasClients) return;
    final maxExtent = _scrollController.position.maxScrollExtent;
    if (maxExtent <= 0) return;

    final fraction = _duration.inMilliseconds > 0
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;
    final target = (fraction * maxExtent).clamp(0.0, maxExtent);

    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Auto-scroll toggle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Icon(Icons.auto_stories_outlined,
                  size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                'Auto-scroll',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const Spacer(),
              Switch(
                value: _autoScroll,
                onChanged: (v) => setState(() => _autoScroll = v),
                activeTrackColor: AppColors.green,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Text content
        Expanded(
          child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              // Disable auto-scroll when user manually scrolls
              if (_autoScroll) {
                setState(() => _autoScroll = false);
              }
              return false;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                widget.text,
                style: const TextStyle(
                  fontSize: 18,
                  height: 2.0,
                  fontFamily: 'NotoSerif',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
