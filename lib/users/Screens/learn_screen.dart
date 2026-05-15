// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tratherwallet/users/learn/lesson_data.dart';
import 'package:tratherwallet/users/Screens/learnscreencomp/lesson_detail.dart';
import 'package:tratherwallet/users/Screens/learnscreencomp/lesson_list.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  static const Color primary = Color(0xFF0F766E);
  static const Color accent = Color(0xFFF59E0B);

  final _searchController = TextEditingController();
  List<_SearchResult> _searchResults = [];
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchController.text.toLowerCase().trim();
    setState(() {
      _searching = q.isNotEmpty;
      if (!_searching) {
        _searchResults = [];
        return;
      }
      _searchResults = [];
      for (final cat in lessonCategories) {
        for (final lesson in cat.lessons) {
          if (lesson.title.toLowerCase().contains(q) ||
              lesson.difficulty.toLowerCase().contains(q) ||
              cat.title.toLowerCase().contains(q)) {
            _searchResults.add(_SearchResult(category: cat, lesson: lesson));
          }
        }
      }
    });
  }

  int get _totalLessons =>
      lessonCategories.fold(0, (sum, c) => sum + c.lessons.length);

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
          Positioned(
            top: -40,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -40,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Learn Crypto',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_totalLessons lessons across ${lessonCategories.length} topics',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),

                // Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 14, color: Colors.black87),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        prefixIcon: const Icon(Icons.search,
                            color: primary, size: 20),
                        hintText: 'Search lessons…',
                        hintStyle: GoogleFonts.spaceGrotesk(
                            color: Colors.black38, fontSize: 14),
                        suffixIcon: _searching
                            ? IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.black38, size: 18),
                                onPressed: () => _searchController.clear(),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),

                // Body — search results or category grid
                Expanded(
                  child: _searching ? _buildSearchResults() : _buildGrid(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.1,
      ),
      itemCount: lessonCategories.length,
      itemBuilder: (context, index) {
        final cat = lessonCategories[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonListScreen(category: cat),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Colored top bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: cat.color,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cat.emoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat.title,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${cat.lessons.length} lessons',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, color: Colors.black26, size: 48),
            const SizedBox(height: 12),
            Text(
              'No lessons found.',
              style: GoogleFonts.spaceGrotesk(
                  color: Colors.black38, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        final isBeginner = result.lesson.difficulty == 'Beginner';
        final diffColor = isBeginner ? primary : accent;

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonDetailScreen(
                lesson: result.lesson,
                categoryColor: result.category.color,
              ),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: result.category.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      result.category.emoji,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.lesson.title,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            result.category.title,
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 11, color: Colors.black38),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: Colors.black26,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: diffColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              result.lesson.difficulty,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: diffColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black26),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchResult {
  final LessonCategory category;
  final Lesson lesson;
  const _SearchResult({required this.category, required this.lesson});
}
