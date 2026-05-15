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
            msg: status == 'completed' ? 'Withdrawal approved' : 'Withdrawal rejected',
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
        return const Color(0xFF0F766E);
      case 'rejected':
        return Colors.red;
      default:
        return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text(
          'Withdrawal Requests',
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _withdrawals.isEmpty
              ? Center(
                  child: Text(
                    'No withdrawal requests.',
                    style: GoogleFonts.spaceGrotesk(color: Colors.black45),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
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
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.grey.shade400,
                          ),
                        ],
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _statusColor(status).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
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
                          const SizedBox(height: 6),
                          Text(
                            w['user_email'] ?? '',
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 13, color: Colors.blueAccent),
                          ),
                          Text(
                            truncated,
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 12, color: Colors.black54),
                          ),
                          Text(
                            w['created_at']?.toString().substring(0, 16) ?? '',
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 11, color: Colors.black38),
                          ),
                          if (isPending) ...[
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _updateStatus(id, 'completed'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF0F766E),
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
