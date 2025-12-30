import 'dart:math';

class MockProduct {
  final int id;
  final String productName;
  final String imagePath;
  final double rating;
  final int reviews;
  final num price;
  final num? discountPrice;
  final num? discountInPercent;
  final bool inStock;

  const MockProduct({
    required this.id,
    required this.productName,
    required this.imagePath,
    required this.rating,
    required this.reviews,
    required this.price,
    this.discountPrice,
    this.discountInPercent,
    this.inStock = true,
  });
}

final _random = Random();
double _randomRating() => (3 + _random.nextDouble() * 2).toDouble();
int _randomReviews() => 50 + _random.nextInt(450);
num _randomPrice() => 10 + _random.nextInt(90);
num _randomDiscountPrice(num price) {
  return price - (price * (_randomDiscountInPercent() / 100));
}

num _randomDiscountInPercent() => _random.nextInt(30);

List<MockProduct> eCommerceMockproducts = [
  (
    "All Natural Italian-Style Chicken Meatballs",
    "assets/images/static_images/product_images/product_image_15.jpeg"
  ),
  (
    "Apple iPhone 11 64GB Yellow Fully Unlocked",
    "assets/images/static_images/product_images/product_image_16.png"
  ),
  (
    "Organic Sweet Lime / Mosambi",
    "assets/images/static_images/product_images/product_image_17.png"
  ),
  (
    "Pepperidge Farm Farmhouse Hearty White Bread",
    "assets/images/static_images/product_images/product_image_18.jpeg"
  ),
  (
    "Organic Green Seedless Grapes",
    "assets/images/static_images/product_images/product_image_19.png"
  ),
  (
    "Lemon Cream Crunch Cookies",
    "assets/images/static_images/product_images/product_image_20.png"
  ),
  (
    "Best Bluetooth Headphone",
    "assets/images/static_images/product_images/product_image_21.png"
  ),
  (
    "Apple TV HD 32GB (2nd Generation)",
    "assets/images/static_images/product_images/product_image_22.png"
  ),
  (
    "Premium Cavendish Banana",
    "assets/images/static_images/product_images/product_image_23.jpeg"
  ),
  (
    "All Natural Italian-Style Chicken Meatballs",
    "assets/images/static_images/product_images/product_image_24.png"
  ),
  (
    "Apple TV HD 32GB (2nd Generation)",
    "assets/images/static_images/product_images/product_image_22.png"
  ),
  (
    "All Natural Italian-Style Chicken Meatballs",
    "assets/images/static_images/product_images/product_image_24.png"
  ),
].asMap().entries.map((item) {
  final price = _randomPrice();
  final discountPrice = _randomDiscountPrice(price);
  return MockProduct(
    id: item.key + 1,
    productName: item.value.$1,
    imagePath: item.value.$2,
    rating: _randomRating(),
    reviews: _randomReviews(),
    price: price,
    discountPrice: discountPrice,
    discountInPercent: (100 * (price - discountPrice) / price),
    inStock: _random.nextBool(),
  );
}).toList();
