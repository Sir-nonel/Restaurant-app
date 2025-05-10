import 'menu.dart';

class Cart {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(MenuItem item) {
    final index = _items.indexWhere(
      (element) => element.item.name == item.name,
    );
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(item: item));
    }
  }

  void removeItem(MenuItem item) {
    _items.removeWhere((element) => element.item.name == item.name);
  }

  double get totalPrice => _items.fold(
    0,
    (sum, cartItem) => sum + cartItem.item.price * cartItem.quantity,
  );

  void clear() => _items.clear();
}
