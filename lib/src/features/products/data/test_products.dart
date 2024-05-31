import 'package:riverpod_ecommerce_app_firebase/src/features/products/domain/product.dart';

/// Test products to be used until a data source is implemented
const kTestProducts = [
  Product(
    id: '1',
    imageUrls: [
      'assets/products/bruschetta-plate.jpg',
      'assets/products/bruschetta-plate.jpg',
      'assets/products/bruschetta-plate.jpg',
    ],
    title: 'Bruschetta plate',
    description: 'Lorem ipsum',
    price: 15,
    availableQuantity: 5,
  ),
  Product(
    id: '2',
    imageUrls: [
      'assets/products/mozzarella-plate.jpg',
      'assets/products/mozzarella-plate.jpg',
      'assets/products/mozzarella-plate.jpg'
    ],
    title: 'Mozzarella plate',
    description: 'Lorem ipsum',
    price: 13,
    availableQuantity: 5,
  ),
  Product(
    id: '3',
    imageUrls: ['assets/products/pasta-plate.jpg'],
    title: 'Pasta plate',
    description: 'Lorem ipsum',
    price: 17,
    availableQuantity: 5,
  ),
  Product(
    id: '4',
    imageUrls: ['assets/products/piggy-blue.jpg'],
    title: 'Piggy Bank Blue',
    description: 'Lorem ipsum',
    price: 12,
    availableQuantity: 5,
  ),
  Product(
    id: '5',
    imageUrls: ['assets/products/piggy-green.jpg'],
    title: 'Piggy Bank Green',
    description: 'Lorem ipsum',
    price: 12,
    availableQuantity: 10,
  ),
  Product(
    id: '6',
    imageUrls: ['assets/products/piggy-pink.jpg'],
    title: 'Piggy Bank Pink',
    description: 'Lorem ipsum',
    price: 12,
    availableQuantity: 10,
  ),
  Product(
    id: '7',
    imageUrls: ['assets/products/pizza-plate.jpg'],
    title: 'Pizza plate',
    description: 'Lorem ipsum',
    price: 18,
    availableQuantity: 10,
  ),
  Product(
    id: '8',
    imageUrls: ['assets/products/plate-and-bowl.jpg'],
    title: 'Plate and Bowl',
    description: 'Lorem ipsum',
    price: 21,
    availableQuantity: 10,
  ),
  Product(
    id: '9',
    imageUrls: ['assets/products/salt-pepper-lemon.jpg'],
    title: 'Salt and pepper lemon',
    description: 'Lorem ipsum',
    price: 11,
    availableQuantity: 10,
  ),
  Product(
    id: '10',
    imageUrls: ['assets/products/salt-pepper-olives.jpg'],
    title: 'Salt and pepper olives',
    description: 'Lorem ipsum',
    price: 11,
    availableQuantity: 10,
  ),
  Product(
    id: '11',
    imageUrls: ['assets/products/snacks-plate.jpg'],
    title: 'Snacks plate',
    description: 'Lorem ipsum',
    price: 24,
    availableQuantity: 10,
  ),
  Product(
    id: '12',
    imageUrls: ['assets/products/flowers-plate.jpg'],
    title: 'Flowers plate',
    description: 'Lorem ipsum',
    price: 22,
    availableQuantity: 10,
  ),
  Product(
    id: '13',
    imageUrls: ['assets/products/juicer-citrus-fruits.jpg'],
    title: 'Juicer for citrus fruits',
    description: 'Lorem ipsum',
    price: 14,
    availableQuantity: 10,
  ),
  Product(
    id: '14',
    imageUrls: ['assets/products/honey-pot.jpg'],
    title: 'Honey pot',
    description: 'Lorem ipsum',
    price: 16,
    availableQuantity: 10,
  ),
];
