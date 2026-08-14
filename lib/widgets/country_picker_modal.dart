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
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161618),
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
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          const Text(
            'Select Country',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Search Field
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search country or code',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey.shade400),
                      onPressed: () => _searchController.clear(),
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFF242426),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredCountries.length,
                    separatorBuilder: (context, index) =>
                        Divider(height: 1, color: Colors.grey.shade800),
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
                            color: Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              country.dialCode,
                              style: TextStyle(
                                color: isSelected ? Colors.redAccent : Colors.grey.shade400,
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
