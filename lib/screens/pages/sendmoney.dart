import 'package:flutter/material.dart';
import 'package:my_pocket_wallet/screens/pages/send_money_button.dart';

// SendMoneyPage widget for the Send Money screen.
class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  _SendMoneyPageState createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _formKey = GlobalKey<FormState>();
  String recipient = ''; // Store the recipient's details (name or number).
  double amount = 0.0; // Store the amount to send.
  String paymentMethod = ''; // Store the selected payment method.
  bool isFavorite = false; //mark as favourite

  // Function to confirm the transaction and navigate to confirmation page.
  void _confirmTransaction() {
    // If all fields are filled, navigate to the confirmation page.
    if (_formKey.currentState!.validate() && paymentMethod.isNotEmpty) {
      _formKey.currentState!.save(); // Save form field values
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionConfirmationPage(
            recipient: recipient,
            amount: amount,
            paymentMethod: paymentMethod,
            isFavorite: isFavorite,
          ),
        ),
      );
    } else if (paymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Money')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign form key
          child: Column(
            children: [
              // Recipient Field with validation
              TextFormField(
                decoration: const InputDecoration(labelText: 'Recipient'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a recipient name';
                  }
                  return null;
                },
                onSaved: (value) {
                  recipient = value!.trim();
                },
              ),
              const SizedBox(height: 16),

              // Amount Field with validation
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid positive amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  amount = double.parse(value!);
                },
              ),
              const SizedBox(height: 16),

              // Payment Method Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Payment Method'),
                value: paymentMethod.isEmpty ? null : paymentMethod,
                items: const [
                  DropdownMenuItem(
                      value: 'Bank Account', child: Text('Bank Account')),
                  DropdownMenuItem(
                      value: 'Mobile Wallet', child: Text('Mobile Wallet')),
                ],
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 16),

              // Favorite Switch
              SwitchListTile(
                title: const Text('Mark as Favorite'),
                value: isFavorite,
                onChanged: (value) {
                  setState(() {
                    isFavorite = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Confirm Button
              // ElevatedButton(
              //   onPressed: _confirmTransaction,
              //   child: const Text('Proceed to Confirm'),
              // ),

              //use the SendMoneyButton created
              SendMoneyButton(
                label: 'Proceed to Confirm',
                icon: Icons.arrow_forward,
                onPressed: _confirmTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TransactionConfirmationPage widget for displaying and confirming the transaction details.
class TransactionConfirmationPage extends StatelessWidget {
  final String recipient;
  final double amount;
  final String paymentMethod;
  final bool isFavorite;

  // Constructor to receive the transaction details.
  const TransactionConfirmationPage({
    Key? key,
    required this.recipient,
    required this.amount,
    required this.paymentMethod,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Confirm Transaction')), // AppBar with page title.
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the content.
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to the left.
          children: [
            const Text('Transaction Details',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)), // Heading text.
            const SizedBox(height: 16), // Spacer between heading and content.
            Text('Recipient: $recipient'), // Display recipient info.
            Text(
                'Amount: \$${amount.toStringAsFixed(2)}'), // Display amount with two decimals.
            Text(
                'Payment Method: $paymentMethod'), // Display selected payment method.
            Text('Marked as Favorite: ${isFavorite ? 'Yes' : 'No'}'), // NEW
            const SizedBox(height: 20), // Spacer before buttons.

            // Confirm Button to process the transaction
            ElevatedButton(
              onPressed: () {
                // Process the transaction (e.g., send request to backend).
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Transaction Successful')), // Success message.
                );
                Navigator.popUntil(
                    context,
                    (route) =>
                        route.isFirst); // Navigate back to the Dashboard.
              },
              child: const Text('Confirm and Send'), // Button text.
            ),
            const SizedBox(height: 10), // Spacer between buttons.

            // Cancel Button to go back to the Send Money page
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the Send Money page.
              },
              child: const Text('Cancel'), // Button text.
            ),
          ],
        ),
      ),
    );
  }
}
