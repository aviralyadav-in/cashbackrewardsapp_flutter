class Country {
  final String name;
  final String code;
  final String dialCode;
  final String flag;
  final int minDigits;
  final int maxDigits;

  const Country({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.flag,
    this.minDigits = 10,
    this.maxDigits = 10,
  });

  /// User-friendly hint text (e.g. "10-digit phone number" or "9-10 digit phone number")
  String get digitsHint {
    if (minDigits == maxDigits) {
      return '$maxDigits-digit phone number';
    }
    return '$minDigits-$maxDigits digit phone number';
  }

  /// User-friendly validation error message
  String get validationErrorText {
    if (minDigits == maxDigits) {
      return 'Please enter valid $maxDigits-digit phone number';
    }
    return 'Please enter valid $minDigits-$maxDigits digit phone number';
  }

  /// Checks whether a given raw or cleaned phone string satisfies this country's length constraints
  bool isValidLength(String rawPhone) {
    final clean = rawPhone.replaceAll(RegExp(r'\D'), '');
    return clean.length >= minDigits && clean.length <= maxDigits;
  }

  static const Country defaultCountry = Country(
    name: 'India',
    code: 'IN',
    dialCode: '+91',
    flag: '🇮🇳',
    minDigits: 10,
    maxDigits: 10,
  );

  static const List<Country> allCountries = [
    Country(name: 'India', code: 'IN', dialCode: '+91', flag: '🇮🇳', minDigits: 10, maxDigits: 10),
    Country(name: 'United States', code: 'US', dialCode: '+1', flag: '🇺🇸', minDigits: 10, maxDigits: 10),
    Country(name: 'United Kingdom', code: 'GB', dialCode: '+44', flag: '🇬🇧', minDigits: 10, maxDigits: 11),
    Country(name: 'Canada', code: 'CA', dialCode: '+1', flag: '🇨🇦', minDigits: 10, maxDigits: 10),
    Country(name: 'Australia', code: 'AU', dialCode: '+61', flag: '🇦🇺', minDigits: 9, maxDigits: 9),
    Country(name: 'United Arab Emirates', code: 'AE', dialCode: '+971', flag: '🇦🇪', minDigits: 9, maxDigits: 9),
    Country(name: 'Saudi Arabia', code: 'SA', dialCode: '+966', flag: '🇸🇦', minDigits: 9, maxDigits: 9),
    Country(name: 'Singapore', code: 'SG', dialCode: '+65', flag: '🇸🇬', minDigits: 8, maxDigits: 8),
    Country(name: 'Germany', code: 'DE', dialCode: '+49', flag: '🇩🇪', minDigits: 10, maxDigits: 11),
    Country(name: 'France', code: 'FR', dialCode: '+33', flag: '🇫🇷', minDigits: 9, maxDigits: 9),
    Country(name: 'Japan', code: 'JP', dialCode: '+81', flag: '🇯🇵', minDigits: 10, maxDigits: 10),
    Country(name: 'China', code: 'CN', dialCode: '+86', flag: '🇨🇳', minDigits: 11, maxDigits: 11),
    Country(name: 'Brazil', code: 'BR', dialCode: '+55', flag: '🇧🇷', minDigits: 10, maxDigits: 11),
    Country(name: 'Mexico', code: 'MX', dialCode: '+52', flag: '🇲🇽', minDigits: 10, maxDigits: 10),
    Country(name: 'South Africa', code: 'ZA', dialCode: '+27', flag: '🇿🇦', minDigits: 9, maxDigits: 9),
    Country(name: 'Nigeria', code: 'NG', dialCode: '+234', flag: '🇳🇬', minDigits: 10, maxDigits: 10),
    Country(name: 'Pakistan', code: 'PK', dialCode: '+92', flag: '🇵🇰', minDigits: 10, maxDigits: 10),
    Country(name: 'Bangladesh', code: 'BD', dialCode: '+880', flag: '🇧🇩', minDigits: 10, maxDigits: 10),
    Country(name: 'Nepal', code: 'NP', dialCode: '+977', flag: '🇳🇵', minDigits: 10, maxDigits: 10),
    Country(name: 'Sri Lanka', code: 'LK', dialCode: '+94', flag: '🇱🇰', minDigits: 9, maxDigits: 9),
    Country(name: 'Malaysia', code: 'MY', dialCode: '+60', flag: '🇲🇾', minDigits: 9, maxDigits: 10),
    Country(name: 'Indonesia', code: 'ID', dialCode: '+62', flag: '🇮🇩', minDigits: 9, maxDigits: 12),
    Country(name: 'Thailand', code: 'TH', dialCode: '+66', flag: '🇹🇭', minDigits: 9, maxDigits: 9),
    Country(name: 'Vietnam', code: 'VN', dialCode: '+84', flag: '🇻🇳', minDigits: 9, maxDigits: 9),
    Country(name: 'Philippines', code: 'PH', dialCode: '+63', flag: '🇵🇭', minDigits: 10, maxDigits: 10),
    Country(name: 'Russia', code: 'RU', dialCode: '+7', flag: '🇷🇺', minDigits: 10, maxDigits: 10),
    Country(name: 'Italy', code: 'IT', dialCode: '+39', flag: '🇮🇹', minDigits: 9, maxDigits: 10),
    Country(name: 'Spain', code: 'ES', dialCode: '+34', flag: '🇪🇸', minDigits: 9, maxDigits: 9),
    Country(name: 'Netherlands', code: 'NL', dialCode: '+31', flag: '🇳🇱', minDigits: 9, maxDigits: 9),
    Country(name: 'Switzerland', code: 'CH', dialCode: '+41', flag: '🇨🇭', minDigits: 9, maxDigits: 9),
    Country(name: 'New Zealand', code: 'NZ', dialCode: '+64', flag: '🇳🇿', minDigits: 8, maxDigits: 10),
    Country(name: 'Qatar', code: 'QA', dialCode: '+974', flag: '🇶🇦', minDigits: 8, maxDigits: 8),
    Country(name: 'Kuwait', code: 'KW', dialCode: '+965', flag: '🇰🇼', minDigits: 8, maxDigits: 8),
    Country(name: 'Oman', code: 'OM', dialCode: '+968', flag: '🇴🇲', minDigits: 8, maxDigits: 8),
    Country(name: 'Bahrain', code: 'BH', dialCode: '+973', flag: '🇧🇭', minDigits: 8, maxDigits: 8),
    Country(name: 'Egypt', code: 'EG', dialCode: '+20', flag: '🇪🇬', minDigits: 10, maxDigits: 10),
    Country(name: 'Turkey', code: 'TR', dialCode: '+90', flag: '🇹🇷', minDigits: 10, maxDigits: 10),
    Country(name: 'South Korea', code: 'KR', dialCode: '+82', flag: '🇰🇷', minDigits: 9, maxDigits: 10),
    Country(name: 'Hong Kong', code: 'HK', dialCode: '+852', flag: '🇭🇰', minDigits: 8, maxDigits: 8),
    Country(name: 'Ireland', code: 'IE', dialCode: '+353', flag: '🇮🇪', minDigits: 9, maxDigits: 9),
    Country(name: 'Sweden', code: 'SE', dialCode: '+46', flag: '🇸🇪', minDigits: 9, maxDigits: 9),
    Country(name: 'Norway', code: 'NO', dialCode: '+47', flag: '🇳🇴', minDigits: 8, maxDigits: 8),
    Country(name: 'Denmark', code: 'DK', dialCode: '+45', flag: '🇩🇰', minDigits: 8, maxDigits: 8),
    Country(name: 'Finland', code: 'FI', dialCode: '+358', flag: '🇫🇮', minDigits: 9, maxDigits: 10),
    Country(name: 'Poland', code: 'PL', dialCode: '+48', flag: '🇵🇱', minDigits: 9, maxDigits: 9),
    Country(name: 'Portugal', code: 'PT', dialCode: '+351', flag: '🇵🇹', minDigits: 9, maxDigits: 9),
    Country(name: 'Greece', code: 'GR', dialCode: '+30', flag: '🇬🇷', minDigits: 10, maxDigits: 10),
    Country(name: 'Austria', code: 'AT', dialCode: '+43', flag: '🇦🇹', minDigits: 10, maxDigits: 11),
    Country(name: 'Belgium', code: 'BE', dialCode: '+32', flag: '🇧🇪', minDigits: 9, maxDigits: 9),
    Country(name: 'Israel', code: 'IL', dialCode: '+972', flag: '🇮🇱', minDigits: 9, maxDigits: 9),
    Country(name: 'Argentina', code: 'AR', dialCode: '+54', flag: '🇦🇷', minDigits: 10, maxDigits: 10),
    Country(name: 'Chile', code: 'CL', dialCode: '+56', flag: '🇨🇱', minDigits: 9, maxDigits: 9),
    Country(name: 'Colombia', code: 'CO', dialCode: '+57', flag: '🇨🇴', minDigits: 10, maxDigits: 10),
    Country(name: 'Peru', code: 'PE', dialCode: '+51', flag: '🇵🇪', minDigits: 9, maxDigits: 9),
    Country(name: 'Kenya', code: 'KE', dialCode: '+254', flag: '🇰🇪', minDigits: 9, maxDigits: 9),
  ];
}
