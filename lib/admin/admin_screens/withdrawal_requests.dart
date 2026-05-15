// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:tratherwallet/admin/admin_preferences.dart';
import 'package:tratherwallet/api_connection/api_connection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AdminWithdrawalRequests extends StatefulWidget {
  const AdminWithdrawalRequests({super.key});

  @override
  State<AdminWithdrawalRequests> createState() =>
      _AdminWithdrawalRequestsState();
}

class _AdminWithdrawalRequestsState extends State<AdminWithdrawalRequests> {
  static const Color bg = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color teal = Color(0xFF0F766E);
  static const Color border = Color(0xFF334155);

  List<Map<String, dynamic>> _withdrawals = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final token = await AdminPrefs.getAdminToken();
    try {
      var res = await http.post(Uri.parse(API.readWithdrawals), body: {
        'admin_token': token,
      });
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        if (body['success'] == true) {
          setState(() {
            _withdrawals =
                List<Map<String, dynamic>>.from(body['withdrawals']);
          });
        }
      }
    } catch (_) {}
    setState(() => _loading = false);
  }

  Future<void> _updateStatus(int id, String status) async {
    final token = await AdminPrefs.getAdminToken();
    try {
      var res = await http.post(Uri.parse(API.updateWithdrawal), body: {
        'admin_token': token,
        'request_id': id.toString(),
        'status': status,
      });
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        if (body['success'] == true) {
          Fluttertoast.showToast(
            msg: status == 'completed'
                ? 'Withdrawal approved'
                : 'Withdrawal rejected',
            gravity: ToastGravity.CENTER,
          );
          _load();
          return;
        }
      }
      Fluttertoast.showToast(msg: 'Action failed');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'completed':
        return teal;
      case 'rejected':
        return Colors.red.shade400;
      default:
        return const Color(0xFFF59E0B);
    }
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
          'Withdrawal Requests',
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
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0F766E)))
          : _withdrawals.isEmpty
              ? Center(
                  child: Text(
                    'No withdrawal requests.',
                    style: GoogleFonts.spaceGrotesk(color: Colors.white60),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  itemCount: _withdrawals.length,
                  itemBuilder: (context, index) {
                    final w = _withdrawals[index];
                    final status = w['status'] ?? 'pending';
                    final isPending = status == 'pending';
                    final id = int.parse(w['id'].toString());
                    final address = w['wallet_address'] ?? '';
                    final truncated = address.length > 24
                        ? '${address.substring(0, 12)}...${address.substring(address.length - 8)}'
                        : address;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${w['amount']}',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _statusColor(status)
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: _statusColor(status)
                                          .withValues(alpha: 0.4)),
                                ),
                                child: Text(
                                  status[0].toUpperCase() + status.substring(1),
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _statusColor(status),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            w['user_email'] ?? '',
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 13, color: teal),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            truncated,
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 12, color: Colors.white54),
                          ),
                          Text(
                            w['created_at']?.toString().substring(0, 16) ?? '',
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 11, color: Colors.white38),
                          ),
                          if (isPending) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _updateStatus(id, 'completed'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: teal,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Approve',
                                      style: GoogleFonts.spaceGrotesk(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _updateStatus(id, 'rejected'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade400,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Reject',
                                      style: GoogleFonts.spaceGrotesk(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
