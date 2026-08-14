import 'package:flutter/material.dart';
import '../models/country.dart';
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
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF2E2E2E)),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey.shade400,
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
            keyboardType: TextInputType.phone,
            enabled: enabled,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: '10-digit phone number',
              labelStyle: TextStyle(color: Colors.grey.shade400),
              hintStyle: TextStyle(color: Colors.grey.shade600),
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
              prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 2,
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
