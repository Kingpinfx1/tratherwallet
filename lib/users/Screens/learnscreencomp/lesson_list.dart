import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tratherwallet/users/learn/lesson_data.dart';
import 'package:tratherwallet/users/Screens/learnscreencomp/lesson_detail.dart';

class LessonListScreen extends StatefulWidget {
  final LessonCategory category;

  const LessonListScreen({super.key, required this.category});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  static const Color primary = Color(0xFF0F766E);

  Map<String, bool> _readMap = {};

  @override
  void initState() {
    super.initState();
    _loadReadState();
  }

  Future<void> _loadReadState() async {
    final prefs = await SharedPreferences.getInstance();
    final map = <String, bool>{};
    for (final lesson in widget.category.lessons) {
      map[lesson.id] = prefs.getBool('lesson_${lesson.id}_read') ?? false;
    }
    setState(() => _readMap = map);
  }

  @override
  Widget build(BuildContext context) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text(
                        widget.category.emoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.category.title,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Text(
                    '${widget.category.lessons.length} lessons',
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 13, color: Colors.black45),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                    itemCount: widget.category.lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = widget.category.lessons[index];
                      final isRead = _readMap[lesson.id] ?? false;
                      final isBeginner = lesson.difficulty == 'Beginner';
                      final diffColor = isBeginner
                          ? primary
                          : const Color(0xFFF59E0B);

                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LessonDetailScreen(
                                lesson: lesson,
                                categoryColor: widget.category.color,
                              ),
                            ),
                          );
                          _loadReadState();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Number badge
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: widget.category.color
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: widget.category.color,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lesson.title,
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: diffColor
                                                .withValues(alpha: 0.12),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            lesson.difficulty,
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: diffColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(Icons.access_time,
                                            size: 12, color: Colors.black38),
                                        const SizedBox(width: 3),
                                        Text(
                                          lesson.readTime,
                                          style: GoogleFonts.spaceGrotesk(
                                              fontSize: 11,
                                              color: Colors.black38),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Read indicator or chevron
                              isRead
                                  ? Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: primary.withValues(alpha: 0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check,
                                          color: primary, size: 16),
                                    )
                                  : const Icon(Icons.chevron_right,
                                      color: Colors.black26),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
