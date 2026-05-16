// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_any_logo/flutter_logo.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tratherwallet/users/Screens/paymentscreens/btc.dart';
import 'package:tratherwallet/users/Screens/paymentscreens/doge.dart';
import 'package:tratherwallet/users/Screens/paymentscreens/eth.dart';
import 'package:tratherwallet/users/controllers/coin_controller.dart';
import 'package:tratherwallet/users/model/coin_model.dart';

// ─── Data model ───────────────────────────────────────────────────────────────

class _Holding {
  final String coinId;
  final String symbol;
  final String name;
  final String image;
  double amount;

  _Holding({
    required this.coinId,
    required this.symbol,
    required this.name,
    required this.image,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
        'coinId': coinId,
        'symbol': symbol,
        'name': name,
        'image': image,
        'amount': amount,
      };

  factory _Holding.fromJson(Map<String, dynamic> j) => _Holding(
        coinId: j['coinId'],
        symbol: j['symbol'],
        name: j['name'],
        image: j['image'],
        amount: (j['amount'] as num).toDouble(),
      );
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class WalletScreen extends StatefulWidget {
  WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  static const Color primary = Color(0xFF0F766E);
  static const Color accent = Color(0xFFF59E0B);
  static const String _prefKey = 'portfolio_holdings';

  final CoinController _coinCtrl = Get.put(CoinController());
  List<_Holding> _holdings = [];
  late TabController _tabController;

  // search inside the add-holding sheet
  final _searchCtrl = TextEditingController();
  List<Coin> _filteredCoins = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadHoldings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Persistence ─────────────────────────────────────────────────────────────

  Future<void> _loadHoldings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefKey);
    if (raw != null) {
      final list = (jsonDecode(raw) as List)
          .map((e) => _Holding.fromJson(e))
          .toList();
      setState(() => _holdings = list);
    }
  }

  Future<void> _saveHoldings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _prefKey, jsonEncode(_holdings.map((h) => h.toJson()).toList()));
  }

  // ── Portfolio math ───────────────────────────────────────────────────────────

  double _totalValue(List<Coin> coins) {
    double total = 0;
    for (final h in _holdings) {
      final coin = _coinFor(h.coinId, coins);
      if (coin != null) total += h.amount * coin.currentPrice;
    }
    return total;
  }

  double _total24hChange(List<Coin> coins) {
    double change = 0;
    for (final h in _holdings) {
      final coin = _coinFor(h.coinId, coins);
      if (coin != null) change += h.amount * coin.priceChange24H;
    }
    return change;
  }

  Coin? _coinFor(String coinId, List<Coin> coins) {
    try {
      return coins.firstWhere((c) => c.id == coinId);
    } catch (_) {
      return null;
    }
  }

  // ── Add / Edit holding ───────────────────────────────────────────────────────

  void _showAddSheet() {
    _searchCtrl.clear();
    _filteredCoins = List.from(_coinCtrl.coinsList);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddHoldingSheet(
        searchCtrl: _searchCtrl,
        initialCoins: _filteredCoins,
        coinsList: _coinCtrl.coinsList,
        onAdd: (coin, amount) {
          final existing = _holdings.indexWhere((h) => h.coinId == coin.id);
          setState(() {
            if (existing >= 0) {
              _holdings[existing].amount = amount;
            } else {
              _holdings.add(_Holding(
                coinId: coin.id,
                symbol: coin.symbol,
                name: coin.name,
                image: coin.image,
                amount: amount,
              ));
            }
          });
          _saveHoldings();
        },
      ),
    );
  }

  void _editHolding(_Holding holding, List<Coin> coins) {
    final coin = _coinFor(holding.coinId, coins);
    final amtCtrl =
        TextEditingController(text: holding.amount.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF6F3EE),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(holding.image,
                        width: 36, height: 36, errorBuilder: (_, __, ___) =>
                            const Icon(Icons.currency_bitcoin, color: primary)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(holding.name,
                          style: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black87)),
                      if (coin != null)
                        Text(
                            '\$${NumberFormat('#,##0.00').format(coin.currentPrice)} each',
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 12, color: Colors.black45)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12),
                ),
                child: TextField(
                  controller: amtCtrl,
                  autofocus: true,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                  ],
                  style: GoogleFonts.spaceGrotesk(
                      fontSize: 14, color: Colors.black87),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    hintText: 'Amount (e.g. 0.5)',
                    hintStyle: GoogleFonts.spaceGrotesk(
                        color: Colors.black38, fontSize: 14),
                    prefixIcon: const Icon(Icons.edit_outlined,
                        color: primary, size: 18),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => _holdings
                            .removeWhere((h) => h.coinId == holding.coinId));
                        _saveHoldings();
                        Navigator.pop(ctx);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('Remove',
                          style: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final val = double.tryParse(amtCtrl.text);
                        if (val != null && val >= 0) {
                          setState(() => holding.amount = val);
                          _saveHoldings();
                        }
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('Save',
                          style: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────

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
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Obx(() {
              final coins = _coinCtrl.coinsList.toList();
              final loading = _coinCtrl.isLoading.value;
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                children: [
                  // ── Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Portfolio',
                              style: GoogleFonts.spaceGrotesk(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87)),
                          const SizedBox(height: 4),
                          Text('Track your crypto holdings',
                              style: GoogleFonts.spaceGrotesk(
                                  fontSize: 13, color: Colors.black45)),
                        ],
                      ),
                      GestureDetector(
                        onTap: _coinCtrl.isLoading.value ? null : _showAddSheet,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.add, color: primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Total value card
                  _buildTotalCard(coins, loading),
                  const SizedBox(height: 20),

                  // ── Holdings list
                  if (_holdings.isEmpty)
                    _buildEmptyState()
                  else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Your Holdings',
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87)),
                        Text('Tap to edit',
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 12, color: Colors.black38)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(_holdings.length, (i) {
                      final h = _holdings[i];
                      final coin = _coinFor(h.coinId, coins);
                      return _buildHoldingCard(h, coin, _totalValue(coins));
                    }),
                  ],

                  const SizedBox(height: 28),

                  // ── Deposit addresses section
                  Row(
                    children: [
                      Text('Deposit Addresses',
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.07),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F3EE),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicator: BoxDecoration(
                                color: primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelColor: primary,
                              unselectedLabelColor: Colors.black45,
                              labelStyle: GoogleFonts.spaceGrotesk(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3),
                              tabs: [
                                Tab(child: AnyLogo.crypto.bitcoin.image()),
                                Tab(child: AnyLogo.crypto.ethereum.image()),
                                Tab(child: AnyLogo.crypto.dogecoin.image()),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.42,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              BtcScreen(),
                              EthScreen(),
                              DogeScreen(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(List<Coin> coins, bool loading) {
    final total = _totalValue(coins);
    final change = _total24hChange(coins);
    final isPositive = change >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Portfolio Value',
              style: GoogleFonts.spaceGrotesk(
                  color: Colors.white70,
                  fontSize: 13,
                  letterSpacing: 0.4)),
          const SizedBox(height: 10),
          loading
              ? const SizedBox(
                  height: 36,
                  width: 36,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : Text(
                  '\$${NumberFormat('#,##0.00').format(total)}',
                  style: GoogleFonts.spaceGrotesk(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
          const SizedBox(height: 10),
          if (!loading && _holdings.isNotEmpty)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isPositive
                            ? Colors.greenAccent
                            : Colors.redAccent)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                          isPositive
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: isPositive
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          size: 13),
                      const SizedBox(width: 4),
                      Text(
                        '${isPositive ? '+' : ''}\$${NumberFormat('#,##0.00').format(change.abs())} today',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isPositive
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (!loading && _holdings.isEmpty)
            Text('Add holdings to track your portfolio',
                style: GoogleFonts.spaceGrotesk(
                    color: Colors.white54, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildHoldingCard(_Holding h, Coin? coin, double totalValue) {
    final value = coin != null ? h.amount * coin.currentPrice : 0.0;
    final pct = coin?.priceChangePercentage24H ?? 0.0;
    final isUp = pct >= 0;
    final allocation =
        totalValue > 0 ? (value / totalValue * 100) : 0.0;

    return GestureDetector(
      onTap: coin != null
          ? () => _editHolding(h, _coinCtrl.coinsList.toList())
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Coin logo
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                h.image,
                width: 42,
                height: 42,
                errorBuilder: (_, __, ___) => Container(
                  width: 42,
                  height: 42,
                  color: primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.currency_bitcoin,
                      color: primary, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name + amount
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(h.name,
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  const SizedBox(height: 2),
                  Text(
                    '${h.amount} ${h.symbol.toUpperCase()}',
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
            ),
            // Value + change + allocation
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${NumberFormat('#,##0.00').format(value)}',
                  style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                        isUp
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 11,
                        color: isUp
                            ? const Color(0xFF10B981)
                            : Colors.redAccent),
                    const SizedBox(width: 2),
                    Text(
                      '${pct.toStringAsFixed(2)}%',
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 11,
                          color: isUp
                              ? const Color(0xFF10B981)
                              : Colors.redAccent,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${allocation.toStringAsFixed(1)}%',
                        style: GoogleFonts.spaceGrotesk(
                            fontSize: 10,
                            color: primary,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pie_chart_outline,
                color: primary, size: 36),
          ),
          const SizedBox(height: 14),
          Text('No holdings yet',
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54)),
          const SizedBox(height: 6),
          Text('Tap + to add your first coin',
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 13, color: Colors.black38)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _showAddSheet,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.add, size: 18),
            label: Text('Add Holding',
                style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ─── Add Holding Bottom Sheet ─────────────────────────────────────────────────

class _AddHoldingSheet extends StatefulWidget {
  final TextEditingController searchCtrl;
  final List<Coin> initialCoins;
  final RxList<Coin> coinsList;
  final void Function(Coin coin, double amount) onAdd;

  const _AddHoldingSheet({
    required this.searchCtrl,
    required this.initialCoins,
    required this.coinsList,
    required this.onAdd,
  });

  @override
  State<_AddHoldingSheet> createState() => _AddHoldingSheetState();
}

class _AddHoldingSheetState extends State<_AddHoldingSheet> {
  static const Color primary = Color(0xFF0F766E);

  Coin? _selected;
  final _amtCtrl = TextEditingController();
  late List<Coin> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = List.from(widget.coinsList);
    widget.searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    widget.searchCtrl.removeListener(_onSearch);
    _amtCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = widget.searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? List.from(widget.coinsList)
          : widget.coinsList
              .where((c) =>
                  c.name.toLowerCase().contains(q) ||
                  c.symbol.toLowerCase().contains(q))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFFF6F3EE),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _selected == null ? 'Select a Coin' : 'Enter Amount',
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87),
              ),
            ),
            const SizedBox(height: 14),

            if (_selected == null) ...[
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: TextField(
                    controller: widget.searchCtrl,
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 14, color: Colors.black87),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      prefixIcon: const Icon(Icons.search,
                          color: primary, size: 20),
                      hintText: 'Search coins…',
                      hintStyle: GoogleFonts.spaceGrotesk(
                          color: Colors.black38, fontSize: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Coin list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) {
                    final coin = _filtered[i];
                    return GestureDetector(
                      onTap: () => setState(() => _selected = coin),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(coin.image,
                                  width: 36,
                                  height: 36,
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.currency_bitcoin,
                                      color: primary)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(coin.name,
                                      style: GoogleFonts.spaceGrotesk(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.black87)),
                                  Text(coin.symbol.toUpperCase(),
                                      style: GoogleFonts.spaceGrotesk(
                                          fontSize: 12,
                                          color: Colors.black38)),
                                ],
                              ),
                            ),
                            Text(
                              '\$${NumberFormat('#,##0.00').format(coin.currentPrice)}',
                              style: GoogleFonts.spaceGrotesk(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              // Amount entry
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Selected coin chip
                      GestureDetector(
                        onTap: () => setState(() {
                          _selected = null;
                          _amtCtrl.clear();
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(_selected!.image,
                                    width: 24,
                                    height: 24,
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.currency_bitcoin,
                                        color: primary,
                                        size: 18)),
                              ),
                              const SizedBox(width: 8),
                              Text(_selected!.name,
                                  style: GoogleFonts.spaceGrotesk(
                                      fontWeight: FontWeight.w600,
                                      color: primary,
                                      fontSize: 13)),
                              const SizedBox(width: 6),
                              const Icon(Icons.close,
                                  color: primary, size: 14),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('How many ${_selected!.symbol.toUpperCase()} do you hold?',
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 14, color: Colors.black54)),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: TextField(
                          controller: _amtCtrl,
                          autofocus: true,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*'))
                          ],
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            hintText: '0.00',
                            hintStyle: GoogleFonts.spaceGrotesk(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black26),
                            suffixText: _selected!.symbol.toUpperCase(),
                            suffixStyle: GoogleFonts.spaceGrotesk(
                                fontSize: 14, color: Colors.black38),
                          ),
                          onChanged: (v) => setState(() {}),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Live USD preview
                      Obx(() {
                        final coins = Get.find<CoinController>().coinsList;
                        Coin? live;
                        try {
                          live = coins.firstWhere(
                              (c) => c.id == _selected!.id);
                        } catch (_) {}
                        final amt =
                            double.tryParse(_amtCtrl.text) ?? 0;
                        final usd =
                            live != null ? amt * live.currentPrice : 0.0;
                        return Text(
                          '≈ \$${NumberFormat('#,##0.00').format(usd)}',
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 14, color: Colors.black38),
                        );
                      }),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final amt = double.tryParse(_amtCtrl.text);
                            if (amt != null && amt > 0) {
                              widget.onAdd(_selected!, amt);
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text('Add to Portfolio',
                              style: GoogleFonts.spaceGrotesk(
                                  fontWeight: FontWeight.w600, fontSize: 15)),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
