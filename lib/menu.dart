import 'package:flutter/material.dart';
import 'cart.dart';

class MenuItem {
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final String category;

  MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.category,
  });
}

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});
}

class MenuPage extends StatefulWidget {
  final Cart cart;
  final void Function(MenuItem) onAddToCart;

  const MenuPage({required this.cart, required this.onAddToCart, super.key});

  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  String selectedCategory = 'All';

  final List<MenuItem> menuItems = [
    MenuItem(
      name: "Burger",
      description: "Beef burger with cheese and lettuce.",
      price: 8.99,
      imagePath: "assets/images/burger.png",
      category: "Main",
    ),
    MenuItem(
      name: "Pizza",
      description: "Mozzarella and tomato sauce pizza.",
      price: 10.50,
      imagePath: "assets/images/pizza.png",
      category: "Main",
    ),
    MenuItem(
      name: "Caesar Salad",
      description: "Fresh lettuce with Caesar dressing.",
      price: 6.75,
      imagePath: "assets/images/salad.png",
      category: "Starter",
    ),
    MenuItem(
      name: "Strawberry Ice Cream Cake",
      description: "Delicious layered Strawberry Ice Cream Cake.",
      price: 4.50,
      imagePath: "assets/images/dessert.png",
      category: "Dessert",
    ),
    MenuItem(
      name: "Grilled Chicken",
      description: "Spicy grilled chicken breast with herbs.",
      price: 11.99,
      imagePath: "assets/images/grilled_chicken.png",
      category: "Main",
    ),
    MenuItem(
      name: "Fries",
      description: "Crispy golden French fries.",
      price: 3.25,
      imagePath: "assets/images/fries.png",
      category: "Starter",
    ),
    MenuItem(
      name: "Pasta",
      description: "Creamy Alfredo pasta with mushrooms.",
      price: 9.50,
      imagePath: "assets/images/pasta.png",
      category: "Main",
    ),
    MenuItem(
      name: "Ice Cream",
      description: "Vanilla ice cream with chocolate syrup.",
      price: 3.75,
      imagePath: "assets/images/ice_cream.png",
      category: "Dessert",
    ),
    MenuItem(
      name: "Lemonade",
      description: "Refreshing homemade lemonade.",
      price: 2.99,
      imagePath: "assets/images/lemonade.png",
      category: "Drink",
    ),
    MenuItem(
      name: "Coffee",
      description: "Hot brewed coffee with milk option.",
      price: 2.50,
      imagePath: "assets/images/coffee.png",
      category: "Drink",
    ),
  ];

  List<String> get categories => [
    'All',
    ...{...menuItems.map((item) => item.category)},
  ];

  void _showCartPreview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child:
              widget.cart.items.isEmpty
                  ? const Center(child: Text("Cart is empty"))
                  : ListView.builder(
                    itemCount: widget.cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = widget.cart.items[index];
                      return Dismissible(
                        key: Key(cartItem.item.name),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          widget.cart.removeItem(cartItem.item);
                          Navigator.pop(context);
                          _showCartPreview(context);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          title: Text(cartItem.item.name),
                          subtitle: Text(
                            'RM${cartItem.item.price.toStringAsFixed(2)} x ${cartItem.quantity}',
                          ),
                          trailing: Text(
                            'RM${(cartItem.item.price * cartItem.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
        );
      },
    );
  }

  void _addToCart(MenuItem item) {
    widget.cart.addItem(item);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<MenuItem> filteredItems =
        selectedCategory == 'All'
            ? menuItems
            : menuItems
                .where((item) => item.category == selectedCategory)
                .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Menu'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children:
                    categories.map((category) {
                      bool isSelected = selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          selectedColor: Colors.orangeAccent,
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: filteredItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6,
                ),
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: Column(
                      children: [
                        Flexible(
                          flex: 1,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            child: Image.asset(
                              item.imagePath,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.description,
                                  style: const TextStyle(fontSize: 10),
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 9),
                                Text(
                                  "RM${item.price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.orange,
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _addToCart(item);
                                      widget.onAddToCart(item);
                                    },
                                    child: const Text("Add to Cart"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: () => _showCartPreview(context),
            child: const Icon(Icons.shopping_cart),
          ),
          if (widget.cart.items.isNotEmpty)
            Positioned(
              right: 0,
              top: 0,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  '${widget.cart.items.length}',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
