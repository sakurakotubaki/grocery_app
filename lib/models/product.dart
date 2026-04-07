/// Demo catalog for the grocery UI mock (bundled asset images).
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageAsset,
  });

  final String id;
  final String name;
  final String category;

  /// e.g. "20.00" — displayed with a leading `$`.
  final String price;

  /// Flutter asset path (see `pubspec.yaml` → `flutter.assets`).
  final String imageAsset;
}

const List<Product> kDemoProducts = [
  Product(
    id: '1',
    name: 'Cabbage',
    category: 'Fruits',
    price: '20.00',
    imageAsset: 'assets/images/img_1.png',
  ),
  Product(
    id: '2',
    name: 'Broccoli',
    category: 'Vegetables',
    price: '12.50',
    imageAsset: 'assets/images/img_2.png',
  ),
  Product(
    id: '3',
    name: 'Carrot',
    category: 'Vegetables',
    price: '8.00',
    imageAsset: 'assets/images/img_3.png',
  ),
  Product(
    id: '4',
    name: 'Pakcoy',
    category: 'Greens',
    price: '6.40',
    imageAsset: 'assets/images/img_4.png',
  ),
  Product(
    id: '5',
    name: 'Cucumber',
    category: 'Vegetables',
    price: '5.20',
    imageAsset: 'assets/images/img_1.png',
  ),
  Product(
    id: '6',
    name: 'Tomato',
    category: 'Fruits',
    price: '9.90',
    imageAsset: 'assets/images/img_2.png',
  ),
];

Product? productById(String id) {
  for (final p in kDemoProducts) {
    if (p.id == id) return p;
  }
  return null;
}

String heroTagForProductImage(String productId) => 'product-image-$productId';
