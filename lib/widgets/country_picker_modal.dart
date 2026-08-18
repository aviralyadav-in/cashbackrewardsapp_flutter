import 'package:flutter/material.dart';
import '../models/country.dart';

class CountryPickerModal extends StatefulWidget {
  final ValueChanged<Country> onSelectCountry;
  final Country? initialSelectedCountry;

  const CountryPickerModal({
    super.key,
    required this.onSelectCountry,
    this.initialSelectedCountry,
  });

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<Country> onSelectCountry,
    Country? selectedCountry,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF161618) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return CountryPickerModal(
          onSelectCountry: onSelectCountry,
          initialSelectedCountry: selectedCountry,
        );
      },
    );
  }

  @override
  State<CountryPickerModal> createState() => _CountryPickerModalState();
}

class _CountryPickerModalState extends State<CountryPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  List<Country> _filteredCountries = Country.allCountries;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = Country.allCountries;
      } else {
        _filteredCountries = Country.allCountries.where((country) {
          final nameMatch = country.name.toLowerCase().contains(query);
          final codeMatch = country.code.toLowerCase().contains(query);
          final dialMatch = country.dialCode.contains(query);
          return nameMatch || codeMatch || dialMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: mediaQuery.size.height * 0.75,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: bottomInset + 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            'Select Country',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // Search Field
          TextField(
            controller: _searchController,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              hintText: 'Search country or code',
              hintStyle: TextStyle(
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                      onPressed: () => _searchController.clear(),
                    )
                  : null,
              filled: true,
              fillColor: isDark ? const Color(0xFF242426) : const Color(0xFFF0F2F5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF2E2E2E) : const Color(0xFFE5E5EA),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF2E2E2E) : const Color(0xFFE5E5EA),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.redAccent, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Country List
          Expanded(
            child: _filteredCountries.isEmpty
                ? Center(
                    child: Text(
                      'No countries found',
                      style: TextStyle(
                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredCountries.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                    ),
                    itemBuilder: (context, index) {
                      final country = _filteredCountries[index];
                      final isSelected =
                          widget.initialSelectedCountry?.code == country.code;

                      return ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.onSelectCountry(country);
                        },
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        leading: Text(
                          country.flag,
                          style: const TextStyle(fontSize: 26),
                        ),
                        title: Text(
                          '${country.name} (${country.code})',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              country.dialCode,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.redAccent
                                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check_circle,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
