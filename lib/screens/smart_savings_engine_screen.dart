import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/brand_model.dart';
import '../models/home_discovery_models.dart';
import '../theme/app_theme.dart';
import 'shopping_confirmation_screen.dart';

class SmartSavingsEngineScreen extends StatefulWidget {
  static const String routeName = '/smart-savings-engine';

  final SmartSavingsModel? initialModel;

  const SmartSavingsEngineScreen({
    super.key,
    this.initialModel,
  });

  @override
  State<SmartSavingsEngineScreen> createState() =>
      _SmartSavingsEngineScreenState();
}

class _PresetProduct {
  final String name;
  final String store;
  final double mrp;
  final double storeDiscount;
  final double couponDiscount;
  final String couponCode;
  final double cashbackPct;
  final String imageUrl;

  const _PresetProduct({
    required this.name,
    required this.store,
    required this.mrp,
    required this.storeDiscount,
    required this.couponDiscount,
    required this.couponCode,
    required this.cashbackPct,
    required this.imageUrl,
  });
}

class _SmartSavingsEngineScreenState extends State<SmartSavingsEngineScreen> {
  final TextEditingController _priceController = TextEditingController();

  static const List<_PresetProduct> _presets = [
    _PresetProduct(
      name: 'Sony WH-1000XM5 ANC',
      store: 'Amazon',
      mrp: 29990,
      storeDiscount: 4000,
      couponDiscount: 1500,
      couponCode: 'AUDIO1500',
      cashbackPct: 6.0,
      imageUrl: 'assets/banners/headphone_banner_16_9.jpg',
    ),
    _PresetProduct(
      name: 'Apple iPhone 15 (128GB)',
      store: 'Flipkart',
      mrp: 79900,
      storeDiscount: 8000,
      couponDiscount: 2000,
      couponCode: 'APPLEFEST20',
      cashbackPct: 5.0,
      imageUrl: 'assets/banners/phone_banner_16_9.jpg',
    ),
    _PresetProduct(
      name: 'Dyson V8 Absolute Vacuum',
      store: 'Dyson',
      mrp: 39900,
      storeDiscount: 6000,
      couponDiscount: 2000,
      couponCode: 'DYSONFEST',
      cashbackPct: 6.0,
      imageUrl: 'assets/cards/dyson-discount-codes.jpg',
    ),
    _PresetProduct(
      name: 'Nike Air Zoom Pegasus',
      store: 'Myntra',
      mrp: 11895,
      storeDiscount: 2500,
      couponDiscount: 1000,
      couponCode: 'MYNTRA1000',
      cashbackPct: 10.0,
      imageUrl: 'assets/banners/sneaker_banner_16_9.jpg',
    ),
  ];

  int _selectedPresetIndex = 0;
  bool _isCustom = false;

  String _productTitle = 'Sony WH-1000XM5 ANC';
  String _selectedStore = 'Amazon';
  double _mrp = 29990.0;
  double _storeDiscount = 4000.0;
  double _couponDiscount = 1500.0;
  String _couponCode = 'AUDIO1500';
  double _cashbackPct = 6.0;

  String _selectedBank = 'HDFC Bank';
  bool _useCoins = true;
  final double _availableCoins = 500.0;

  @override
  void initState() {
    super.initState();
    if (widget.initialModel != null) {
      final m = widget.initialModel!;
      _productTitle = m.productName;
      _selectedStore = m.bestStore;
      _mrp = m.productPrice;
      _storeDiscount = m.storeDiscount;
      _couponDiscount = m.couponDiscount;
      _cashbackPct = (m.cashback / (m.productPrice - m.storeDiscount)) * 100;
      _priceController.text = _mrp.toInt().toString();
      _isCustom = true;
    } else {
      _applyPreset(_presets[0]);
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _applyPreset(_PresetProduct p) {
    setState(() {
      _productTitle = p.name;
      _selectedStore = p.store;
      _mrp = p.mrp;
      _storeDiscount = p.storeDiscount;
      _couponDiscount = p.couponDiscount;
      _couponCode = p.couponCode;
      _cashbackPct = p.cashbackPct;
      _priceController.text = p.mrp.toInt().toString();
      _isCustom = false;
    });
  }

  double get _bankDiscount {
    final afterStoreAndCoupon = (_mrp - _storeDiscount - _couponDiscount).clamp(0.0, double.infinity);
    switch (_selectedBank) {
      case 'HDFC Bank':
        final d = afterStoreAndCoupon * 0.10;
        return d > 1500 ? 1500 : d;
      case 'ICICI Bank':
        final d = afterStoreAndCoupon * 0.10;
        return d > 1250 ? 1250 : d;
      case 'SBI Card':
        final d = afterStoreAndCoupon * 0.075;
        return d > 1000 ? 1000 : d;
      case 'Axis Bank':
        final d = afterStoreAndCoupon * 0.05;
        return d > 750 ? 750 : d;
      default:
        return 0.0;
    }
  }

  double get _coinDiscount {
    if (!_useCoins) return 0.0;
    final remaining = _mrp - _storeDiscount - _couponDiscount - _bankDiscount;
    return remaining > _availableCoins ? _availableCoins : remaining.clamp(0.0, double.infinity);
  }

  double get _cashbackAmount {
    final payableBeforeCashback =
        (_mrp - _storeDiscount - _couponDiscount - _bankDiscount - _coinDiscount).clamp(0.0, double.infinity);
    return (payableBeforeCashback * (_cashbackPct / 100.0)).roundToDouble();
  }

  double get _totalSavings =>
      _storeDiscount + _couponDiscount + _bankDiscount + _coinDiscount + _cashbackAmount;

  double get _finalEffectivePrice => (_mrp - _totalSavings).clamp(0.0, double.infinity);

  double get _savingsPercentage => _mrp > 0 ? ((_totalSavings / _mrp) * 100).clamp(0.0, 95.0) : 0.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textDark = isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A);
    final textMuted = isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF132247) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
        title: Text(
          '🧮 Smart Savings Engine',
          style: GoogleFonts.inter(
            fontSize: 18.5,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.cardBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: textDark),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // Header description
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF132247), const Color(0xFF1C2D5A)]
                    : [const Color(0xFFFAF2E9), const Color(0xFFF1F5F9)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 0.8),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBrown.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.layers_rounded,
                    color: AppColors.primaryBrown,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Multi-Layer Offer Stacking',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'See how combining store discounts, promo codes, bank cards & real cashback drops your price to the absolute minimum.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: textMuted,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // PRESETS HORIZONTAL BAR
          Text(
            'Select Product or Preset',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ..._presets.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final p = entry.value;
                  final isSelected = !_isCustom && _selectedPresetIndex == idx;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(p.name),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) {
                          _selectedPresetIndex = idx;
                          _applyPreset(p);
                        }
                      },
                      selectedColor: AppColors.primaryBrown,
                      labelStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.darkTextPrimary : AppColors.deepBrown),
                      ),
                      backgroundColor: cardBg,
                      side: BorderSide(
                        color: isSelected ? AppColors.primaryBrown : borderColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // PRODUCT PRICE SLIDER & INPUT
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_productTitle.isNotEmpty) ...[
                  Text(
                    _productTitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  children: [
                    Text(
                      'Product MRP / Original Price',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₹${_mrp.toInt()}',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _mrp.clamp(1000.0, 100000.0),
                  min: 1000,
                  max: 100000,
                  divisions: 99,
                  activeColor: AppColors.primaryBrown,
                  inactiveColor: borderColor,
                  onChanged: (val) {
                    setState(() {
                      _isCustom = true;
                      _mrp = (val / 100).round() * 100.0;
                      _storeDiscount = (_mrp * 0.12).roundToDouble();
                      _couponDiscount = (_mrp * 0.05).clamp(200.0, 2000.0).roundToDouble();
                      _priceController.text = _mrp.toInt().toString();
                    });
                  },
                ),
                Row(
                  children: [
                    Text(
                      'Store: $_selectedStore',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBrown,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Cashback Rate: ${_cashbackPct.toInt()}%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // BANK CARD & WALLET COIN TOGGLE
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment & Reward Boosters',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 10),

                // Bank selector
                Row(
                  children: [
                    const Icon(Icons.credit_card_rounded, size: 18, color: AppColors.primaryBrown),
                    const SizedBox(width: 8),
                    Text(
                      'Bank Card Offer:',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: textMuted),
                    ),
                    const Spacer(),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedBank,
                        dropdownColor: cardBg,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                        items: ['HDFC Bank', 'ICICI Bank', 'SBI Card', 'Axis Bank', 'None']
                            .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedBank = val);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16),

                // KashIQ Coins Toggle
                Row(
                  children: [
                    const Icon(Icons.monetization_on_rounded, size: 18, color: Color(0xFF2563EB)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Redeem 500 KashIQ Coins',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: textDark,
                            ),
                          ),
                          Text(
                            'Get extra ₹500 instant wallet deduction',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: textMuted),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _useCoins,
                      activeThumbColor: AppColors.primaryBrown,
                      onChanged: (val) {
                        setState(() => _useCoins = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // WATERFALL SAVINGS RESULTS
          _buildWaterfallCard(context, textDark, textMuted, isDark),
          const SizedBox(height: 20),

          // ACTION CTA
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShoppingConfirmationScreen(
                    brand: BrandModel(
                      name: _selectedStore,
                      logoUrl: '',
                      bannerUrl: '',
                      cashbackPercentage: '${_cashbackPct.toInt()}% Cashback',
                      category: 'Shopping',
                      offerText: 'Save up to ₹${_totalSavings.toInt()}',
                      websiteUrl: 'https://www.${_selectedStore.toLowerCase().replaceAll(' ', '')}.com',
                    ),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBrown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 3,
            ),
            icon: const Icon(Icons.shopping_bag_outlined, size: 20),
            label: Text(
              'Claim Deal & Save ₹${_totalSavings.toInt()} on $_selectedStore',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterfallCard(
    BuildContext context,
    Color textDark,
    Color textMuted,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2B2017), const Color(0xFF33261C)]
              : [const Color(0xFFFFF9F2), const Color(0xFFF9EFE4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBrown.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ribbon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${_savingsPercentage.toInt()}% TOTAL SAVINGS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Optimal Deal Stacking',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Savings Waterfall Rows
          _buildWaterfallRow('1. Initial Product MRP', '₹${_mrp.toInt()}', textDark, false),
          const SizedBox(height: 8),
          _buildWaterfallRow(
            '2. Store Instant Discount ($_selectedStore)',
            '-₹${_storeDiscount.toInt()}',
            AppColors.success,
            true,
          ),
          const SizedBox(height: 8),
          _buildWaterfallRow(
            '3. Promo Coupon Code ($_couponCode)',
            '-₹${_couponDiscount.toInt()}',
            AppColors.success,
            true,
          ),
          if (_bankDiscount > 0) ...[
            const SizedBox(height: 8),
            _buildWaterfallRow(
              '4. Bank Instant Discount ($_selectedBank)',
              '-₹${_bankDiscount.toInt()}',
              AppColors.success,
              true,
            ),
          ],
          if (_coinDiscount > 0) ...[
            const SizedBox(height: 8),
            _buildWaterfallRow(
              '5. KashIQ Coins Redemption',
              '-₹${_coinDiscount.toInt()}',
              const Color(0xFF2563EB),
              true,
            ),
          ],
          const SizedBox(height: 8),
          _buildWaterfallRow(
            '6. KashIQ Real Cashback (${_cashbackPct.toInt()}%)',
            '-₹${_cashbackAmount.toInt()}',
            isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
            true,
          ),

          const Divider(height: 24, thickness: 1),

          // Bottom Summary
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL MONEY SAVED',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                  Text(
                    '₹${_totalSavings.toInt()}',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'EFFECTIVE PAYABLE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: textMuted,
                    ),
                  ),
                  Text(
                    '₹${_finalEffectivePrice.toInt()}',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF2563EB) : AppColors.primaryBrown,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaterfallRow(
    String title,
    String value,
    Color color,
    bool isMinus,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isMinus ? null : const Color(0xFF88796E),
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: isMinus ? FontWeight.w700 : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
