import 'package:flutter_test/flutter_test.dart';
import 'package:cashback_reward_app/models/user_model.dart';

void main() {
  group('UserModel Serialization & Wallet Tests', () {
    test('Correctly maps from PostgreSQL JSON response format', () {
      final postgresMap = {
        'id': 'usr_1234567890abcdef',
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'phone_number': '+919876543210',
        'created_at': '2026-09-09T10:00:00.000Z',
        'updated_at': '2026-09-09T10:00:00.000Z',
      };

      final user = UserModel.fromMap(postgresMap);

      expect(user.uid, equals('usr_1234567890abcdef'));
      expect(user.fullName, equals('John Doe'));
      expect(user.email, equals('john.doe@example.com'));
      expect(user.phoneNumber, equals('+919876543210'));
      expect(user.walletBalance, equals(0.0));
      expect(user.hasShopped, isFalse);
    });

    test('New user without referral or shopping has zero wallet balance', () {
      final newUserData = {
        'id': 'usr_new_user_1',
        'name': 'Pooja',
        'email': 'pooja@example.com',
        'phone_number': '+918800000001',
        'wallet_balance': 0.00,
        'has_shopped': false,
        'confirmed_cashback': 0.00,
        'pending_cashback': 0.00,
        'referral_earnings': 0.00,
      };

      final user = UserModel.fromMap(newUserData);

      expect(user.walletBalance, equals(0.0));
      expect(user.hasShopped, isFalse);
      expect(user.confirmedCashback, equals(0.0));
      expect(user.referralEarnings, equals(0.0));
    });

    test('Referee user gets ₹10 welcome cash bonus', () {
      final refereeData = {
        'id': 'usr_referee_1',
        'name': 'Rohan',
        'email': 'rohan@example.com',
        'phone_number': '+917700000002',
        'referral_code': 'ROHA1234',
        'referred_by': 'usr_referrer_1',
        'wallet_balance': 10.00,
        'has_shopped': false,
        'confirmed_cashback': 0.00,
        'referral_earnings': 10.00,
      };

      final user = UserModel.fromMap(refereeData);

      expect(user.walletBalance, equals(10.0));
      expect(user.referralEarnings, equals(10.0));
      expect(user.hasShopped, isFalse);
      expect(user.referredBy, equals('usr_referrer_1'));
    });

    test('Referrer user with 1 invited friend has ₹20 referral cash', () {
      final referrerData = {
        'id': 'usr_referrer_1',
        'name': 'Shivam',
        'email': 'shivam@example.com',
        'phone_number': '+919900000003',
        'referral_code': 'SHIV3186',
        'wallet_balance': 20.00,
        'has_shopped': false,
        'referral_earnings': 20.00,
      };

      final user = UserModel.fromMap(referrerData);

      expect(user.walletBalance, equals(20.0));
      expect(user.referralEarnings, equals(20.0));
    });

    test('Correctly serializes and deserializes to/from JSON string', () {
      const original = UserModel(
        uid: 'usr_test_999',
        fullName: 'Jane Smith',
        email: 'jane@example.com',
        phoneNumber: '+919123456780',
        walletBalance: 10.0,
        referralEarnings: 10.0,
        coins: 10,
      );

      final jsonStr = original.toJson();
      final restored = UserModel.fromJson(jsonStr);

      expect(restored, equals(original));
      expect(restored.uid, 'usr_test_999');
      expect(restored.walletBalance, 10.0);
      expect(restored.referralEarnings, 10.0);
    });

    test('Correctly maps and serializes avatarUrl for Google profiles', () {
      final googleUserMap = {
        'id': 'usr_google_123',
        'name': 'Google User',
        'email': 'guser@gmail.com',
        'avatar_url': 'https://lh3.googleusercontent.com/photo.jpg',
        'wallet_balance': 10.00,
        'referral_earnings': 10.00,
      };

      final user = UserModel.fromMap(googleUserMap);
      expect(user.avatarUrl, 'https://lh3.googleusercontent.com/photo.jpg');
      expect(user.toMap()['avatarUrl'], 'https://lh3.googleusercontent.com/photo.jpg');
    });
  });
}

