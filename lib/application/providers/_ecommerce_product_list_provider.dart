import 'package:flutter/material.dart';
import '../../domain/models/models.dart' show eCommerceMockproducts, MockProduct;
export '../../domain/models/models.dart' show MockProduct;

class ECommerceMockProductsNotifier extends ChangeNotifier {
  ECommerceMockProductsNotifier()
      : fakeApiProducts = List.from(eCommerceMockproducts.take(10));

  final _baseList = [
    ...eCommerceMockproducts,
    ...eCommerceMockproducts.reversed,
  ];
  int get totalProducts => _baseList.length;
  List<MockProduct> fakeApiProducts = [];
  final cartProducts = <int>[];

  final favoriteProducts = <int>[];
  void addToFav(int id) {
    final _alreadyAdded = favoriteProducts.any((eId) => eId == id);
    _alreadyAdded ? favoriteProducts.remove(id) : favoriteProducts.add(id);
    notifyListeners();
  }

  // Pagination function
  void loadProductsForPage(int pageNumber, int itemsPerPage) {
    final skip = (pageNumber - 1) * itemsPerPage;
    fakeApiProducts = _baseList.skip(skip).take(itemsPerPage).toList();
    notifyListeners();
  }
}
