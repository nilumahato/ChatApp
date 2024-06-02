import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.brown.withOpacity(0.8),
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Colors.brown), // Set the color here
        ),
      ),
    );
  }
}
