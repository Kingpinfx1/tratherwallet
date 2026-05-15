// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:convert';

import 'package:tratherwallet/admin/admin_preferences.dart';
import 'package:tratherwallet/admin/admin_screens/edit_users.dart';
import 'package:tratherwallet/api_connection/api_connection.dart';
import 'package:tratherwallet/users/model/user_model.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class AdminGetAllUsers extends StatefulWidget {
  const AdminGetAllUsers({super.key});

  @override
  State<AdminGetAllUsers> createState() => _AdminGetAllUsersState();
}

class _AdminGetAllUsersState extends State<AdminGetAllUsers> {
  static const Color bg = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color teal = Color(0xFF0F766E);
  static const Color border = Color(0xFF334155);

  List<User> _allUsers = [];
  List<User> _filtered = [];
  bool _loading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? List.from(_allUsers)
          : _allUsers.where((u) {
              return u.user_email.toLowerCase().contains(q) ||
                  u.user_firstname.toLowerCase().contains(q) ||
                  u.user_lastname.toLowerCase().contains(q) ||
                  u.user_id.toString().contains(q);
            }).toList();
    });
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final token = await AdminPrefs.getAdminToken();
    try {
      var res = await http.post(Uri.parse(API.readAllUsers), body: {
        'admin_token': token,
      });

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        if (body['success'] == true) {
          final users = (body['allUsersData'] as List)
              .map((e) => User.fromJson(e))
              .toList();
          setState(() {
            _allUsers = users;
            _filtered = List.from(users);
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Failed to load users");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
    setState(() => _loading = false);
  }

  Future<void> _deleteUser(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete User',
          style: GoogleFonts.spaceGrotesk(
              color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Remove ${user.user_firstname} ${user.user_lastname} permanently?',
          style: GoogleFonts.spaceGrotesk(color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel',
                style: GoogleFonts.spaceGrotesk(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Delete',
                style: GoogleFonts.spaceGrotesk(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final token = await AdminPrefs.getAdminToken();
    try {
      var res = await http.post(Uri.parse(API.deleteUser), body: {
        'user_id': user.user_id.toString(),
        'admin_token': token,
      });

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        if (body['success'] == true) {
          Fluttertoast.showToast(
              msg: "User deleted", gravity: ToastGravity.CENTER);
          _load();
        } else {
          Fluttertoast.showToast(msg: "Failed to delete user");
        }
      } else {
        Fluttertoast.showToast(msg: "Connection error");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  String _initials(User u) {
    final f = u.user_firstname.isNotEmpty ? u.user_firstname[0] : '';
    final l = u.user_lastname.isNotEmpty ? u.user_lastname[0] : '';
    return (f + l).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Users',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: _load,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Container(
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: border),
              ),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF0F766E), size: 20),
                  hintText: 'Search by name, email or ID…',
                  hintStyle:
                      GoogleFonts.spaceGrotesk(color: Colors.white38, fontSize: 14),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.white38, size: 18),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),

          // Count label
          if (!_loading)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                children: [
                  Text(
                    '${_filtered.length} user${_filtered.length == 1 ? '' : 's'}',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

          // List
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF0F766E)),
                  )
                : _filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person_off_outlined,
                                color: Colors.white24, size: 56),
                            const SizedBox(height: 12),
                            Text(
                              _searchController.text.isNotEmpty
                                  ? 'No users match your search.'
                                  : 'No users found.',
                              style: GoogleFonts.spaceGrotesk(
                                  color: Colors.white38, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                        itemCount: _filtered.length,
                        itemBuilder: (context, index) {
                          final u = _filtered[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: border),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 14),
                              child: Row(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: teal.withValues(alpha: 0.18),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        _initials(u),
                                        style: GoogleFonts.spaceGrotesk(
                                          color: teal,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${u.user_firstname} ${u.user_lastname}',
                                          style: GoogleFonts.spaceGrotesk(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          u.user_email,
                                          style: GoogleFonts.spaceGrotesk(
                                            color: teal,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            _pill('ID ${u.user_id}',
                                                Colors.white24),
                                            const SizedBox(width: 6),
                                            _pill(
                                                '\$${u.user_balance}',
                                                const Color(0xFFF59E0B)
                                                    .withValues(alpha: 0.25),
                                                textColor:
                                                    const Color(0xFFF59E0B)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Actions
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditUsersScreen(
                                                eachUserData: u),
                                          ),
                                        ).then((_) => _load()),
                                        icon: const Icon(Icons.edit_outlined,
                                            color: Color(0xFF0F766E), size: 20),
                                        tooltip: 'Edit',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(height: 10),
                                      IconButton(
                                        onPressed: () => _deleteUser(u),
                                        icon: Icon(Icons.delete_outline,
                                            color: Colors.red.shade400,
                                            size: 20),
                                        tooltip: 'Delete',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String label, Color bg, {Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          color: textColor ?? Colors.white54,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
