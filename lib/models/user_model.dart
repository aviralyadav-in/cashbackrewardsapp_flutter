import 'dart:convert';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? avatarUrl;
  final String referralCode;
  final String? referredBy;
  final int coins;
  final double walletBalance;
  final double remainingBalance;
  final bool hasShopped;
  final double confirmedCashback;
  final double pendingCashback;
  final double referralEarnings;
  final double affiliateEarnings;

  const UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.avatarUrl,
    this.referralCode = '',
    this.referredBy,
    this.coins = 0,
    this.walletBalance = 0.0,
    this.remainingBalance = 0.0,
    this.hasShopped = false,
    this.confirmedCashback = 0.0,
    this.pendingCashback = 0.0,
    this.referralEarnings = 0.0,
    this.affiliateEarnings = 0.0,
  });

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
    String? referralCode,
    String? referredBy,
    int? coins,
    double? walletBalance,
    double? remainingBalance,
    bool? hasShopped,
    double? confirmedCashback,
    double? pendingCashback,
    double? referralEarnings,
    double? affiliateEarnings,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      referralCode: referralCode ?? this.referralCode,
      referredBy: referredBy ?? this.referredBy,
      coins: coins ?? this.coins,
      walletBalance: walletBalance ?? this.walletBalance,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      hasShopped: hasShopped ?? this.hasShopped,
      confirmedCashback: confirmedCashback ?? this.confirmedCashback,
      pendingCashback: pendingCashback ?? this.pendingCashback,
      referralEarnings: referralEarnings ?? this.referralEarnings,
      affiliateEarnings: affiliateEarnings ?? this.affiliateEarnings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'referralCode': referralCode,
      'referredBy': referredBy,
      'coins': coins,
      'walletBalance': walletBalance,
      'remainingBalance': remainingBalance > 0.0 ? remainingBalance : walletBalance,
      'hasShopped': hasShopped,
      'confirmedCashback': confirmedCashback,
      'pendingCashback': pendingCashback,
      'referralEarnings': referralEarnings,
      'affiliateEarnings': affiliateEarnings,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {String? defaultUid}) {
    int parsedCoins = 0;
    if (map['coins'] != null) {
      if (map['coins'] is int) {
        parsedCoins = map['coins'] as int;
      } else {
        parsedCoins = int.tryParse(map['coins'].toString()) ?? 0;
      }
    }

    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is double) return val;
      if (val is int) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    final parsedWalletBalance = parseDouble(map['walletBalance'] ?? map['wallet_balance'] ?? map['balance']);
    final parsedRemainingBalance = parseDouble(map['remainingBalance'] ?? map['remaining_balance'] ?? map['remaining_amount'] ?? parsedWalletBalance);
    final parsedConfirmed = parseDouble(map['confirmedCashback'] ?? map['confirmed_cashback']);
    final parsedPending = parseDouble(map['pendingCashback'] ?? map['pending_cashback']);
    final parsedReferralEarnings = parseDouble(map['referralEarnings'] ?? map['referral_earnings']);
    final parsedAffiliateEarnings = parseDouble(map['affiliateEarnings'] ?? map['affiliate_earnings']);

    final hasShoppedVal = map['hasShopped'] ?? map['has_shopped'];
    final parsedHasShopped = hasShoppedVal is bool
        ? hasShoppedVal
        : (hasShoppedVal?.toString().toLowerCase() == 'true');

    return UserModel(
      uid: map['uid'] as String? ?? map['id'] as String? ?? defaultUid ?? '',
      fullName: map['fullName'] as String? ?? map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ??
          map['phone_number'] as String? ??
          map['phone'] as String? ??
          '',
      avatarUrl: map['avatarUrl'] as String? ??
          map['avatar_url'] as String? ??
          map['photoUrl'] as String?,
      referralCode: map['referralCode'] as String? ??
          map['referral_code'] as String? ??
          '',
      referredBy: map['referredBy'] as String? ?? map['referred_by'] as String?,
      coins: parsedCoins > 0 ? parsedCoins : parsedWalletBalance.round(),
      walletBalance: parsedWalletBalance,
      remainingBalance: parsedRemainingBalance,
      hasShopped: parsedHasShopped,
      confirmedCashback: parsedConfirmed,
      pendingCashback: parsedPending,
      referralEarnings: parsedReferralEarnings,
      affiliateEarnings: parsedAffiliateEarnings,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, referralCode: $referralCode, referredBy: $referredBy, walletBalance: $walletBalance, hasShopped: $hasShopped, confirmedCashback: $confirmedCashback, pendingCashback: $pendingCashback, referralEarnings: $referralEarnings, coins: $coins)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.fullName == fullName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.referralCode == referralCode &&
        other.referredBy == referredBy &&
        other.walletBalance == walletBalance &&
        other.hasShopped == hasShopped &&
        other.confirmedCashback == confirmedCashback &&
        other.pendingCashback == pendingCashback &&
        other.referralEarnings == referralEarnings &&
        other.coins == coins;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        referralCode.hashCode ^
        referredBy.hashCode ^
        walletBalance.hashCode ^
        hasShopped.hashCode ^
        confirmedCashback.hashCode ^
        pendingCashback.hashCode ^
        referralEarnings.hashCode ^
        coins.hashCode;
  }
}
