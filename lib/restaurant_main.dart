import 'package:flutter/material.dart';
import 'discount.dart';
import 'cart.dart';
import 'menu.dart';
import 'reviews_page.dart';

class RestaurantApp extends StatefulWidget {
  final Cart cart = Cart();

  RestaurantApp({super.key});

  @override
  State<RestaurantApp> createState() => RestaurantAppState();
}

class RestaurantAppState extends State<RestaurantApp> {
  int selectedIndex = 0;

  void addToCart(MenuItem item) {
    setState(() {
      widget.cart.addItem(item);
    });
  }

  void resetCart() {
    setState(() {
      widget.cart.clear();
    });
  }

  Booking? currentBooking;

  void _navigateToBookingPage() async {
    final booking = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookingPage()),
    );

    if (booking != null && booking is Booking) {
      setState(() {
        currentBooking = booking;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      MenuPage(cart: widget.cart, onAddToCart: addToCart),
      DiscountPage(
        cart: widget.cart.items,
        totalBeforeDiscount: widget.cart.totalPrice,
        onPaymentConfirmed: resetCart,
      ),
      const ReviewsPage(),
    ];
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFD4AF37),
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Georgia', fontSize: 18),
          titleLarge: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.w500,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Color(0xFFD4AF37),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1F1F1F),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
      home: Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          backgroundColor: const Color(0xFF1F1F1F),
          selectedItemColor: const Color(0xFFD4AF37),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.book_online),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.discount),
              label: 'Discount',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.reviews),
              label: 'Reviews',
            ),
          ],
        ),
      ),
    );
  }
}
