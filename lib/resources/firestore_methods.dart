import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sugam_krishi/models/marketplace.dart';
import 'package:sugam_krishi/models/post.dart';
import 'package:sugam_krishi/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> updateUserDetails({required Uint8List img, required String username, required String contact, required String uid}) async {
    // User currentUser = _auth.currentUser!;
    String res = "Some error Occurred";
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', img, false, false);
      // model.User _user = model.User(
      //   username: username,
      //   uid: currentUser.uid,
      //   photoUrl: photoUrl,
      //   email: currentUser.email!,
      //   contact: contact,
      // );
      await _firestore.collection("users").doc(uid).update({
        "username": username,
        "photoUrl": photoUrl,
        "contact": contact,
      });
      // .set(_user.toJson());
      //return _user;
      res = "success";
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  Future<String> uploadPost(String description, Uint8List? file, String uid,
      String username, String profImage, String location) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl = file == null
          ? ""
          : await StorageMethods()
              .uploadImageToStorage('posts', file, true, false);

      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        location: location,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> uploadMarketplaceItem(
      {String? description,
      required String uid,
      required String username,
      required String category,
      Uint8List? file,
      required String profImage,
      required String price,
      required String location,
      required String contact,
      required String itemName,
      String? quantity}) async {
    String res = "Some error occurred";
    try {
      String photoUrl = file == null
          ? ""
          : await StorageMethods()
              .uploadImageToStorage('marketplace', file, false, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      MarketPlace marketPlace = MarketPlace(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        category: category,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        price: price,
        location: location,
        contact: contact,
        itemName: itemName,
        quantity: quantity,
      );
      _firestore
          .collection('marketplace')
          .doc(postId)
          .set(marketPlace.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic, String location) async {
    String res = "Some error occurred";
    print("In FIrestore");
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'location': location,
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    print(res);
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
