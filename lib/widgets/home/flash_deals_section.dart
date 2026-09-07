import 'dart:async';
import 'package:flutter/material.dart';

import '../../data/flash_deals_data.dart';
import '../../models/brand_model.dart';
import '../../models/flash_deal_model.dart';
import '../../screens/top_category_brands_screen.dart';
import 'flash_deal_card.dart';

class FlashDealsSection extends StatefulWidget {
  final bool isDark;

  const FlashDealsSection({
    super.key,
    required this.isDark,
  });

  @override
  State<FlashDealsSection> createState() => _FlashDealsSectionState();
}

class _FlashDealsSectionState extends State<FlashDealsSection> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = (23 * 3600) + (0 * 60) + 25;
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _formatCountdown() {
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${_twoDigits(hours)}: ${_twoDigits(minutes)}: ${_twoDigits(seconds)}';
  }

  void _onViewAllTap(BuildContext context, List<FlashDeal> deals) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TopCategoryBrandsScreen(
          categoryTitle: 'Flash Deals',
          brands: deals
              .map(
                (deal) => BrandModel(
                  name: deal.brandName,
                  logoUrl: deal.logo,
                  bannerUrl: deal.productImage ?? deal.logo,
                  cashbackPercentage: deal.cashback,
                  category: deal.category,
                  offerText: '${deal.offer} • ${deal.saving}',
                  websiteUrl: deal.websiteUrl,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const deals = FlashDealsData.flashDeals;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/cards/flash_deals_bg.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 28),

          // 1. SECTION TITLE: "Flash Deals" (Centered)
          const Text(
            'Flash Deals',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 10),

          // 2. LIVE COUNTDOWN PILL: "Ends in 23: 00: 25"
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFD32F2F),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time_filled_rounded,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'Ends in ${_formatCountdown()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // 3. HORIZONTAL DEALS CAROUSEL (with headroom for pop-out products)
          SizedBox(
            height: 258,
            child: ListView.builder(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              itemCount: deals.length,
              itemBuilder: (context, index) {
                final deal = deals[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == deals.length - 1 ? 0 : 14,
                  ),
                  child: FlashDealCard(
                    deal: deal,
                    isDark: widget.isDark,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // 4. VIEW ALL BUTTON ON PEDESTAL STAGE
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onViewAllTap(context, deals),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 142,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E2125),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }
}
