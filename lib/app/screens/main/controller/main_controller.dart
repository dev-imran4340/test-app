import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_app/app/core/utils/ui.dart';
import 'package:test_app/app/models/cart_item.dart';
import 'package:test_app/app/routes/app_routes.dart';

class FoodItem {
  final String id;
  final String name;
  final String imageUrl;
  final String ingredients;
  final double price;

  FoodItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.ingredients,
    required this.price,
  });
}

class MainController extends GetxController {
  final storage = GetStorage();
  final googleSignIn = GoogleSignIn();

  var userId = ''.obs;
  var userEmail = ''.obs;
  var foodItems = <FoodItem>[].obs;

    final cartItems = <CartItem>[].obs;
  final isDrawerOpen = false.obs;

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) print('[MAIN] Initializing MainController...');
    userId.value = storage.read('userId') ?? '';
    userEmail.value = storage.read('userEmail') ?? '';
    if (kDebugMode) {
      print('[MAIN] User ID: ${userId.value}');
      print('[MAIN] User Email: ${userEmail.value}');
    }
    _loadDummyFoodItems();
  }

  void _loadDummyFoodItems() {
    foodItems.value = [
      FoodItem(
        id: '1',
        name: 'Margherita Pizza',
        imageUrl:
            'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
        ingredients: 'Tomato, Mozzarella, Basil',
        price: 1000,
      ),
      FoodItem(
        id: '2',
        name: 'Chicken Burger',
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        ingredients: 'Chicken, Lettuce, Tomato, Cheese',
        price: 800,
      ),
      FoodItem(
        id: '3',
        name: 'Caesar Salad',
        imageUrl:
            'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
        ingredients: 'Lettuce, Croutons, Parmesan, Caesar Dressing',
        price: 500,
      ),
      FoodItem(
        id: '4',
        name: 'Spaghetti Carbonara',
        imageUrl:
            'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=400',
        ingredients: 'Pasta, Bacon, Egg, Parmesan',
        price: 300,
      ),
      FoodItem(
        id: '5',
        name: 'Grilled Steak',
        imageUrl:
            'https://images.unsplash.com/photo-1600891964092-4316c288032e?w=400',
        ingredients: 'Beef, Herbs, Garlic Butter',
        price: 400,
      ),
      FoodItem(
        id: '6',
        name: 'Fish Tacos',
        imageUrl:
            'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=400',
        ingredients: 'Fish, Tortilla, Cabbage, Lime',
        price: 350,
      ),
      FoodItem(
        id: '7',
        name: 'Chicken Wings',
        imageUrl:
            'https://images.unsplash.com/photo-1608039755401-742074f0548d?w=400',
        ingredients: 'Chicken, Buffalo Sauce, Celery',
        price: 2000,
      ),
      FoodItem(
        id: '8',
        name: 'Veggie Wrap',
        imageUrl:
            'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=400',
        ingredients: 'Vegetables, Hummus, Tortilla',
        price: 4500,
      ),
    ];
    if (kDebugMode) print('[MAIN] Loaded ${foodItems.length} food items');
  }

  CartItem convertToCartItem(FoodItem item) {
    return CartItem(
      id: item.id,
      name: item.name,
      imageUrl: item.imageUrl,
      ingredients: item.ingredients,
      price: item.price,
    );
  }

  Future<void> logout() async {
    try {
      if (kDebugMode) print('[LOGOUT] Starting logout process...');

      await FirebaseAuth.instance.signOut();
      if (kDebugMode) print('[LOGOUT] Firebase sign out successful');

      await googleSignIn.signOut();
      if (kDebugMode) print('[LOGOUT] Google sign out successful');

      await storage.erase();
      if (kDebugMode) print('[LOGOUT] Local storage cleared');

      if (kDebugMode) print('[LOGOUT] Redirecting to login screen...');
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      if (kDebugMode) {
        print('[LOGOUT ERROR] Exception occurred: $e');
        print('  Type: ${e.runtimeType}');
      }
    }
  }

  void addToCart(CartItem item) {
    final existingIndex = cartItems.indexWhere((i) => i.id == item.id);

    if (existingIndex != -1) {
      cartItems[existingIndex].quantity++;
      cartItems.refresh();
      if (kDebugMode) print('[CART] Increased quantity for: ${item.name}');
    } else {
      cartItems.add(item);
      if (kDebugMode) print('[CART] Added new item: ${item.name}');
    }

    UI.showSnackBar(Get.context!, '${item.name} added to cart', isError: false);
  }

  void removeFromCart(String itemId) {
    cartItems.removeWhere((item) => item.id == itemId);
    if (kDebugMode) print('[CART] Removed item: $itemId');
  }

  void increaseQuantity(String itemId) {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
      if (kDebugMode) print('[CART] Increased quantity for item: $itemId');
    }
  }

  void decreaseQuantity(String itemId) {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh();
        if (kDebugMode) print('[CART] Decreased quantity for item: $itemId');
      } else {
        removeFromCart(itemId);
      }
    }
  }

  void toggleDrawer() {
    isDrawerOpen.value = !isDrawerOpen.value;
    if (kDebugMode) print('[CART] Drawer toggled: ${isDrawerOpen.value}');
  }

  void clearCart() {
    cartItems.clear();
    if (kDebugMode) print('[CART] Cart cleared');
  }
}


