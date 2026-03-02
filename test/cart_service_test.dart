import 'package:app/models/product_model.dart';
import 'package:app/services/cart_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late CartService cartService;

  const uid = 'testUser';

  final product = ProductModel(
    id: 1,
    title: 'Shirt',
    price: 500,
     description:'',
    image: 'image.png',
  );

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    cartService = CartService(firestore: fakeFirestore);
  });

  test('Add product to cart', () async {
    await cartService.addToCart(uid, product);

    final snapshot = await fakeFirestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();

    expect(snapshot.docs.length, 1);
    expect(snapshot.docs.first['quantity'], 1);
  });

  test('Increase quantity', () async {
    await cartService.addToCart(uid, product);
    await cartService.increaseQuantity(uid, product.id.toString());

    final doc = await fakeFirestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(product.id.toString())
        .get();

    expect(doc['quantity'], 2);
  });

  test('Decrease quantity', () async {
    await cartService.addToCart(uid, product);
    await cartService.decreaseQuantity(uid, product.id.toString());

    final snapshot = await fakeFirestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();

    expect(snapshot.docs.length, 0);
  });

  test('Remove item from cart', () async {
    await cartService.addToCart(uid, product);
    await cartService.removeFromCart(uid, product.id.toString());

    final snapshot = await fakeFirestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();

    expect(snapshot.docs.length, 0);
  });
}
