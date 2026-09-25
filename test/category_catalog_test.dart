import 'package:cashback_reward_app/data/category_catalog.dart';
import 'package:cashback_reward_app/services/app_cashback_engine.dart';
import 'package:cashback_reward_app/services/category_shopping_service.dart';
import 'package:flutter_test/flutter_test.dart';

String _tag(String v) => v.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

void main() {
  // Every categoryId the app navigates with (Home top categories, All
  // Categories grid/list, deep links and aliases).
  const entryCategoryIds = [
    'fashion', 'electronics', 'travel', 'food', 'beauty', 'grocery',
    'credit_cards', 'home_living', 'groceries', 'sports', 'footwear',
    'automotive', 'cards', 'mobiles', 'food_groceries', 'beauty_grooming',
    'home_kitchen',
  ];

  // Subcategory shortcuts from the All Categories screen.
  const entrySubcategories = {
    'fashion': ['womens-bags', 'sunglasses'],
    'beauty': ['fragrances', 'skin-care'],
    'home_living': ['kitchen-accessories', 'furniture'],
  };

  group('Category screen', () {
    for (final id in entryCategoryIds) {
      test('$id resolves to its own category with products', () {
        final canonical = CategoryCatalog.canonicalCategoryId(id);
        expect(CategoryCatalog.hasCategory(id), isTrue, reason: '$id has no definition');

        final detail = CategoryShoppingService.getFallbackCategoryDetail(id);
        expect(detail.category.id, canonical);
        expect(detail.bestDeals, isNotEmpty);
      });
    }
  });

  group('Subcategory screen', () {
    for (final id in entryCategoryIds.map(CategoryCatalog.canonicalCategoryId).toSet()) {
      final def = CategoryCatalog.definitionFor(id)!;
      final categoryIds =
          CategoryShoppingService.getFallbackCategoryDetail(id).bestDeals.map((d) => d.id).toSet();

      for (final sub in def.subcategories) {
        test('$id > ${sub.id} shows only its own products', () {
          final res = CategoryShoppingService.getFallbackSubcategoryDetail(id, sub.id);
          expect(res.products, isNotEmpty, reason: '$id > ${sub.id} is empty');
          expect(res.subcategory.categoryId, id);

          for (final p in res.products) {
            expect(categoryIds, contains(p.id), reason: '${p.id} not in $id');
            final inSub = _tag(p.subcategoryId ?? '') == _tag(sub.id) ||
                _tag(p.gender ?? '') == _tag(sub.id);
            expect(inSub, isTrue, reason: '${p.id} is not in ${sub.id}');
          }

          // Every filter chip must show at least one product.
          for (final f in res.filters.where((f) => f != 'All')) {
            final hits = res.products.where((p) =>
                _tag(p.productType ?? '') == _tag(f) ||
                _tag(p.subcategoryId ?? '') == _tag(f) ||
                _tag(p.gender ?? '') == _tag(f));
            expect(hits, isNotEmpty, reason: 'chip "$f" in $id > ${sub.id} is empty');
          }
        });
      }
    }

    entrySubcategories.forEach((cat, subs) {
      for (final sub in subs) {
        test('All Categories shortcut $cat > $sub has products', () {
          final res = CategoryShoppingService.getFallbackSubcategoryDetail(cat, sub);
          expect(res.products, isNotEmpty);
        });
      }
    });

    test('every catalog product is reachable from a subcategory', () {
      final reachable = <String>{};
      for (final id in entryCategoryIds.map(CategoryCatalog.canonicalCategoryId).toSet()) {
        for (final sub in CategoryCatalog.definitionFor(id)!.subcategories) {
          reachable.addAll(
            CategoryShoppingService.getFallbackSubcategoryDetail(id, sub.id).products.map((p) => p.id),
          );
        }
        final all = CategoryShoppingService.getFallbackCategoryDetail(id).bestDeals.map((d) => d.id);
        for (final pid in all) {
          expect(reachable, contains(pid), reason: '$pid in $id is in no subcategory');
        }
      }
    });
  });

  group('Brand offer vs app cashback', () {
    test('app cashback uses smart deal engine rates, brand discount untouched', () {
      final shirt = CategoryCatalog.productsFor('fashion', subcategoryId: 'clothing')
          .firstWhere((p) => p.id == 'prod-shirt-1');
      expect(shirt.cashbackPercentage, AppCashbackEngine.rateForStore('Myntra'));
      expect(shirt.cashbackPercentage, 10);
      expect(shirt.discountPercentage, 40); // 2999 -> 1799 is the brand's offer
    });

    test('store names are normalised like the backend', () {
      expect(AppCashbackEngine.rateForStore('Tata CLiQ'), 8);
      expect(AppCashbackEngine.rateForStore('H&M'), 8);
      expect(AppCashbackEngine.rateForStore('Unknown Store'), 5);
    });

    test('store offer text is not labelled as cashback', () {
      expect(storeOfferLabel('Up to 12% Cashback'), 'Up to 12% Reward');
      expect(storeOfferLabel('Flat ₹1,500 Reward'), 'Flat ₹1,500 Reward');
      expect(storeOfferLabel('Up to 12%'), 'Up to 12% Reward');
    });
  });
}
