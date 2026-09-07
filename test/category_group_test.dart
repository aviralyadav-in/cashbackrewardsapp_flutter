import 'package:flutter_test/flutter_test.dart';
import 'package:cashback_reward_app/models/category_group_model.dart';
import 'package:cashback_reward_app/providers/category_provider.dart';

void main() {
  group('CategoryGroupModel Tests', () {
    test('Fashion department contains men shirts, women dresses, tops, shoes, bags and jewellery', () {
      final fashion = CategoryGroup.fashion;
      final slugs = fashion.allSlugs;

      expect(slugs.contains('mens-shirts'), isTrue);
      expect(slugs.contains('womens-dresses'), isTrue);
      expect(slugs.contains('tops'), isTrue);
      expect(slugs.contains('womens-bags'), isTrue);
      expect(slugs.contains('womens-jewellery'), isTrue);
      expect(slugs.contains('mens-shoes'), isTrue);
      expect(slugs.contains('womens-shoes'), isTrue);
      expect(slugs.contains('sunglasses'), isTrue);
    });

    test('Electronics department contains smartphones, laptops, tablets, and accessories', () {
      final electronics = CategoryGroup.electronics;
      final slugs = electronics.allSlugs;

      expect(slugs.contains('smartphones'), isTrue);
      expect(slugs.contains('laptops'), isTrue);
      expect(slugs.contains('tablets'), isTrue);
      expect(slugs.contains('mobile-accessories'), isTrue);
    });

    test('findGroupForSlug correctly resolves subcategories to their parent department', () {
      expect(CategoryGroup.findGroupForSlug('womens-dresses').id, 'fashion');
      expect(CategoryGroup.findGroupForSlug('laptops').id, 'electronics');
      expect(CategoryGroup.findGroupForSlug('furniture').id, 'home_living');
      expect(CategoryGroup.findGroupForSlug('groceries').id, 'groceries');
      expect(CategoryGroup.findGroupForSlug('sports-accessories').id, 'sports');
    });

    test('CategoryGroup has no duplicate groups', () {
      final groupIds = CategoryGroup.allGroups.map((g) => g.id).toList();
      final uniqueGroupIds = groupIds.toSet();

      expect(groupIds.length, uniqueGroupIds.length);
    });
  });

  group('CategoryProvider Subcategory Filtering Tests', () {
    test('Initial selection defaults to fashion and View All (all)', () {
      final provider = CategoryProvider();
      expect(provider.selectedGroup.id, 'fashion');
      expect(provider.selectedSubcategorySlug, 'all');
    });

    test('selectSubcategory updates active subcategory in memory', () {
      final provider = CategoryProvider();
      provider.selectSubcategory('womens-dresses');
      expect(provider.selectedSubcategorySlug, 'womens-dresses');

      provider.selectSubcategory('all');
      expect(provider.selectedSubcategorySlug, 'all');
    });

    test('categoryGroups always places selectedGroup at index 0', () {
      final provider = CategoryProvider();
      // Default selection is fashion, so index 0 should be fashion
      expect(provider.categoryGroups.first.id, 'fashion');

      // Change selection to electronics
      provider.selectedGroup = CategoryGroup.electronics;
      expect(provider.categoryGroups.first.id, 'electronics');

      // Change selection to groceries
      provider.selectedGroup = CategoryGroup.groceries;
      expect(provider.categoryGroups.first.id, 'groceries');
      expect(provider.categoryGroups.length, CategoryGroup.allGroups.length);

      // Verify no duplicates
      final ids = provider.categoryGroups.map((g) => g.id).toSet();
      expect(ids.length, CategoryGroup.allGroups.length);
    });
  });
}
