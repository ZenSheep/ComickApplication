// Create a function that will show you the modal

import 'package:flutter/material.dart';

Future displayErrorModal(BuildContext context, String message) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: 200,
        child: Column(
          children: [
            Text(message),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    },
  );
}