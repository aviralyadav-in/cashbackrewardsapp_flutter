import 'package:flutter/material.dart';

class MissingTicketsScreen extends StatelessWidget {
  static const String routeName = '/missing-tickets';

  const MissingTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Missing Cashback'),
        centerTitle: true,
      ),
      // body: Center(
      //   child: Padding(
      //     padding: const EdgeInsets.all(24.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Container(
      //           width: 100,
      //           height: 100,
      //           decoration: BoxDecoration(
      //             shape: BoxShape.circle,
      //             color: Colors.orange.withValues(alpha: 0.1),
      //           ),
      //           child: const Icon(
      //             Icons.receipt_long_outlined,
      //             size: 50,
      //             color: Colors.orange,
      //           ),
      //         ),
      //         const SizedBox(height: 20),
      //         const Text(
      //           'Missing Cashback Help',
      //           style: TextStyle(
      //             fontSize: 20,
      //             fontWeight: FontWeight.bold,
      //           ),
      //           textAlign: TextAlign.center,
      //         ),
      //         const SizedBox(height: 12),
      //         Text(
      //           'Did not receive cashback for your order? Submit a ticket within 10 days of purchase and our team will trace it for you.',
      //           style: TextStyle(
      //             fontSize: 14,
      //             color: Colors.grey.shade600,
      //           ),
      //           textAlign: TextAlign.center,
      //         ),
      //         const SizedBox(height: 28),
      //         SizedBox(
      //           width: double.infinity,
      //           child: ElevatedButton.icon(
      //             onPressed: () {},
      //             icon: const Icon(Icons.add_comment_outlined),
      //             label: const Text('Add Missing Cashback Ticket'),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
