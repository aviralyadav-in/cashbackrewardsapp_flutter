import 'package:flutter/material.dart';
import '../services/url_launcher_service.dart';

class ReviewUsScreen extends StatefulWidget {
  static const String routeName = '/review-us';

  const ReviewUsScreen({super.key});

  @override
  State<ReviewUsScreen> createState() => _ReviewUsScreenState();
}

class _ReviewUsScreenState extends State<ReviewUsScreen> {
  int _selectedRating = 5;
  final TextEditingController _feedbackController = TextEditingController();

  final List<Map<String, dynamic>> _dummyReviews = [
    {
      'id': 'rev_1',
      'name': 'Aarav Sharma',
      'initials': 'AS',
      'avatarColor': const Color(0xFF1E90FF),
      'rating': 5,
      'date': '2 days ago',
      'review':
          'I have withdrawn over ₹4,500 directly into my bank account! Tracking is super accurate for Flipkart & Amazon shopping. Highly recommended app for online savings!',
      'likes': 24,
      'dislikes': 1,
      'userReaction': null, // 'like', 'dislike', or null
    },
    {
      'id': 'rev_2',
      'name': 'Priya Patel',
      'initials': 'PP',
      'avatarColor': Colors.purple,
      'rating': 5,
      'date': '5 days ago',
      'review':
          'The cashback rates on Myntra and Nykaa during sales are unmatched. Customer support also resolved my missing cashback ticket in just 2 days. 5 stars!',
      'likes': 18,
      'dislikes': 0,
      'userReaction': null,
    },
    {
      'id': 'rev_3',
      'name': 'Rohan Mehta',
      'initials': 'RM',
      'avatarColor': Colors.teal,
      'rating': 5,
      'date': '1 week ago',
      'review':
          'Smooth and clean interface. Love the instant UPI withdrawal feature once earnings are confirmed. Best cashback application in India.',
      'likes': 31,
      'dislikes': 2,
      'userReaction': null,
    },
    {
      'id': 'rev_4',
      'name': 'Sneha Roy',
      'initials': 'SR',
      'avatarColor': Colors.pinkAccent,
      'rating': 5,
      'date': '2 weeks ago',
      'review':
          'Refer & Earn program is truly awesome. All my friends registered and we all received bonuses. Very transparent tracking.',
      'likes': 15,
      'dislikes': 0,
      'userReaction': null,
    },
    {
      'id': 'rev_5',
      'name': 'Vikram Singh',
      'initials': 'VS',
      'avatarColor': Colors.deepOrange,
      'rating': 4,
      'date': '3 weeks ago',
      'review':
          'Genuine savings on every order. Just remember to activate cashback before adding items to cart. Payout was instant to my HDFC account.',
      'likes': 9,
      'dislikes': 1,
      'userReaction': null,
    },
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _handleReaction(Map<String, dynamic> review, String reactionType) {
    setState(() {
      final currentReaction = review['userReaction'] as String?;
      int likes = review['likes'] as int;
      int dislikes = review['dislikes'] as int;

      if (currentReaction == reactionType) {
        // Untoggle
        review['userReaction'] = null;
        if (reactionType == 'like') {
          review['likes'] = likes - 1;
        } else {
          review['dislikes'] = dislikes - 1;
        }
      } else {
        // Toggle new reaction
        if (currentReaction == 'like') {
          review['likes'] = likes - 1;
        } else if (currentReaction == 'dislike') {
          review['dislikes'] = dislikes - 1;
        }

        review['userReaction'] = reactionType;
        if (reactionType == 'like') {
          review['likes'] = (review['likes'] as int) + 1;
        } else {
          review['dislikes'] = (review['dislikes'] as int) + 1;
        }
      }
    });
  }

  void _submitFeedback() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.thumb_up_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text('Thank you! Your feedback has been received.'),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    _feedbackController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF161618) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Review Us',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Rating Banner Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161618) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF28282A)
                        : const Color(0xFFE5E5EA),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFC107)
                            .withValues(alpha: isDark ? 0.2 : 0.12),
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        size: 44,
                        color: Color(0xFFFFC107),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loving Cashback & Rewards?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your ratings help us partner with more top brands and bring you even higher cashback rates!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Star Rating Picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starNumber = index + 1;
                        final isFilled = starNumber <= _selectedRating;

                        return IconButton(
                          iconSize: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            isFilled
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: isFilled
                                ? const Color(0xFFFFC107)
                                : (isDark
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade400),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedRating = starNumber;
                            });
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 16),

                    // Play Store / App Store Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => UrlLauncherService.openUrl(
                          'https://play.google.com/store/apps/details?id=com.cashkaro',
                        ),
                        icon: const Icon(Icons.open_in_new_rounded, size: 16),
                        label: const Text('Rate on Google Play Store'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E90FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // 2. Feedback Form Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161618) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF28282A)
                        : const Color(0xFFE5E5EA),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SHARE YOUR FEEDBACK',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _feedbackController,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'Tell us how we can make your experience even better...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.grey.shade600
                              : Colors.grey.shade400,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF242426)
                            : const Color(0xFFF5F5F7),
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: _submitFeedback,
                        icon: const Icon(Icons.send_rounded, size: 16),
                        label: const Text('Submit Feedback'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF1E90FF),
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Community Reviews Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'COMMUNITY REVIEWS',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 16, color: Color(0xFFFFC107)),
                      const SizedBox(width: 4),
                      Text(
                        '4.9 (48.5K Reviews)',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ...List.generate(_dummyReviews.length, (index) {
                final rev = _dummyReviews[index];
                final userReaction = rev['userReaction'] as String?;
                final isLiked = userReaction == 'like';
                final isDisliked = userReaction == 'dislike';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161618) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF28282A)
                          : const Color(0xFFE5E5EA),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: isDark ? 0.25 : 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Avatar, Name, Rating & Date
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (rev['avatarColor'] as Color)
                                  .withValues(alpha: 0.2),
                              border: Border.all(
                                color: (rev['avatarColor'] as Color)
                                    .withValues(alpha: 0.6),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                rev['initials'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: rev['avatarColor'] as Color,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rev['name'] as String,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Row(
                                      children: List.generate(
                                        5,
                                        (starIdx) => Icon(
                                          starIdx < (rev['rating'] as int)
                                              ? Icons.star_rounded
                                              : Icons.star_outline_rounded,
                                          size: 14,
                                          color: const Color(0xFFFFC107),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '•  ${rev['date']}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Review Content
                      Text(
                        rev['review'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 14),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: isDark
                            ? const Color(0xFF242426)
                            : const Color(0xFFF0F0F3),
                      ),
                      const SizedBox(height: 10),

                      // Like / Dislike Action Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Was this review helpful?',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Like Button
                          InkWell(
                            onTap: () => _handleReaction(rev, 'like'),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    isLiked
                                        ? Icons.thumb_up_rounded
                                        : Icons.thumb_up_alt_outlined,
                                    size: 16,
                                    color: isLiked
                                        ? const Color(0xFF1E90FF)
                                        : (isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${rev['likes']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isLiked
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isLiked
                                          ? const Color(0xFF1E90FF)
                                          : (isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Dislike Button
                          InkWell(
                            onTap: () => _handleReaction(rev, 'dislike'),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    isDisliked
                                        ? Icons.thumb_down_rounded
                                        : Icons.thumb_down_alt_outlined,
                                    size: 16,
                                    color: isDisliked
                                        ? Colors.redAccent
                                        : (isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${rev['dislikes']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isDisliked
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isDisliked
                                          ? Colors.redAccent
                                          : (isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
