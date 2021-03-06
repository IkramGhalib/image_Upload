import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider extends ChangeNotifier {
  File image;
  String pickerError = '';
  bool isPicAvail = false;
  String error = '';
  String email;

// shop data store
  double shopLatitude;
  double shopLongitude;
  String shopAddress;
  String placeName;
  

  Future<File> getImage() async {
    // final picker = ImagePicker();
    final tempFile =
        await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 15);
    if (tempFile != null) {
      this.image = File(tempFile.path);
    } else {
      this.pickerError = 'No Image Selected';
      print('No image selected');
      notifyListeners();
    }
    return this.image;
  }

  // Location Code Permission
  Future getCurrentAddress() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    this.shopLatitude = _locationData.latitude;
    this.shopLongitude = _locationData.longitude;
    notifyListeners();

    // From coordinates
    final coordinates =
        new Coordinates(_locationData.latitude, _locationData.longitude);
    var _addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var shopAddress = _addresses.first;
    this.shopAddress = shopAddress.addressLine;
    this.placeName = shopAddress.featureName;
    notifyListeners();
    return shopAddress;
    // print("${shopAddress.featureName} : ${shopAddress.addressLine}");
  }

  // Register shop using email and password
  Future<UserCredential> registerVendor(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password provided is too weak';
        print('The password provided is too weak.');
        notifyListeners();
      } else if (e.code == 'email-already-in-use') {
        this.error = 'The account already exists for that email.';
        notifyListeners();
        print('The account already exists for that email.');
      }
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

// Login of vendor
  Future<UserCredential> loginVendor(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.code;
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

// Reset Password
  Future<UserCredential> resetPassword(email) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.code;
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  // Save data into fireStore

  Future<void> saveVendorDataDB({String url, String shopName, String mobile}) {
    User user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendors =
        FirebaseFirestore.instance.collection('vendors').doc(user.uid);
    _vendors.set({
      'uid': user.uid,
      'shopName': shopName,
      'mobile': mobile,
      'email': this.email,
      'address': '${this.placeName}:${this.shopAddress}',
      'location': GeoPoint(this.shopLatitude, this.shopLongitude),
      'shopOpen': true,
      'rating': 0.0,
      'totalRating': 0.0,
      'isTopPick': true,
      'imageUrl': url,
      'accVerified': true,
    });
    return null;
  }
}
