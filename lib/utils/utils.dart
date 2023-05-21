import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sugam_krishi/models/cartItem.dart';

// for getting properly formatted Contact Number
String formatContact(String contact) {
  return contact.substring(0, 3) + " " + contact.substring(3);
}

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
