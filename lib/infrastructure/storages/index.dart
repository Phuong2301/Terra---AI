//import 'package:app_mobile/application/admin/app_product.dart';
//import 'package:app_mobile/application/factory_admin/app_formula.dart';
import 'package:app_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:app_mobile/domain/fetch_data/models/base_nextpage_model.dart';
//import 'package:app_mobile/domain/models/admin/product_model.dart';
//mport 'package:app_mobile/domain/models/formula_ingredient/formula_ingredient_model.dart';

class Storage {
  Storage._privateConstructor();
  static final Storage instance = Storage._privateConstructor();

  //final product = FData<MProduct>(fetch: AppProduct.fetch());

  // final formulaIngredientDDown = FData<DFormulaIngredient>(
  //     fetch: AppFormula.fetchListToCreateProductionPlanning());
}

class FData<T> extends FetchingNextPage<T> {
  final Future<MBaseNextPage<T>?> fetch;

  FData({
    required this.fetch,
  });

  @override
  Future<MBaseNextPage<T>?> getApiNextPage() async {
    return await fetch;
  }
}
