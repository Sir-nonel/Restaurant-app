import 'package:flutter/material.dart';
import 'booking.dart';
import 'discount.dart';
import 'restaurant_main.dart';
import 'bookingpage.dart';

class ReceiptPage extends StatelessWidget {
  final double total;
  final Booking booking;

  const ReceiptPage({super.key, required this.total, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receipt')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Thank you, ${booking.name}!",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text("Booking Date: ${booking.date}"),
            Text("Time: ${booking.time}"),
            Text("Guests: ${booking.guests}"),
            Text("Duration: ${booking.duration}"),
            const SizedBox(height: 20),
            Text(
              "Total Paid: RM ${total.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Done"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
