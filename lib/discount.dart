import 'package:flutter/material.dart';
import 'menu.dart';

class DiscountPage extends StatefulWidget {
  final List<CartItem> cart;
  final double totalBeforeDiscount;
  final VoidCallback onPaymentConfirmed;

  const DiscountPage({
    super.key,
    required this.cart,
    required this.totalBeforeDiscount,
    required this.onPaymentConfirmed,
  });

  @override
  State<DiscountPage> createState() => DiscountPageState();
}

class DiscountPageState extends State<DiscountPage> {
  TextEditingController discountController = TextEditingController();

  bool showDiscountSection = false;
  bool _promptShown = false;
  int discountAttempts = 0;
  final int maxDiscountAttempts = 2;

  double finalPrice = 0.0;
  double totalBeforeDiscount = 0.0;
  double discount = 0.0;

  List<String> appliedCodes = [];

  @override
  void initState() {
    super.initState();
    totalBeforeDiscount = widget.totalBeforeDiscount;
    finalPrice = totalBeforeDiscount;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_promptShown) {
        _promptShown = true;
        _askDiscountPrompt();
      }
    });
  }

  void _askDiscountPrompt() async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Discount Code'),
            content: const Text('Do you want to use a discount code?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes'),
              ),
            ],
          ),
    );

    if (result == true) {
      setState(() {
        showDiscountSection = true;
      });
    }
  }

  void applyDiscount() {
    if (discountAttempts >= maxDiscountAttempts) return;

    setState(() {
      String code = discountController.text.trim().toUpperCase();

      if (appliedCodes.contains(code)) {
        _showDialog(
          'Code Already Used',
          'You have already used this discount code.',
        );
        return;
      }

      double codeDiscount = 0.0;

      if (code == '1MBRZ') {
        codeDiscount = 0.47;
      } else if (code == 'N33DDISC') {
        codeDiscount = 0.15;
      } else if (code == 'ABCB') {
        codeDiscount = 0.08;
      } else {
        _showDialog('Invalid Discount', 'Enter a valid code.');
        return;
      }

      appliedCodes.add(code);
      discount += codeDiscount;
      finalPrice = totalBeforeDiscount - (totalBeforeDiscount * discount);
      discountAttempts++;
    });
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  void confirmPayment() {
    widget.onPaymentConfirmed();
    setState(() {
      discountAttempts = 0;
      discountController.clear();
      discount = 0.0;
      finalPrice = widget.totalBeforeDiscount;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ReceiptPage(
              total: finalPrice,
              booking: widget.booking!, // pass the stored booking
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Items in Cart:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  final item = widget.cart[index];
                  return ListTile(
                    title: Text('${item.item.name} x${item.quantity}'),
                    trailing: Text(
                      'RM ${(item.item.price * item.quantity).toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
            ),
            if (showDiscountSection) ...[
              Text(
                'Enter Discount Code:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: discountController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
            ],
            Card(
              color: const Color(0xFF1F1F1F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'RM ${finalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You saved: RM ${(totalBeforeDiscount * discount).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        discountAttempts >= maxDiscountAttempts
                            ? null
                            : applyDiscount,
                    child: const Text('Apply Discount'),
                  ),
                ),
                const SizedBox(width: 10), // spacing between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: confirmPayment,
                    child: const Text("Confirm Payment"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
