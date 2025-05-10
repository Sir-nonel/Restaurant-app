import 'package:flutter/material.dart';

class ReviewsPage extends StatefulWidget {
  final String userName;
  const ReviewsPage({super.key, this.userName = "Anonymous"});

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final TextEditingController _reviewController = TextEditingController();
  double _userRating = 0;
  final List<Map<String, dynamic>> reviews = [];

  void _submitReview() {
    reviews.add({
      'name': widget.userName,
      'rating': _userRating,
      'review': _reviewController.text,
      'date': DateTime.now().toString().split(' ')[0],
    });

    if (_userRating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a rating!')));
      return;
    }

    setState(() {
      reviews.add({
        'rating': _userRating,
        'review': _reviewController.text,
        'date': DateTime.now().toString().split(' ')[0], // Format: YYYY-MM-DD
      });
      _reviewController.clear();
      _userRating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ratings & Reviews')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating Section
            const Text(
              'Rate your experience:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _userRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      _userRating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),

            // Review Input
            const Text(
              'Write a review:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'How was your dining experience?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitReview,
              child: const Text('Submit Review'),
            ),
            const SizedBox(height: 30),

            // Past Reviews
            const Text(
              'Customer Reviews:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child:
                  reviews.isEmpty
                      ? const Center(child: Text('No reviews yet.'))
                      : ListView.builder(
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${review['rating']} stars',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        review['date'],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(review['review']),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
