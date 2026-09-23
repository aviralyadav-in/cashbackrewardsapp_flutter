import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  Widget _buildTimerDigitBox(String digits, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFFF7043).withValues(alpha: 0.35),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF5722).withValues(alpha: 0.16),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            digits,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const deals = FlashDealsData.flashDeals;
    final isDark = widget.isDark;

    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [
                  Color(0xFF070A12),
                  Color(0xFF0F1526),
                  Color(0xFF18102A),
                  Color(0xFF0B0E1B),
                ]
              : const [
                  Color(0xFF0C1022),
                  Color(0xFF151C36),
                  Color(0xFF24163C),
                  Color(0xFF101326),
                ],
          stops: const [0.0, 0.35, 0.75, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Subtle Ambient Glow Circles
          Positioned(
            top: -40,
            left: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF5722).withValues(alpha: 0.07),
              ),
            ),
          ),

          // Main Section Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 28),

              // 1. URGENCY BADGE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5722).withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFFF5722).withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 5),
                    Text(
                      'LIMITED FLASH DROPS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFF8A65),
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 2. SECTION TITLE & SUBTITLE
              Text(
                'Flash Deals',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Grab highest cashback rewards before the timer expires',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // 3. SEGMENTED DIGITAL COUNTDOWN TIMER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimerDigitBox(_twoDigits(hours), 'HOURS'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Text(
                      ':',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFFFF8A65),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _buildTimerDigitBox(_twoDigits(minutes), 'MINS'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Text(
                      ':',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFFFF8A65),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _buildTimerDigitBox(_twoDigits(seconds), 'SECS'),
                ],
              ),
              const SizedBox(height: 22),

              // 4. HORIZONTAL DEALS CAROUSEL
              SizedBox(
                height: 254,
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
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

              // 5. VIEW ALL BUTTON (FROSTED GLASS PILL)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _onViewAllTap(context, deals),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Explore All Flash Deals',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.1,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ],
      ),
    );
  }
}
