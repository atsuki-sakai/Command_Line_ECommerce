import 'dart:io';
import 'dart:math' as math;

int get Uid => math.Random().nextInt(999999);

class Product {
  @override
  String toString() {
    return 'Product(id: $id: $name, price: $price)';
  }

  Product({required this.name, required this.price});
  final int _id = Uid;
  final String name;
  final double price;

  int get id => _id;
  String get displayName =>
      '${initial} ${name.substring(1)} price : ${price.round()}円';
  String get initial => name.substring(0, 1);
}

class Item {
  @override
  String toString() {
    return '${product.name},  $price * $quantity';
  }

  Item({required this.product, this.quantity = 1});
  final int _id = Uid;
  final Product product;
  final int quantity;

  int get id => _id;
  double get price => product.price * quantity;
}

class Cart {
  Map<int, Item> _items = {};

  bool get isEmpty => _items.isEmpty;
  double total() {
    return _items.values
        .map((item) => item.price)
        .reduce((value, element) => value + element);
  }

  void addProduct(Product product) {
    final item = _items[product.id];
    if (item == null) {
      _items[product.id] = Item(product: product, quantity: 1);
    } else {
      _items[product.id] = Item(product: product, quantity: item.quantity + 1);
    }
  }

  @override
  String toString() {
    if (_items.isEmpty) return 'Cart is Empty';
    final itemizedList =
        _items.values.map((item) => item.toString()).join('\n');
    return ' ------ \n $itemizedList = Toral: ${total().round()}円 \n -----';
  }

  void remove(Product product) {
    _items.remove(product.id);
  }
}

final allProducts = [
  Product(name: 'Banana', price: 120.0),
  Product(name: 'Orenge', price: 80.0),
  Product(name: 'Melon', price: 220.0),
  Product(name: 'Ice Cream', price: 100.0),
  Product(name: 'Chiken', price: 360.0)
];
Product? chooseProduct() {
  final productLists =
      allProducts.map((product) => product.displayName).join('\n');
  print(' ----- ------');
  stdout.write(
      'Available products: \n ----- \n $productLists \n ----- \nYour choice: ');

  final line = stdin.readLineSync();
  for (var product in allProducts) {
    if (product.initial == line) {
      return product;
    }
  }
  print('Not Found');
  return null;
}

bool? checkOut() {
  if (cart.isEmpty) {
    print('Cart is Empty');
    return false;
  } else {
    print('Thank you payment completed.');
    print('合計 :${cart.total().round()}円');
    print(' ------- ');
    return true;
  }
}

final cart = Cart();
void main() {
  while (true) {
    stdout.write(
        'What do you want to do? (v)iwe products, (a)dd product, (c)heck out, (m)myCart, (e)nd./');
    final line = stdin.readLineSync();
    if (line == 'v') {
      final allProductsName =
          allProducts.map((Product) => Product.displayName).join('\n');

      print('------- \n $allProductsName');

      print(' ------- \n view all menus. \n -------');
    } else if (line == 'a') {
      final product = chooseProduct();
      if (product != null) {
        stdout.write('add in cart? y/n');
        final ans = stdin.readLineSync();
        if (ans == 'y') {
          cart.addProduct(product);

          print('Thank you item in cart.');
        } else {
          continue;
        }
      }
    } else if (line == 'c') {
      checkOut();
    } else if (line == 'e') {
      print('closed system.');
      break;
    } else if (line == 'm') {
      cart._items.values.forEach((element) {
        print(element.product.displayName);
      });
      stdout.write('remove for cart item? y/n');
      final line = stdin.readLineSync();
      if (line == 'y') {
        for (var myitem in cart._items.values) {
          print('${myitem.product.displayName}');
        }
        stdout.write('select remove item: ');
        final line = stdin.readLineSync();
        final mycart = cart._items;
        final deleteItem = mycart.values
            .map((e) => e.product)
            .where((element) => element.initial == line)
            .first;
        cart.remove(deleteItem);
        print('----- Update MyCart. ----- ');
        print(cart.toString());
      } else if (line == 'n') {
        continue;
      }
    } else {
      print('input is valid.');
    }
  }
}
