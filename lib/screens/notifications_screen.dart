import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All'; // 'All', 'Cashback', 'Offers', 'Payouts', 'Referrals'

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'notif_1',
      'title': 'Cashback Confirmed! 🎉',
      'message':
          '₹245.50 cashback for your Myntra order #OD-872190 is confirmed and ready to withdraw to your bank account.',
      'time': '10 mins ago',
      'category': 'Cashback',
      'icon': Icons.account_balance_wallet_rounded,
      'color': AppColors.success,
      'isUnread': true,
    },
    {
      'id': 'notif_2',
      'title': 'Mega Cashback Carnival ⚡',
      'message':
          'Flat 12% extra cashback unlocked across Electronics & Laptops for the next 24 hours!',
      'time': '2 hours ago',
      'category': 'Offers',
      'icon': Icons.local_fire_department_rounded,
      'color': AppColors.pending,
      'isUnread': true,
    },
    {
      'id': 'notif_3',
      'title': 'Cashback Tracked Successfully',
      'message':
          '₹180.00 tracked for your Amazon purchase #OD-982341. Added to your pending earnings.',
      'time': 'Yesterday',
      'category': 'Cashback',
      'icon': Icons.shopping_bag_outlined,
      'color': AppColors.primaryBrown,
      'isUnread': false,
    },
    {
      'id': 'notif_4',
      'title': 'Payout Successful 💳',
      'message':
          '₹850.00 has been transferred to your UPI ID (deepak@okhdfcbank). Reference ID: TXN984210982.',
      'time': '18 Aug 2026',
      'category': 'Payouts',
      'icon': Icons.check_circle_rounded,
      'color': AppColors.success,
      'isUnread': false,
    },
    {
      'id': 'notif_5',
      'title': 'Referral Bonus Credited! 🎁',
      'message':
          'Your friend Rahul signed up using your link! ₹50.00 bonus has been credited to your wallet.',
      'time': '16 Aug 2026',
      'category': 'Referrals',
      'icon': Icons.people_outline_rounded,
      'color': AppColors.deepBrown,
      'isUnread': false,
    },
    {
      'id': 'notif_6',
      'title': 'Ajio Cashback Tracked',
      'message':
          '₹71.90 cashback tracked for your recent fashion purchase at Ajio #OD-650182.',
      'time': '28 Jul 2026',
      'category': 'Cashback',
      'icon': Icons.local_mall_outlined,
      'color': AppColors.primaryBrown,
      'isUnread': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'All') return _notifications;
    return _notifications
        .where((n) => n['category'] == _selectedFilter)
        .toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n['isUnread'] = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'All notifications marked as read.',
          style: AppTextStyles.body(color: AppColors.cardBackground),
        ),
        backgroundColor: AppColors.primaryBrown,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.mainBackground,
        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notifications',
          style: AppTextStyles.screenHeading(
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepBrown,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, size: 22),
            tooltip: 'Mark all as read',
            color: isDark ? AppColors.darkTextPrimary : AppColors.primaryBrown,
            onPressed: _markAllAsRead,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter categories horizontal list
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildFilterChip('All', isDark),
                    const SizedBox(width: 8),
                    _buildFilterChip('Cashback', isDark),
                    const SizedBox(width: 8),
                    _buildFilterChip('Offers', isDark),
                    const SizedBox(width: 8),
                    _buildFilterChip('Payouts', isDark),
                    const SizedBox(width: 8),
                    _buildFilterChip('Referrals', isDark),
                  ],
                ),
              ),
            ),

            // Notifications List
            Expanded(
              child: _filteredNotifications.isEmpty
                  ? Center(
                      child: Text(
                        'No notifications in $_selectedFilter',
                        style: AppTextStyles.body(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textMuted,
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notif = _filteredNotifications[index];
                        final isUnread = notif['isUnread'] as bool;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? (isUnread
                                    ? AppColors.darkSurface
                                    : AppColors.darkCard)
                                : (isUnread
                                    ? AppColors.beigeSurface.withValues(alpha: 0.45)
                                    : AppColors.cardBackground),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                            border: Border.all(
                              color: isUnread
                                  ? AppColors.primaryBrown.withValues(alpha: 0.4)
                                  : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.border),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: isDark ? 0.2 : 0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  notif['isUnread'] = false;
                                });
                              },
                              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    // Icon Container
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColors.darkSurface
                                            : AppColors.beigeSurface,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        notif['icon'] as IconData,
                                        color: notif['color'] as Color,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Notification Texts
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  notif['title'] as String,
                                                  style: AppTextStyles.cardTitle(
                                                    color: isDark
                                                        ? AppColors.darkTextPrimary
                                                        : AppColors.textPrimary,
                                                  ).copyWith(
                                                    fontWeight: isUnread
                                                        ? FontWeight.bold
                                                        : FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              if (isUnread)
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: AppColors.primaryBrown,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            notif['message'] as String,
                                            style: AppTextStyles.body(
                                              color: isDark
                                                  ? AppColors.darkTextSecondary
                                                  : AppColors.textSecondary,
                                            ).copyWith(fontSize: 12.5),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                notif['time'] as String,
                                                style: AppTextStyles.caption(
                                                  color: isDark
                                                      ? AppColors.darkTextSecondary
                                                      : AppColors.textMuted,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: isDark
                                                      ? AppColors.darkSurface
                                                      : AppColors.beigeSurface,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  notif['category'] as String,
                                                  style: AppTextStyles.smallLabel(
                                                    color: isDark
                                                        ? AppColors.darkTextSecondary
                                                        : AppColors.deepBrown,
                                                  ),
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
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isDark) {
    final isSelected = _selectedFilter == label;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBrown
              : (isDark ? AppColors.darkCard : AppColors.cardBackground),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBrown
                : (isDark
                    ? AppColors.darkBorder
                    : AppColors.border),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonText(
            color: isSelected
                ? AppColors.cardBackground
                : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
          ).copyWith(fontSize: 12),
        ),
      ),
    );
  }
}
