class Review {
  final String reviewerName;
  final double rating;
  final String comment;
  final DateTime? date;

  Review({
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    final dateValue = json['date'];
    DateTime? parsedDate;
    if (dateValue is String) {
      parsedDate = DateTime.tryParse(dateValue);
    }

    return Review(
      reviewerName:
          (json['reviewerName'] as String?) ??
          (json['name'] as String?) ??
          'Anonymous',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment:
          (json['comment'] as String?) ?? (json['review'] as String?) ?? '',
      date: parsedDate,
    );
  }
}
