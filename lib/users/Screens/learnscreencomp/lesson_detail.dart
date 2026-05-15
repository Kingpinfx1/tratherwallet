import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tratherwallet/users/learn/lesson_data.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  final Color categoryColor;

  const LessonDetailScreen({
    super.key,
    required this.lesson,
    required this.categoryColor,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  static const Color primary = Color(0xFF0F766E);

  @override
  void initState() {
    super.initState();
    _markRead();
  }

  Future<void> _markRead() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lesson_${widget.lesson.id}_read', true);
  }

  @override
  Widget build(BuildContext context) {
    final bool isBeginner = widget.lesson.difficulty == 'Beginner';
    final Color difficultyColor = isBeginner ? primary : const Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: const Color(0xFFF7EFE3),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF7EFE3), Color(0xFFE9F5F2)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.black87, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          widget.lesson.title,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Difficulty + read time
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: difficultyColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.lesson.difficulty,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: difficultyColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(Icons.access_time,
                                size: 14, color: Colors.black45),
                            const SizedBox(width: 4),
                            Text(
                              widget.lesson.readTime,
                              style: GoogleFonts.spaceGrotesk(
                                  fontSize: 12, color: Colors.black45),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          widget.lesson.title,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.categoryColor,
                                widget.categoryColor.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Body text — parse **bold** markers
                        _buildBody(widget.lesson.body),

                        const SizedBox(height: 32),

                        // Key Takeaways
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: primary.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.lightbulb_outline,
                                        color: primary, size: 16),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Key Takeaways',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              ...widget.lesson.keyTakeaways.map(
                                (point) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        margin: const EdgeInsets.only(
                                            top: 6, right: 10),
                                        decoration: BoxDecoration(
                                          color: primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          point,
                                          style: GoogleFonts.spaceGrotesk(
                                            fontSize: 13,
                                            color: Colors.black87,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Done button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.check_circle_outline,
                                size: 18),
                            label: Text(
                              'Got it!',
                              style: GoogleFonts.spaceGrotesk(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(String body) {
    final paragraphs = body.split('\n\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((para) {
        final trimmed = para.trim();
        if (trimmed.isEmpty) return const SizedBox.shrink();

        // Section headers: **text**
        if (trimmed.startsWith('**') && trimmed.endsWith('**')) {
          final text = trimmed.substring(2, trimmed.length - 2);
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 6),
            child: Text(
              text,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          );
        }

        // Bullet list paragraphs
        if (trimmed.contains('\n- ') || trimmed.startsWith('- ')) {
          final lines = trimmed.split('\n');
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lines.map((line) {
                if (line.startsWith('- ')) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          margin:
                              const EdgeInsets.only(top: 8, right: 10, left: 4),
                          decoration: const BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: _richText(line.substring(2)),
                        ),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: _richText(line),
                );
              }).toList(),
            ),
          );
        }

        // Normal paragraph
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _richText(trimmed),
        );
      }).toList(),
    );
  }

  // Render inline **bold** markers
  Widget _richText(String text) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    int last = 0;
    for (final match in regex.allMatches(text)) {
      if (match.start > last) {
        spans.add(TextSpan(text: text.substring(last, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
      ));
      last = match.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last)));
    }
    return RichText(
      text: TextSpan(
        style: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          color: Colors.black87,
          height: 1.65,
        ),
        children: spans,
      ),
    );
  }
}
