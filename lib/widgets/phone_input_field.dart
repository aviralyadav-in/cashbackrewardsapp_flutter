import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/country.dart';
import '../theme/app_theme.dart';
import 'country_picker_modal.dart';

class PhoneInputWithCountrySelector extends StatelessWidget {
  final TextEditingController controller;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final String? Function(String?)? validator;
  final ValueKey? inputKey;
  final bool enabled;

  const PhoneInputWithCountrySelector({
    super.key,
    required this.controller,
    required this.selectedCountry,
    required this.onCountryChanged,
    this.validator,
    this.inputKey,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country Selector Tile
        GestureDetector(
          onTap: enabled
              ? () {
                  CountryPickerModal.show(
                    context,
                    selectedCountry: selectedCountry,
                    onSelectCountry: onCountryChanged,
                  );
                }
              : null,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedCountry.flag,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 6),
                Text(
                  selectedCountry.dialCode,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Phone Input Field
        Expanded(
          child: TextFormField(
            key: inputKey,
            controller: controller,
            keyboardType: TextInputType.number,
            enabled: enabled,
            maxLength: 10,
            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            style: TextStyle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: '10-digit phone number',
              labelStyle: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
              hintStyle: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
              ),
              filled: true,
              fillColor: isDark ? AppColors.darkCard : AppColors.cardBackground,
              prefixIcon: Icon(
                Icons.phone_outlined,
                color: isDark ? AppColors.darkTextSecondary : AppColors.primaryBrown,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkPrimary : AppColors.primaryBrown,
                  width: 1.5,
                ),
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
